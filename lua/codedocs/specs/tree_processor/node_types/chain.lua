return function(base_node)
	function base_node:process(settings)
		local original_node = settings.node
		local result_nodes = { original_node }
		for _, child in ipairs(self.children) do
			result_nodes = vim.iter(result_nodes)
				:map(function(node)
					settings.node = node
					if child.type ~= "simple" then child.children.nodes = node end
					return child:process(settings)
				end)
				:flatten()
				:totable()
		end
		settings.node = original_node
		return result_nodes
	end
	return base_node
end
