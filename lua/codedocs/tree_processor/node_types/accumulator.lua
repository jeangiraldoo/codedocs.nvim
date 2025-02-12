local get_trimmed_table = require("codedocs.tree_processor.node_types.common").get_trimmed_table

local function get_node(data)
	local template, node_processor = data[1], data[2]
	local accumulator_node = template:new()
	function accumulator_node:process(settings)
		local results = {}
		for _, query in ipairs(self.children) do
			local result = node_processor(query, settings)
			table.insert(results, result)
		end
		return get_trimmed_table(results)
	end
	return accumulator_node
end

return {
	get_node = get_node
}
