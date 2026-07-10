return function(target_data)
	local params = target_data.extract_items {
		query = target_data.load_query("parameters"),
	}

	return params
end
