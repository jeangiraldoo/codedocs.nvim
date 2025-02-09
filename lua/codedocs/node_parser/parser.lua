local parse_simple_query = require("codedocs.node_parser.query_processor").process_query
local get_lang_trees = require("codedocs.node_parser.custom_nodes.init").get_lang_trees

local function iterate_child_nodes(node, node_type, result_table, collect)
	result_table = result_table or {}

	if collect == false and node:type() == node_type then
		return table.insert(result_table, true)
	elseif collect == true and node:type() == node_type then
		table.insert(result_table, node)
	end

	for child in node:iter_children() do
		iterate_child_nodes(child, node_type, result_table, collect)
	end
end

local function get_child_data_if_present(node, query)
	local node_type = query[1]
	local def_val = query[2]
	local child_data = {}
	iterate_child_nodes(node, node_type, child_data, false)
	local final_data = {}
	final_data["type"] = def_val
	return (#child_data > 0) and { final_data } or {}
end

local function process_query(query, context)
	local filetype = vim.bo.filetype
	-- Handle different types of queries
	if type(query) == "string" then
		return parse_simple_query(context.node, context.include_type, filetype, query, context.identifier_pos)
	elseif type(query) == "table" then
		-- Recursively process nested queries
		return query:process(context)
	end
end

local function get_node_data(node, struct_name, sections, filetype, settings)
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

local function get_data(filetype, node, sections, struct_name, settings)
	local pos = vim.api.nvim_win_get_cursor(0)[1] - 1
	if struct_name == "comment" then
		return pos, {}
	else
		return node:range(), get_node_data(node, struct_name, sections, filetype, settings)
	end
end

return {
	get_data = get_data,
	process_query = process_query,
	iterate_child_nodes = iterate_child_nodes,
}
