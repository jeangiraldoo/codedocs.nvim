return {
	handler = function(target_data)
		local items = target_data.extract_items(target_data.node, target_data.load_query "returns")
		for _, item in ipairs(items) do
			item.type = ""
		end
		return items
	end,
}
