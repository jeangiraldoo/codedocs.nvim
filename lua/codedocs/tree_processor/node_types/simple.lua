local function get_node(data)
	local template, node_processor = data[1], data[2]
	local simple_node = template:new()
	function simple_node:process(settings)
		local query = self.children[1]
		local final = node_processor(query, settings)
		return final
	end
	return simple_node
end

return {
	get_node = get_node
}
