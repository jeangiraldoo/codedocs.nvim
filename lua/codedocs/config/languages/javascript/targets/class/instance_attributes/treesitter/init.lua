return {
	handler = function(detection, extractor_name, provider)
		local class_body_instance_attrs = provider.extract_items(
			detection.node,
			provider.load_query(detection, extractor_name, "body_instance_attributes")
		)

		local function_defined_instance_attrs = provider.extract_items(
			detection.node,
			provider.load_query(detection, extractor_name, "method_instance_attributes")
		)

		local results = {}
		vim.list_extend(results, class_body_instance_attrs)
		vim.list_extend(results, function_defined_instance_attrs)

		return results
	end,
}
