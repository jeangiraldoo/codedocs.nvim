return function(target_data)
	local results = {}
	local body_instance_attrs = target_data.extract_items {
		query = target_data.load_query("body_instance_attributes"),
	}

	local function_defined_instance_attrs = target_data.extract_items {
		query = target_data.load_query("func_instance_attributes"),
	}

	vim.list_extend(results, body_instance_attrs)
	vim.list_extend(results, function_defined_instance_attrs)
	return results
end
