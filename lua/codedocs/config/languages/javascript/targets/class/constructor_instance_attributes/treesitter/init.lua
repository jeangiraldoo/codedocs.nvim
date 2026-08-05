return {
	handler = function(target_data)
		local q = target_data.load_query "constructor"

		local constructor_node = target_data.extract_ts_nodes(target_data.node, q)[1]

		local results = target_data.extract_items(constructor_node, target_data.load_query "method_instance_attributes")
		return results
	end,
}
