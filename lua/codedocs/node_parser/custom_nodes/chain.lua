local get_trimmed_table = require("codedocs.node_parser.custom_nodes.common").get_trimmed_table

local function process_results_using_child(result_nodes, child, settings, node_processor)
	local new_results = {}
	for _, node in ipairs(result_nodes) do
		settings.node = node
		if type(child) ~= "string" then child.children.nodes = node end
		local result = node_processor(child, settings)
		table.insert(new_results, result)
	end
	return get_trimmed_table(new_results)
end

local function get_node(data)
	local template, node_processor = data[1], data[2]
	local chain_node = template:new()
	function chain_node:process(settings)
		local original_node = settings.node
		local result_nodes = { original_node }
		for _, child in ipairs(self.children) do
			result_nodes = process_results_using_child(result_nodes, child, settings, node_processor)
		end
		settings.node = original_node
		return result_nodes
	end
	return chain_node
end

return {
	get_node = get_node
}
