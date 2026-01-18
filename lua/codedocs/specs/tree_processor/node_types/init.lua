local current_dir = "codedocs.specs.tree_processor.node_types."

local function get_parsed_item_name_last(capture_name, node_text, current_item, include_type)
	if capture_name == "item_name" then
		return { name = node_text, type = current_item.type }, {}
	elseif capture_name == "item_type" and include_type then
		return nil, { name = current_item.name, type = node_text }
	else
		return nil, current_item
	end
end

local function get_parsed_item_name_first(capture_name, node_text, current_item, include_type)
	if capture_name == "item_name" then
		if current_item.name ~= nil then
			return current_item, { name = node_text }
		else
			return nil, { name = node_text }
		end
	elseif capture_name == "item_type" then
		if include_type then
			return { name = current_item.name, type = node_text }, {}
		else
			return { name = current_item.name }, {}
		end
	end
end

local function parse_items(node_captures, query_capture_tags, include_type, item_processor)
	local items = {}
	local current_item = {}
	for id, capture_node, _ in node_captures do
		local capture_name = query_capture_tags[id]
		local node_text = vim.treesitter.get_node_text(capture_node, 0)

		local new_item, new_current = item_processor(capture_name, node_text, current_item, include_type)
		if new_item then table.insert(items, new_item) end
		current_item = new_current
	end
	if next(current_item) ~= nil then table.insert(items, current_item) end

	return items
end

local function collect_target_capture_nodes(node_captures, query_capture_tags)
	local nodes = {}
	for id, capture_node, _ in node_captures do
		local capture_name = query_capture_tags[id]
		if capture_name == "target" then table.insert(nodes, capture_node) end
	end
	return nodes
end

local function parse_query(node, include_type, filetype, query, identifier_pos)
	if query == nil then return {} end

	local query_obj = vim.treesitter.query.parse(filetype, query)
	local node_captures = query_obj:iter_captures(node, 0)
	local query_capture_tags = query_obj.captures

	local result
	if vim.tbl_contains(query_capture_tags, "target") then
		result = collect_target_capture_nodes(node_captures, query_capture_tags)
	else
		local item_processor = (identifier_pos and get_parsed_item_name_first or get_parsed_item_name_last)
		result = parse_items(node_captures, query_capture_tags, include_type, item_processor)
	end
	return result
end

local function node_processor(query, context)
	local filetype = vim.bo.filetype
	if type(query) == "string" then
		return parse_query(context.node, context.include_type, filetype, query, context.identifier_pos)
	elseif type(query) == "table" then
		return query:process(context)
	end
end

return function(node_info)
	local node_type = node_info.type

	local type_index = {
		simple = "branch",
		boolean = "branch",
		accumulator = "branch",
		finder = "leaf",
		chain = "branch",
		regex = "branch",
		group = "branch",
	}
	local node_category = type_index[node_type]

	local new_node = vim.tbl_extend("force", {}, node_info)
	local extend_new_node = require(current_dir .. node_type)

	if node_category == "leaf" then return extend_new_node(new_node) end

	return extend_new_node(new_node, node_processor)
end
