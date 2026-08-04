local function _dedup_items(items)
	local dedup_items
	if vim.fn.has "nvim-0.12" == 1 then
		dedup_items = vim.iter(items):unique(function(item) return item.name end):totable()
	else ---TODO: remove when the minimum supported version is 0.12
		local seen = {}
		dedup_items = {}

		for _, item in ipairs(items) do
			local key = item.name or ""
			if not seen[key] then
				seen[key] = true
				table.insert(dedup_items, item)
			end
		end
	end

	local final_items = vim.iter(dedup_items)
		:map(function(item)
			if not item.name then item.name = "" end
			if not item.type then item.type = "" end
			return item
		end)
		:totable()

	return final_items
end

return function(extractors, target_data, detect_provider)
	local items = vim.iter(extractors):fold({}, function(acc, extractor_name, extractor_versions)
		local extractor = extractor_versions[detect_provider]

		if not extractor or type(extractor) ~= "table" then
			vim.notify("No extractor for detection provider: " .. tostring(detect_provider), vim.log.levels.WARN)
			acc[extractor_name] = {}

			return acc
		end

		target_data.extractor_name = extractor_name

		if type(extractor._ts_query_name) == "string" then
			acc[extractor_name] = _dedup_items(target_data.extract_items {
				node = target_data.node,
				query = target_data.load_query(extractor._ts_query_name),
			})
		elseif type(extractor.handler) == "function" then
			acc[extractor_name] = _dedup_items(extractor.handler(target_data) or {})
		else
			acc[extractor_name] = {}
		end

		return acc
	end)

	return items
end
