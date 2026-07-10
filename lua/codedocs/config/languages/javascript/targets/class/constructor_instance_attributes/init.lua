return function(target_data)
	local q = target_data.load_query("constructor")

	local constructor_node = target_data.extract_ts_nodes({ query = q })[1]

	local results = target_data.extract_items {
		node = constructor_node,
		query = target_data.load_query("method_instance_attributes"),
	}
	return results
end
