return function(base_node)
	function base_node:process(original_ts_node, struct_style)
		local result_nodes = { original_ts_node }
		for _, child in ipairs(self.children) do
			result_nodes = vim.iter(result_nodes)
				:map(function(node) return child:process(node, struct_style) end)
				:flatten()
				:totable()
		end
		return result_nodes
	end
	return base_node
end
