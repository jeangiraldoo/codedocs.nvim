return function(base_node)
	function base_node:process(settings)
		local condition = settings.boolean_condition[1]
		local true_child = self.children[1]
		local false_child = self.children[2]

		if (not condition) and not false_child then
			table.remove(settings.boolean_condition, 1)
			return {}
		end

		local child_to_process = condition and true_child or (false_child or true_child)
		table.remove(settings.boolean_condition, 1)
		return child_to_process:process(settings)
	end
	return base_node
end
