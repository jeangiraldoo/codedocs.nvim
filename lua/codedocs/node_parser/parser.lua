local parse_query = require("codedocs.node_parser.query_processor").process_query

local function process_node(query, context)
	local filetype = vim.bo.filetype
	if type(query) == "string" then
		return parse_query(context.node, context.include_type, filetype, query, context.identifier_pos)
	elseif type(query) == "table" then
		return query:process(context)
	end
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

local function get_data(node, sections, struct_name, settings)
	local pos = vim.api.nvim_win_get_cursor(0)[1] - 1
	if struct_name == "comment" then
		return pos, {}
	else
		return node:range(), get_struct_items(node, sections, settings)
	end
end

return {
	get_data = get_data,
	process_node = process_node,
}
