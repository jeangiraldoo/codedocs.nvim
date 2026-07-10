return function(target_data)
	return target_data.extract_items {
		query = target_data.load_query("returns"),
	}
end
