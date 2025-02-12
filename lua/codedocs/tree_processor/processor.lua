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

local function parse_items(query_obj, include_type, node, item_processor)
	local items = {}
	local current_item = {}
	for id, capture_node, _ in query_obj:iter_captures(node, 0) do
		local capture_name = query_obj.captures[id]
		local node_text = vim.treesitter.get_node_text(capture_node, 0)

		local new_item, new_current = item_processor(capture_name, node_text, current_item, include_type)
		if new_item then
			table.insert(items, new_item)
		end
		current_item = new_current
	end
	if next(current_item) ~= nil then
		table.insert(items, current_item)
	end

	return items
end

local function get_node_matches(query_obj, node)
	local nodes = {}
	for id, capture_node, _ in query_obj:iter_captures(node, 0) do
		local capture_name = query_obj.captures[id]
		if capture_name == "target" then
			table.insert(nodes, capture_node)
		end
	end
	return nodes
end

local function parse_query(node, include_type, filetype, query, identifier_pos)
	if query == nil then
		return {}
	end

	local query_obj = vim.treesitter.query.parse(filetype, query)
	local has_target_capture = vim.tbl_contains(query_obj.captures, "target")
	local result
	if has_target_capture then
		result = get_node_matches(query_obj, node)
	else
		local item_processor = (identifier_pos and get_parsed_item_name_first or get_parsed_item_name_last)
		result = parse_items(query_obj, include_type, node, item_processor)
	end
	return result
end

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

return { process_node, get_data }
