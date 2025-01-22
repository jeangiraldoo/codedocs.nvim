local function validate_treesitter(lang)
	if not pcall(require, "nvim-treesitter.configs") then
  		vim.notify("Treesitter is not installed. Please install it.", vim.log.levels.ERROR)
		return false
	end
	local parsers = require "nvim-treesitter.parsers"

	if not parsers.has_parser(lang) then
    	vim.notify("The treesitter parser for " .. lang .. " is not installed", vim.log.levels.ERROR)
		return false
	end
	return true
end

local function iterate_child_nodes(node, node_type, result_table, collect)
    result_table = result_table or {}

	if not collect and #result_table > 0 then
		return
	elseif node:type() == node_type then
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
	local final_data =  {}
	final_data["type"] = def_val
	return (#child_data > 0) and {final_data} or {}
end


local function get_parsed_item_name_first(capture_name, items, current_item, node_text)
	if capture_name == "item_name" then
		if current_item.name ~= nil then
			table.insert(items, current_item)
			current_item = {}
			current_item.name = node_text
		else
			current_item.name = node_text
		end
	elseif capture_name == "item_type" then
		current_item.type = node_text
		table.insert(items, current_item)
		current_item = {}
	end
	return current_item
end

local function get_parsed_item_name_last(capture_name, items, current_item, node_text)
	if capture_name == "item_name" then
		current_item.name = node_text
		table.insert(items, current_item)
		current_item = {}
	elseif capture_name == "item_type" then
		current_item.type = node_text
	end
	return current_item
end

local function parse_simple_query(node, include_type, filetype, query, identifier_pos)
	include_type = true
	local items = {}
	if query == nil then
		return items
	end

	local query_obj = vim.treesitter.query.parse(filetype, query)
	local current_item = {}
	for id, capture_node, _ in query_obj:iter_captures(node, 0) do
		local capture_name = query_obj.captures[id]
		local node_text = vim.treesitter.get_node_text(capture_node, 0)

		if identifier_pos then
			current_item = get_parsed_item_name_first(capture_name, items, current_item, node_text)
		else
			current_item = get_parsed_item_name_last(capture_name, items, current_item, node_text)
		end
	end
	-- Add the leftover param to the list
	if next(current_item) ~= nil then
		table.insert(items, current_item)
	end

  	return items
end

local function get_trimmed_table(tbl)
	local trimmed_tbl = {}
	for _, inner_tbl in pairs(tbl) do
		for _, val in ipairs(inner_tbl) do
			table.insert(trimmed_tbl, val)
		end
	end
	return trimmed_tbl
end


local function parse_double_query_with_recursion(node, queries, identifier_pos)
	local filetype = vim.bo.filetype
	local first_query, second_query = queries[1], queries[2]
	local query_obj = vim.treesitter.query.parse(filetype, first_query)
	local nodes = {}
	for id, capture_node, _ in query_obj:iter_captures(node, 0) do
		local capture_name = query_obj.captures[id]
		if capture_name == "target" then
			iterate_child_nodes(capture_node, "attribute", nodes, true)
		end
	end
	local items = {}
	for _, node_item in ipairs (nodes) do
		local result = parse_simple_query(node_item, true, filetype, second_query, identifier_pos)
		table.insert(items, result)
	end
	return get_trimmed_table(items)
end


local function parse_multiple_queries(node, queries, identifier_pos, include_non_constructor_attrs)
	local filetype = vim.bo.filetype
	local accumulator = {}
	for _, query in ipairs(queries) do
		local result
		if type(query) == "string" then
			result = parse_simple_query(node, true, filetype, query, identifier_pos)
		else
			result = Parse_custom_query(node, query, identifier_pos, include_non_constructor_attrs)
		end
		table.insert(accumulator, result)
	end
	return get_trimmed_table(accumulator)
end

local function parse_boolean_query(node, queries, parse_first_query, identifier_pos)
	local filetype = vim.bo.filetype
	local query = (parse_first_query) and queries[1] or queries[2]
	local result
	for lol, _ in pairs(query) do
		if type(lol) == "number" then
			result = parse_simple_query(node, true, filetype, query, identifier_pos)
		else
			result = Parse_custom_query(node, query, identifier_pos, parse_first_query)
		end
	end
	return result
end

function Parse_custom_query(node, query, identifier_pos, settings)
	if query.find then
		return get_child_data_if_present(node, query.find)
	end

	if query.double_query_with_recursion then
		return parse_double_query_with_recursion(node, query.double_query_with_recursion, identifier_pos)
	end

	if query.query_accumulator then
		return parse_multiple_queries(node, query.query_accumulator, identifier_pos, settings)
	end

	if query.boolean then
		return parse_boolean_query(node, query.boolean, settings.boolean, identifier_pos)
	end
end


local function get_node_data(node, struct_name, sections, filetype, include_type, settings)
	local data = {}
	local lang_data = require("codedocs.node_parser.queries.init")[filetype]
	local identifier_pos = lang_data["identifier_pos"]
	local node_queries = lang_data[struct_name]
	for _, section_name in pairs(sections) do
		local section_queries = node_queries[section_name]
		local items = {}
		for _, section_query in pairs(section_queries) do
			if type(section_query) == "string" then
				items = parse_simple_query(node, include_type, filetype, section_query, identifier_pos)
			else
				items = Parse_custom_query(node, section_query, identifier_pos, settings)
			end

			if #items > 0 then break end
		end
		data[section_name] = items
	end
	return data
end

local function get_supported_node_data(node_at_cursor, supported_nodes)
	if node_at_cursor == nil then
		return "generic", node_at_cursor
	end

  	while node_at_cursor do
		local detected_node = supported_nodes[node_at_cursor:type()]
		if detected_node then
			return detected_node, node_at_cursor
		end

    -- If it's a module or another node, continue traversing upwards
    	node_at_cursor = node_at_cursor:parent()
  	end

  	return "generic", node_at_cursor
end

local function get_data(filetype, node, sections, struct_name, include_type, settings)
	local pos = vim.api.nvim_win_get_cursor(0)[1] - 1
	if struct_name == "generic" then
		return pos, {}
	else
		return node:range(), get_node_data(node, struct_name, sections, filetype, include_type, settings)
	end
end

local function get_node_type(filetype)
	if not validate_treesitter(filetype) then
		return "generic", nil
	end
	local lang_data = require("codedocs.node_parser.queries.init")[filetype]
	local supported_nodes = lang_data["nodes"]
	local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()
	return get_supported_node_data(node, supported_nodes)

end

return {
	get_data = get_data,
	get_node_type = get_node_type
}
