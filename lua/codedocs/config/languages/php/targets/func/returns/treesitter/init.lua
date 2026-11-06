return {
	handler = function(detection, extractor_name, provider)
		local items = provider.extract_items(detection.node, provider.load_query(detection, extractor_name, "returns"))

		if #items > 0 then return items end

		local alt_items =
			provider.extract_items(detection.node, provider.load_query(detection, extractor_name, "returns_alt"))
		for _, item in ipairs(alt_items) do
			item.type = ""
		end
		return alt_items
	end,
}
