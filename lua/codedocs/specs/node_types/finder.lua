local function _find_descendant_of_type(ts_node, target_type)
	for child in ts_node:iter_children() do
		if child:type() == target_type then return true end
		if _find_descendant_of_type(child, target_type) then return true end
	end
	return false
end

local function _collect_descendants_of_type(ts_node, target_type, descendant_collection)
	descendant_collection = descendant_collection or {}

	for child in ts_node:iter_children() do
		if child:type() == target_type then table.insert(descendant_collection, child) end
		_collect_descendants_of_type(child, target_type, descendant_collection)
	end

	return descendant_collection
end

return function(base_node)
	function base_node:process(ts_node)
		if self.collect_found_nodes then return _collect_descendants_of_type(ts_node, self.target_node_type) end

		if _find_descendant_of_type(ts_node, self.target_node_type) then
			return {
				{
					name = self.item_name_value_if_found or "",
					type = self.item_type_value_if_found or "",
				},
			}
		end
	end

	return base_node
end
