local parse_query = require("codedocs.node_parser.query_processor").process_query

local function process_node(query, context)
	local filetype = vim.bo.filetype
	if type(query) == "string" then
		return parse_query(context.node, context.include_type, filetype, query, context.identifier_pos)
	elseif type(query) == "table" then
		return query:process(context)
	end
end

local function get_node_data(node, sections, settings)
	local data = {}
	local lang_node_trees = settings.tree
	local struct_sections = lang_node_trees.sections
	for _, section_name in pairs(sections) do
		local include_type = settings[section_name].include_type
		local section_tree = struct_sections[section_name]
		local items = {}
		for _, tree_node in pairs(section_tree) do
			settings.include_type = include_type
			settings["node"] = node
			items = tree_node:process(settings)
			items = items and (items) or {}

			if items and #items > 0 then
				break
			end
		end
		data[section_name] = items
	end
	return data
end

local function get_data(node, sections, struct_name, settings)
	local pos = vim.api.nvim_win_get_cursor(0)[1] - 1
	if struct_name == "comment" then
		return pos, {}
	else
		return node:range(), get_node_data(node, sections, settings)
	end
end

return {
	get_data = get_data,
	process_node = process_node,
}
