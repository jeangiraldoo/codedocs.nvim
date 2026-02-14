return function(base_node)
	function base_node:process(ts_node, lang_name, struct_style)
		local results = vim.iter(self.children)
			:map(function(child) return child:process(ts_node, lang_name, struct_style) end)
			:flatten()
			:totable()
		return results
	end
	return base_node
end
