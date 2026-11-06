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

---@param extractors table
---@param detection CodedocsDetectionResult
---@param provider_name string
---@param provider CodedocsDetectionProvider
return function(extractors, detection, provider_name, provider)
	local items = vim.iter(extractors):fold({}, function(acc, extractor_name, extractor_versions)
		local extractor = extractor_versions[provider_name]

		if not extractor or type(extractor) ~= "table" then
			vim.notify("No extractor for detection provider: " .. tostring(provider_name), vim.log.levels.WARN)
			acc[extractor_name] = {}

			return acc
		end

		if type(provider.extract) ~= "function" then
			vim.notify(
				"Detection provider " .. tostring(provider_name) .. " does not implement extract()",
				vim.log.levels.WARN
			)
			acc[extractor_name] = {}

			return acc
		end

		acc[extractor_name] = _dedup_items(provider.extract(detection, extractor, extractor_name) or {})

		return acc
	end)

	return items
end
