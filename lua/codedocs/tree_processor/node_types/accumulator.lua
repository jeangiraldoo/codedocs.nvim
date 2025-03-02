local function get_node(data)
	local template, node_processor = unpack(data)
	local accumulator_node = template:new()
	function accumulator_node:process(settings)
		local results = vim.iter(self.children)
			:map(function(query) return node_processor(query, settings) end)
			:flatten()
			:totable()
		return results
	end
	return accumulator_node
end

return {
	get_node = get_node,
}
