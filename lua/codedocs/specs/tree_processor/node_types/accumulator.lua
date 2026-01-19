return function(base_node)
	function base_node:process(settings)
		local results = vim.iter(self.children)
			:map(function(query) return query:process(settings) end)
			:flatten()
			:totable()
		return results
	end
	return base_node
end
