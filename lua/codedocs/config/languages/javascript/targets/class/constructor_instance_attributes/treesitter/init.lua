return {
	handler = function(detection, extractor_name, provider)
		local q = provider.load_query(detection, extractor_name, "constructor")

		local constructor_node = provider.extract_nodes(detection.node, q)[1]

		local results = provider.extract_items(
			constructor_node,
			provider.load_query(detection, extractor_name, "method_instance_attributes")
		)
		return results
	end,
}
