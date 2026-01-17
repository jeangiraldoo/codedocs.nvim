local Reader = require("codedocs.specs.reader")
local node_constructor = require("codedocs.specs.tree_processor.node_types")
local opts = Reader.get_opts()

local CACHED_TREES = {}

-- @param structs Structure types to check for
-- @return string Structure name
-- @return vim.treesitter._tsnode
local function _determine_struc_under_cursor(structs)
	vim.treesitter.get_parser(0):parse()
	local node_at_cursor = vim.treesitter.get_node()

	if node_at_cursor == nil then return "comment", node_at_cursor end

	while node_at_cursor do
		local node_type = node_at_cursor:type()
		local struct_name = structs[node_type]

		if struct_name then return struct_name, node_at_cursor end

		node_at_cursor = node_at_cursor:parent()
	end
	return "comment", node_at_cursor
end

local function _get_parser_settings(style, struct_name)
	local settings = {
		func = {
			params = {
				include_type = style.params and style.params[opts.include_type.val],
			},
			return_type = {
				include_type = style.return_type and style.return_type[opts.include_type.val],
			},
		},
		class = {
			attrs = {
				include_type = style.attrs and style.attrs[opts.include_type.val],
			},
			boolean_condition = {
				style.general[opts.include_class_body_attrs.val],
				style.general[opts.include_instance_attrs.val],
				style.general[opts.include_only_constructor_instance_attrs.val],
			},
		},
	}
	return settings[struct_name]
end

local function _get_struct_section_items(node, tree, settings, include_type)
	local items
	for _, tree_node in pairs(tree) do
		settings.include_type = include_type
		settings["node"] = node
		items = tree_node:process(settings) or {}

		if items and #items > 0 then break end
	end
	return items
end

local function _get_struct_items(node, sections, settings)
	local lang_node_trees = settings.tree
	local struct_sections = lang_node_trees.sections

	local items = {}
	for _, section_name in pairs(sections) do
		local include_type = settings[section_name].include_type
		local section_tree = struct_sections[section_name]
		items[section_name] = _get_struct_section_items(node, section_tree, settings, include_type)
	end
	return items
end

local function _build_node(node)
	local new_children
	if node.children then
		new_children = {}
		for i, child in ipairs(node.children) do
			if type(child) == "table" then
				new_children[i] = _build_node(child)
			else
				table.insert(new_children, child)
			end
		end
	end

	local new_node = {}
	for key, value in pairs(node) do
		if key ~= "children" then new_node[key] = value end
	end

	if new_children then new_node.children = new_children end

	return node_constructor(new_node)
end

local function _build_tree_list(list)
	local final_tree = {
		sections = {},
	}

	for section_name, trees in pairs(list.sections) do
		local section_list = {}

		for i, tree in ipairs(trees) do
			section_list[i] = _build_node(tree)
		end

		final_tree.sections[section_name] = section_list
	end

	return final_tree
end

local function _item_parser(node, sections, struct_name, style, identifier_pos)
	local pos = vim.api.nvim_win_get_cursor(0)[1] - 1
	if struct_name == "comment" then return pos, {} end

	if not CACHED_TREES[vim.bo.filetype] then CACHED_TREES[vim.bo.filetype] = {} end
	if not CACHED_TREES[vim.bo.filetype][struct_name] then
		local raw_tree_list = Reader:get_struct_tree(vim.bo.filetype, struct_name)
		CACHED_TREES[vim.bo.filetype][struct_name] = _build_tree_list(raw_tree_list)
	end

	local parser_settings = _get_parser_settings(style, struct_name)
	if struct_name ~= "comment" then
		parser_settings["identifier_pos"] = identifier_pos
		parser_settings["tree"] = CACHED_TREES[vim.bo.filetype][struct_name]
	end

	return node:range(), _get_struct_items(node, sections, parser_settings)
end

return function(lang, style_name)
	local struct_names = Reader:get_struct_names(lang)
	if not struct_names then return false end

	local struct_name, node = _determine_struc_under_cursor(struct_names)

	local style = style_name and Reader:get_struct_style(lang, struct_name, style_name)
		or Reader:_get_struct_main_style(lang, struct_name)
	local identifier_pos = Reader.get_lang_data(lang).identifier_pos

	local pos, data = _item_parser(node, style.general.section_order, struct_name, style, identifier_pos)

	return struct_name, data, style, pos, opts
end
