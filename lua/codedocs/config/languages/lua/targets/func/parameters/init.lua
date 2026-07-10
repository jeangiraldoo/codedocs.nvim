return function(target_data)
	local t = target_data.load_query("parameters")
	return target_data.extract_items {
		query = t,
	}
end
