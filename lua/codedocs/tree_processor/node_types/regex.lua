local get_trimmed_table = require("codedocs.tree_processor.node_types.common").get_trimmed_table

local function get_node(data)
	local template, node_processor = data[1], data[2]
	local regex_node = template:new()
	function regex_node:process(settings)
		local pattern = self.data.pattern
		local node = self.children.nodes
		local nodes = {}
		local node_text = vim.treesitter.get_node_text(node, 0)
		local result = string.find(node_text, pattern)
		local expected_result = self.data.mode and true or nil
		if result == expected_result then
			settings.node = node
			local final = node_processor(self.data.query, settings)
			table.insert(nodes, final)
		end
		return get_trimmed_table(nodes)
	end
	return regex_node
end

return {
	get_node = get_node
}
