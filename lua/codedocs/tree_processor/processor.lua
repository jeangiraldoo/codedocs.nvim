local node_constructor = require("codedocs.tree_processor.node_types")

local function get_parser_settings(style, opts, struct_name)
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

local function get_struct_section_items(node, tree, settings, include_type)
	local items
	for _, tree_node in pairs(tree) do
		settings.include_type = include_type
		settings["node"] = node
		items = tree_node:process(settings) or {}

		if items and #items > 0 then break end
	end
	return items
end

local function get_struct_items(node, sections, settings)
	local lang_node_trees = settings.tree
	local struct_sections = lang_node_trees.sections

	local items = {}
	for _, section_name in pairs(sections) do
		local include_type = settings[section_name].include_type
		local section_tree = struct_sections[section_name]
		items[section_name] = get_struct_section_items(node, section_tree, settings, include_type)
	end
	return items
end

local function get_data(node, sections, struct_name, style, opts, identifier_pos)
	local pos = vim.api.nvim_win_get_cursor(0)[1] - 1
	if struct_name == "comment" then return pos, {} end

	local parser_settings = get_parser_settings(style, opts, struct_name)
	if struct_name ~= "comment" then
		parser_settings["identifier_pos"] = identifier_pos
		parser_settings["tree"] =
			require("codedocs.specs").reader:get_struct_tree(vim.bo.filetype, struct_name).get_tree(node_constructor)
	end

	return node:range(), get_struct_items(node, sections, parser_settings)
end

return get_data
