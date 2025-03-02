local function get_node(data)
	local template, node_processor = unpack(data)
	local boolean_node = template:new()
	function boolean_node:process(settings)
		local condition = settings.boolean_condition[1]
		local true_child = self.children[1]
		local false_child = self.children[2] or ""
		local child_to_process = condition and true_child or false_child
		table.remove(settings.boolean_condition, 1)
		return node_processor(child_to_process, settings)
	end
	return boolean_node
end

return {
	get_node = get_node,
}
