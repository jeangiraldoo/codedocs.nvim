return {
	handler = function(detection, extractor_name, provider)
		local query = provider.load_query(detection, extractor_name, "constructor")

		local constructor_node = provider.extract_nodes(detection.node, query)[1]

		local results = {}
		if constructor_node then
			results = provider.extract_items(
				constructor_node,
				provider.load_query(detection, extractor_name, "instance_attributes")
			)
		end
		return results
	end,
}
