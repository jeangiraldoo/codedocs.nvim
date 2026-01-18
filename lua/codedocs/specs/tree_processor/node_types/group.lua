return function(base_node, node_processor)
	function base_node:process(settings)
		local items = node_processor(self.children[1], settings)
		local groups = {}
		local name_group = {}
		for _, item_data in pairs(items) do
			local item_name, item_type = item_data.name, item_data.type
			if item_type ~= nil and item_name == nil then
				for _, final_name in pairs(name_group) do
					table.insert(groups, { name = final_name, type = item_type })
				end
				name_group = {}
			elseif item_type ~= nil and item_name ~= nil then
				table.insert(groups, { name = item_name, type = item_type })
			else
				table.insert(name_group, item_name)
			end
		end
		if #groups == 0 then return items end
		return groups
	end
	return base_node
end
