local Spec = require("codedocs.specs")
local opts = Spec.get_opts()

local CACHED_TREES = {}

-- @param structs Structure types to check for
-- @return string Structure name
-- @return vim.treesitter._tsnode
local function _determine_struc_under_cursor(struct_identifiers)
	vim.treesitter.get_parser(0):parse()
	local node_at_cursor = vim.treesitter.get_node()

	if node_at_cursor == nil then return "comment", node_at_cursor end

	while node_at_cursor do
		local node_type = node_at_cursor:type()
		local struct_name = struct_identifiers[node_type]

		if struct_name then return struct_name, node_at_cursor end

		node_at_cursor = node_at_cursor:parent()
	end
	return "comment", node_at_cursor
end

local function _cache_lang_struct_tree(lang, struct_name)
	local function _build_node(node)
		local new_node = vim.tbl_extend("force", {}, node)
		if new_node.children then new_node.children = vim.tbl_map(_build_node, node.children) end

		local extend_new_node = require("codedocs.specs.tree_processor.node_types." .. new_node.type)
		return extend_new_node(new_node)
	end

	CACHED_TREES[lang] = CACHED_TREES[lang] or {}
	if not CACHED_TREES[lang][struct_name] then
		local struct_trees_list = Spec:get_struct_tree(lang, struct_name)

		local final_tree = {}
		for struct_section_name, trees in pairs(struct_trees_list) do
			final_tree[struct_section_name] = vim.tbl_map(_build_node, trees)
		end
		CACHED_TREES[lang][struct_name] = final_tree
	end
end

local function _item_parser(lang, node, struct_name, struct_style)
	if not (CACHED_TREES[lang] and CACHED_TREES[lang][struct_name]) then _cache_lang_struct_tree(lang, struct_name) end

	local struct_cache = CACHED_TREES[lang][struct_name]

	local items = {}
	for _, section_name in pairs(struct_style.general.section_order) do
		local section_tree = struct_cache[section_name]

		items[section_name] = vim.iter(section_tree)
			:map(function(tree_node) return tree_node:process(node, struct_style) end)
			:find(
				function(section_items_list) return section_items_list and (not vim.tbl_isempty(section_items_list)) end
			) or {}
	end
	return items
end

return function(lang, style_name)
	local struct_name, node = _determine_struc_under_cursor(Spec.get_struct_identifiers(lang))

	local struct_style = style_name and Spec:get_struct_style(lang, struct_name, style_name)
		or Spec:_get_struct_main_style(lang, struct_name)

	local pos, data
	if struct_name == "comment" then
		pos = vim.api.nvim_win_get_cursor(0)[1] - 1
		data = {}
	else
		pos = node:range()
		data = _item_parser(lang, node, struct_name, struct_style)
	end

	return struct_name, data, struct_style, pos, opts
end
