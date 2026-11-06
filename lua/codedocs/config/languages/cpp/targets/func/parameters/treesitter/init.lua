return {
	handler = function(detection, extractor_name, provider)
		local items =
			provider.extract_items(detection.node, provider.load_query(detection, extractor_name, "parameters"))

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
