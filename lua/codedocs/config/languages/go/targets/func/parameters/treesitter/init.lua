return {
	handler = function(detection, extractor_name, provider)
		local raw_items =
			provider.extract_items(detection.node, provider.load_query(detection, extractor_name, "parameters"))

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
