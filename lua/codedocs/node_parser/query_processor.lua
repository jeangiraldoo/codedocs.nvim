local function get_parsed_item_name_first(capture_name, items, current_item, node_text, include_type)
	if capture_name == "item_name" then
		if current_item.name ~= nil then
			table.insert(items, current_item)
			current_item = {}
			current_item.name = node_text
		else
			current_item.name = node_text
		end
	elseif capture_name == "item_type" and include_type then
		current_item.type = node_text
		table.insert(items, current_item)
		current_item = {}
	end
	return current_item
end

local function get_parsed_item_name_last(capture_name, items, current_item, node_text, include_type)
	if capture_name == "item_name" then
		current_item.name = node_text
		table.insert(items, current_item)
		current_item = {}
	elseif capture_name == "item_type" and include_type then
		current_item.type = node_text
	end
	return current_item
end

local function parse_simple_query(node, include_type, filetype, query, identifier_pos)
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
			current_item = get_parsed_item_name_first(capture_name, items, current_item, node_text, include_type)
		else
			current_item = get_parsed_item_name_last(capture_name, items, current_item, node_text, include_type)
		end
	end
	-- Add the leftover param to the list
	if next(current_item) ~= nil then
		table.insert(items, current_item)
	end
  	return items
end

return {
	process_query = parse_simple_query
}
