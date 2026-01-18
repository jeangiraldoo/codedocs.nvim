return function(base_node, node_processor)
	function base_node:process(settings)
		local condition = settings.boolean_condition[1]
		local true_child = self.children[1]
		local false_child = self.children[2] or ""
		local child_to_process = condition and true_child or false_child
		table.remove(settings.boolean_condition, 1)
		return node_processor(child_to_process, settings)
	end
	return base_node
end
