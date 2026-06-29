return function(target_data)
	local class_body_instance_attrs = target_data.extract_items {
		query = vim.treesitter.query.get("javascript", "codedocs_class_body_instance_attributes"),
	}

	local function_defined_instance_attrs = target_data.extract_items {
		query = vim.treesitter.query.get("javascript", "codedocs_class_method_instance_attributes"),
	}

	local results = {}
	vim.list_extend(results, class_body_instance_attrs)
	vim.list_extend(results, function_defined_instance_attrs)

	return results
end
