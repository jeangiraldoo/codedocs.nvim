return {

	handler = function(target_data)
		local query = target_data.load_query "constructor"

		local constructor_node = target_data.extract_ts_nodes(target_data.node, query)[1]

		local results = {}
		if constructor_node then
			results = target_data.extract_items(constructor_node, target_data.load_query "instance_attributes")
		end
		return results
	end,
}
