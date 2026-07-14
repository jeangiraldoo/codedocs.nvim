return {
	treesitter = function(target_data)
		local items = target_data.extract_items {
			query = target_data.load_query "parameters",
		}

		return vim.iter(items)
			:map(function(item)
				local prefix = item.name:match "^([%*&]+)"
				if prefix then
					item.name = item.name:sub(#prefix + 1)
					item.type = (item.type or "") .. prefix
				end
				return item
			end)
			:totable()
	end,
}
