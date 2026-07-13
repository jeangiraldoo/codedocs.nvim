return {
	treesitter = function(target_data)
		local raw_items = target_data.extract_items {
			query = target_data.load_query "parameters",
		}

		local final_items = {}
		local standby = {}

		for _, item in ipairs(raw_items) do
			if item.name ~= "" and item.type == nil then
				table.insert(standby, item)
			elseif item.name ~= "" and item.type ~= "" then
				for _, standby_item in ipairs(standby) do
					standby_item.type = item.type
				end
				vim.list_extend(final_items, standby)
				standby = {}
				table.insert(final_items, item)
			end
		end

		return final_items
	end,
}
