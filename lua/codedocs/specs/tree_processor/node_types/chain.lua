return function(base_node)
	function base_node:process(original_ts_node, settings)
		local result_nodes = { original_ts_node }
		for _, child in ipairs(self.children) do
			result_nodes = vim.iter(result_nodes)
				:map(function(node) return child:process(node, settings) end)
				:flatten()
				:totable()
		end
		return result_nodes
	end
	return base_node
end
