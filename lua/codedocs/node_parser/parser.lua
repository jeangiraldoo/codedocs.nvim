local function parse_node_with_identifier_first(node, include_type, filetype, query, identifier_pos)
	local first_capture_name = (identifier_pos) and "item_name" or "item_type"
	local first_key_name = (identifier_pos) and "name" or "type"
	local second_capture_name = (identifier_pos) and "item_type" or "item_name"
	local second_key_name = (identifier_pos) and "type" or "name"
	include_type = true
	local data = {}
	if query == nil then
		return data
	end
	local query_obj = vim.treesitter.query.parse(filetype, query)

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
		elseif capture_name == "return" then
			current_param = {}
			current_param.name = node_text
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
		local section_query = node_queries[section_name]
		local section_data
		-- if identifier_pos then
		section_data = parse_node_with_identifier_first(node, include_type, filetype, section_query, identifier_pos)
		-- else
		-- 	section_data = parse_node_with_identifier_last(node, include_type, filetype, section_query)
		-- end
		data[section_name] = section_data
	end
	return data
end

local function get_data(node, style, opts, struct_name)
	local filetype = vim.bo.filetype
	local sections = style.general.section_order
	local include_type = style.general[opts.item.include_type.val]
	return get_node_data(node, struct_name, style.general.section_order, filetype, include_type)
end

return {
	get_data = get_data
}
