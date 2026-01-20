return function(base_node)
	function base_node:process(ts_node, settings)
		local pattern = self.data.pattern
		local nodes = {}
		local node_text = vim.treesitter.get_node_text(ts_node, 0)

		local result = string.find(node_text, pattern)
		local expected_result = self.data.mode and true or nil
		if result == expected_result then
			local final = self.children[1]:process(ts_node, settings)
			table.insert(nodes, final)
		end
		return vim.iter(nodes):flatten():totable()
	end
	return base_node
end
