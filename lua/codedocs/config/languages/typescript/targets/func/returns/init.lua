return {
	treesitter = function(target_data)
		local items = target_data.extract_items {
			query = target_data.load_query "returns",
		}

		if #items > 0 then return items end

		local alt_items = target_data.extract_items {
			query = target_data.load_query "returns_alt",
		}
		for _, item in ipairs(alt_items) do
			item.type = ""
		end
		return alt_items
	end,
}
