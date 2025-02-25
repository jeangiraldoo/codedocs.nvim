local function get_node(data)
	local template, node_processor = unpack(data)
	local chain_node = template:new()
	function chain_node:process(settings)
		local original_node = settings.node
		local result_nodes = { original_node }
		for _, child in ipairs(self.children) do
			result_nodes = vim.iter(result_nodes)
				:map(function(node)
					settings.node = node
					if type(child) ~= "string" then child.children.nodes = node end
					return node_processor(child, settings)
				end)
				:flatten()
				:totable()
		end
		settings.node = original_node
		return result_nodes
	end
	return chain_node
end

return {
	get_node = get_node,
}
