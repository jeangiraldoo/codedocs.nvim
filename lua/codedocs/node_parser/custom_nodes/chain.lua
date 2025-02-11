local get_trimmed_table = require("codedocs.node_parser.custom_nodes.common").get_trimmed_table
local query_parser = require("codedocs.node_parser.query_processor").process_query

local function get_child_node_results(result_nodes, child, settings, node_processor, original_node)
	local new_results = {}
	for _, node in ipairs(result_nodes) do
		settings.node = node
		child.children.nodes = node
		local result = node_processor(child, settings)
		table.insert(new_results, result)
		settings.node = original_node
	end
	return get_trimmed_table(new_results)
end

local function get_child_query_results(result_nodes, query)
	local filetype = vim.bo.filetype
	local new_results = {}
	for _, node in ipairs(result_nodes) do
		local result = query_parser(node, false, filetype, query, false)
		print(vim.inspect(result))
		table.insert(new_results, result)
	end
	return new_results
end

local function get_node(data)
	local template, node_processor = data[1], data[2]
	local chain_node = template:new()
	function chain_node:process(settings)
		local original_node = settings.node
		local result_nodes = { original_node }
		for _, child in ipairs(self.children) do
			local new_results = {}
			if type(child) ~= "string" then
				new_results = get_child_node_results(result_nodes, child, settings, node_processor, original_node)
			else
				new_results = get_child_query_results(result_nodes, child)
			end
			result_nodes = new_results
		end
		settings.node = original_node
		return result_nodes
	end
	return chain_node
end

return {
	get_node = get_node
}
