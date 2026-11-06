return {
	handler = function(detection, extractor_name, provider)
		local items = provider.extract_items(detection.node, provider.load_query(detection, extractor_name, "returns"))
		for _, item in ipairs(items) do
			item.type = ""
		end
		return items
	end,
}
