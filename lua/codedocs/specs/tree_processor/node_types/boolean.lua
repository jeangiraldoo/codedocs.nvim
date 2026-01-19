return function(base_node)
	function base_node:process(settings)
		local condition = settings.boolean[self.condition_opt_key]
		local true_child, false_child = unpack(self.children)

		if (not condition) and not false_child then return {} end

		local child_to_process = condition and true_child or (false_child or true_child)
		return child_to_process:process(settings)
	end
	return base_node
end
