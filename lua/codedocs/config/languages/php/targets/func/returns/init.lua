return {
	treesitter = function(target_data)
		local items = target_data.extract_items {
			query = target_data.load_query("returns"),
		}

		if #items > 0 then return items end

		return target_data.extract_items {
			query = target_data.load_query("returns_alt"),
		}
	end,
}
