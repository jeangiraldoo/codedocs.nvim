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

local function search_node_recursively(node, node_type, def_val)
	local ts_utils = require("nvim-treesitter.ts_utils")
	for _, child_node in ipairs(ts_utils.get_named_children(node)) do
		if child_node:type() == node_type then
			return {{type = def_val}}
		elseif ts_utils.get_named_children(child_node) ~= nil then
			local result = search_node_recursively(child_node, node_type, def_val)
			if result then
				return result
			end
		end
	end
end

local function parse_node_with_identifier_first(node, include_type, filetype, queries, identifier_pos)
	local first_capture_name = (identifier_pos) and "item_name" or "item_type"
	local first_key_name = (identifier_pos) and "name" or "type"
	local second_capture_name = (identifier_pos) and "item_type" or "item_name"
	local second_key_name = (identifier_pos) and "type" or "name"
	include_type = true
	local data = {}
	if queries == nil then
		return data
	end

	local query_obj = vim.treesitter.query.parse(filetype, queries)
	local current_param = {}
	for id, capture_node, _ in query_obj:iter_captures(node, 0) do
		local capture_name = query_obj.captures[id]
		local node_text = vim.treesitter.get_node_text(capture_node, 0)

		if capture_name == first_capture_name then
			if next(current_param) ~= nil then
				table.insert(data, current_param)
			end
			current_param = {}
			current_param[first_key_name] = node_text
		elseif capture_name == second_capture_name then
			current_param[second_key_name] = node_text
		end
	end
-- Add the leftover param to the list
	if next(current_param) ~= nil then
		table.insert(data, current_param)
	end

  	return data
end

local function get_node_data(node, struct_name, sections, filetype, include_type)
	local data = {}
	local lang_data = require("codedocs.node_parser.queries.init")[filetype]
	local identifier_pos = lang_data["identifier_pos"]
	local node_queries = lang_data[struct_name]
	for _, section_name in pairs(sections) do
		local section_queries = node_queries[section_name]
		local section_data
		for _, section_query in pairs(section_queries) do
			if type(section_query) == "string" then
				section_data = parse_node_with_identifier_first(node, include_type, filetype, section_query, identifier_pos)
			else
				local node_type = section_query[1]
				local def_val = section_query[2]
				section_data = search_node_recursively(node, node_type, def_val)
				if section_data == nil then
					section_data = {}
				end
			end

			if #section_data > 0 then break end
		end
		data[section_name] = section_data
	end
	return data
end

local function is_node_a_class(node_type)
	local identifiers = {
		class_definition = true,
		class_declaration = true
	}
	return (identifiers[node_type]) and true or false
end

local function is_node_a_function(node_type)
	local identifiers = {
		function_definition = true,
		method_definition = true,
		function_declaration = true,
		method_declaration = true,
		method = true,
		function_item = true
	}

	return (identifiers[node_type]) and true or false
end

--- Traverses upwards through parent nodes to find a node of a supported type
-- @param node_at_cursor Node found at the cursor's position
local function get_struct_node_data(node_at_cursor)
	if node_at_cursor == nil then
		return "generic", node_at_cursor
	end

	if is_node_a_function(node_at_cursor:type()) then
		return "func", node_at_cursor
  	end

  	-- Traverse upwards through parent nodes to find a function or method declaration
  	while node_at_cursor do
		local node_type = node_at_cursor:type()
    	if is_node_a_function(node_type) then
      		return "func", node_at_cursor
		elseif is_node_a_class(node_type) then
			return "class", node_at_cursor
    	end

    -- If it's a module or another node, continue traversing upwards
    	node_at_cursor = node_at_cursor:parent()
  	end

  	return "generic", node_at_cursor
end

local function get_data(filetype, node, sections, struct_name, include_type)
	local pos = vim.api.nvim_win_get_cursor(0)[1] - 1
	if struct_name == "generic" then
		return pos, {}
	else
		return node:range(), get_node_data(node, struct_name, sections, filetype, include_type)
	end
end

local function get_node_type(filetype)
	if not validate_treesitter(filetype) then
		return "generic", nil
	else
		local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()
		return get_struct_node_data(node)
	end

end

return {
	get_data = get_data,
	get_node_type = get_node_type
}
