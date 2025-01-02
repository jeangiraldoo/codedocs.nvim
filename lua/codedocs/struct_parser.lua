local function search_return_recursively(ts_utils, child_nodes)
	local return_identifier = {
		return_statement = true
	}
	for _, node in ipairs(child_nodes) do
		local node_is_return = return_identifier[node:type()] or node:type() == "return"
		if node_is_return then
			return "unknown"
		elseif ts_utils.get_named_children(node) ~= nil then
			local result = search_return_recursively(ts_utils, ts_utils.get_named_children(node))
			if result then
				return result
			end
		end
	end
end

local function get_block_return_type(ts_utils, func_sections)
	local block_identifier = {
		block = true,
		statement_block = true,
		compound_statement = true,
		body_statement = true
	}

	local return_type
	for _, section in ipairs(func_sections) do
			local is_section_block = block_identifier[section:type()]
			if is_section_block then
				local block_children = ts_utils.get_named_children(section)
				return_type = search_return_recursively(ts_utils, block_children)
			end
		end
	return return_type
end

local function get_sig_return_type(ts_utils, func_sections)
	local type_identifier = {
		integral_type = true,
		type = true,
		type_annotation = true
	}

	local return_type
	for _, section in ipairs(func_sections) do
		local is_type_in_signature = type_identifier[section:type()] or string.match(section:type(), "_type")
		if is_type_in_signature then
			return_type = ts_utils.get_node_text(section)[1]
		end
	end
	return return_type
end

local function get_func_return_type(ts_utils, node)
	local func_sections = ts_utils.get_named_children(node)
	local return_type = get_sig_return_type(ts_utils, func_sections)
	if not return_type then
		return_type = get_block_return_type(ts_utils, func_sections)
	end
	return return_type
end

local function get_typed_param_data(ts_utils, is_type_in_docs, param)
	local type_identifiers = {
		type = true,
		integral_type = true,
		type_annotation = true,
		type_identifier = true,
		user_type = true
	}
	local name_identifiers = {
		identifier = true,
		simple_identifier = true
	}
	local param_data = ts_utils.get_named_children(param)
	local param_name, param_type
	for _, info in ipairs(param_data) do
		local is_name = name_identifiers[info:type()]
		local is_type = type_identifiers[info:type()]
		if is_name then
			param_name = ts_utils.get_node_text(info)[1]
		elseif is_type_in_docs and (is_type or string.match(info:type(), "_type")) then
			param_type = ts_utils.get_node_text(info)[1]
		end
	end
	return {param_name, param_type}
end

local function extract_func_params(node, ts_utils, is_type_in_docs)
	local param_section_identifiers = {
		formal_parameters = true,
		function_value_parameters = true,
		parameters = true,
		method_parameters = true
	}
	local typed_param_identifiers = {
		typed_parameter = true,
		required_parameter = true,
		formal_parameter = true,
		parameter = true
	}
	local untyped_param_identifiers = {
		identifier = true,
		simple_parameter = true
	}
	local func_sections = ts_utils.get_named_children(node)

  	local params = {}
	for _, func_section in ipairs(func_sections) do
		local is_param_section = param_section_identifiers[func_section:type()]
    	if is_param_section then
      		local param_section = ts_utils.get_named_children(func_section)
      		for _, param in ipairs(param_section) do
				local is_param_untyped = untyped_param_identifiers[param:type()]
				local is_param_typed = typed_param_identifiers[param:type()]
				local param_name, param_type
				if param and is_param_untyped then
					param_name = ts_utils.get_node_text(param)[1]
				elseif param and is_param_typed then
					local typed_param = get_typed_param_data(ts_utils, is_type_in_docs, param)
					param_name, param_type = typed_param[1], typed_param[2]
				end
			table.insert(params, {name = param_name, type = param_type})
    		end
    	end
	end
	return params
end

return {
	extract_func_params = extract_func_params,
	get_func_return_type = get_func_return_type
}
