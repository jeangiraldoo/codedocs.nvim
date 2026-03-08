return function(base_node)
	function base_node:process(original_ts_node, lang_name, struct_style)
		local result_nodes = self.callback(original_ts_node, self.children, lang_name, struct_style)
		return result_nodes
	end
	return base_node
end
