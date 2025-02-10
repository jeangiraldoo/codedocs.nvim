local get_trimmed_table = require("codedocs.node_parser.custom_nodes.common").get_trimmed_table

local function get_node(data)
	local template, node_processor = data[1], data[2]
	local chain_node = template:new()
	function chain_node:process(settings)
		local filetype = vim.bo.filetype
		local original_node = settings.node
		local result_nodes = { original_node }
		for _, query in ipairs(self.children) do
			local new_results = {}
			if type(query) ~= "string" then
				for _, node in ipairs(result_nodes) do
					settings.node = node
					query.children.nodes = node
					local result = node_processor(query, settings)
					table.insert(new_results, result)
					settings.node = original_node
				end
				new_results = get_trimmed_table(new_results)
			else
				local query_obj = vim.treesitter.query.parse(filetype, query)
				for _, node in ipairs(result_nodes) do
					settings.node = node
					for id, capture_node, _ in query_obj:iter_captures(node, 0) do
						local node_text = vim.treesitter.get_node_text(capture_node, 0)
						local capture_name = query_obj.captures[id]
						if capture_name == "item_name" then
							settings.node = capture_node
							table.insert(new_results, { name = node_text })
						elseif capture_name == "target" then
							table.insert(new_results, capture_node)
						end
					end
				end
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
