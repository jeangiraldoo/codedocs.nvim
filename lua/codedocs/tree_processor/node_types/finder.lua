local function iterate_child_nodes(node, node_type, result_table, collect)
	result_table = result_table or {}

	if collect == false and node:type() == node_type then
		return table.insert(result_table, true)
	elseif collect == true and node:type() == node_type then
		table.insert(result_table, node)
	end

	for child in node:iter_children() do
		iterate_child_nodes(child, node_type, result_table, collect)
	end
end

local function get_node(data)
	local template = data[1]
	local finder_node = template:new()
	function finder_node:process(settings)
		local node = settings.node
		local node_type = self.data.node_type
		local def_val = self.data.def_val
		local mode = self.data.mode
		local child_data = {}
		iterate_child_nodes(node, node_type, child_data, mode)
		local final_data = {}
		if mode then
			final_data = child_data
			return final_data
		else
			if child_data[1] then
				final_data["type"] = def_val
				return { final_data }
			end
		end
	end
	return finder_node
end

return {
	get_node = get_node
}
