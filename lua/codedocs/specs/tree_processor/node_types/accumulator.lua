return function(base_node, node_processor)
	function base_node:process(settings)
		local results = vim.iter(self.children)
			:map(function(query) return node_processor(query, settings) end)
			:flatten()
			:totable()
		return results
	end
	return base_node
end
