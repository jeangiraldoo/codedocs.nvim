local get_lang_trees = require("codedocs.node_parser.query_nodes.init").get_lang_trees

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

local function process_query(query, context)
	local filetype = vim.bo.filetype
    -- Handle different types of queries
    if type(query) == "string" then
        return parse_simple_query(context.node, include_type, filetype, query, context.identifier_pos)
    elseif type(query) == "table" then
        -- Recursively process nested queries
        return query:process(context)
    end
end


local function get_node_data(node, struct_name, sections, filetype, include_type, settings)
	local data = {}
	local lang_data = get_lang_trees(filetype)
	local identifier_pos, lang_node_trees = lang_data["identifier_pos"], lang_data["trees"]
	local struct_sections = lang_node_trees[struct_name].sections
	for _, section_name in pairs(sections) do
		local section_tree = struct_sections[section_name]
		local items = {}
		for _, tree_node in pairs(section_tree) do
			settings["node"] = node
			settings.identifier_pos = identifier_pos
			items = tree_node:process(settings)

			if #items > 0 then break end
		end
		data[section_name] = items
	end
	return data
end

local function get_supported_node_data(node_at_cursor, lang_tree)
	if node_at_cursor == nil then
		return "comment", node_at_cursor
	end
	while node_at_cursor do
		for struct_name, value in pairs(lang_tree) do
			local node_identifiers = value["node_identifiers"]
			for _, id in pairs(node_identifiers) do
				if node_at_cursor:type() == id then
					return struct_name, node_at_cursor
				end
			end
		end
		node_at_cursor = node_at_cursor:parent()
	end
  	return "comment", node_at_cursor
end

local function get_data(filetype, node, sections, struct_name, include_type, settings)
	local pos = vim.api.nvim_win_get_cursor(0)[1] - 1
	if struct_name == "comment" then
		return pos, {}
	else
		return node:range(), get_node_data(node, struct_name, sections, filetype, include_type, settings)
	end
end

local function get_node_type(filetype)
	if not validate_treesitter(filetype) then
		return "comment", nil
	end
	local lang_data = get_lang_trees(filetype)
	local lang_trees = lang_data["trees"]
	local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()
	return get_supported_node_data(node, lang_trees)

end

return {
	get_data = get_data,
	get_node_type = get_node_type,
	process_query = process_query,
	iterate_child_nodes = iterate_child_nodes
}
