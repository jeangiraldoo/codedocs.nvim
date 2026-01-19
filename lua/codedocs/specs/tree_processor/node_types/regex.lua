return function(base_node)
	function base_node:process(settings)
		local pattern = self.data.pattern
		local node = self.children.nodes
		local nodes = {}
		local node_text = vim.treesitter.get_node_text(node, 0)

		local result = string.find(node_text, pattern)
		local expected_result = self.data.mode and true or nil
		if result == expected_result then
			settings.node = node
			local final = self.children[1]:process(settings)
			table.insert(nodes, final)
		end
		return vim.iter(nodes):flatten():totable()
	end
	return base_node
end
