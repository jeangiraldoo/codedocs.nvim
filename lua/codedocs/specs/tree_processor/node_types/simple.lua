return function(base_node, node_processor)
	function base_node:process(settings)
		local query = self.children[1]
		local final = node_processor(query, settings)
		return final
	end
	return base_node
end
