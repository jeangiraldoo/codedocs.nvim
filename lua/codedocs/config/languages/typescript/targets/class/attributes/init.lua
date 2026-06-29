return function(target_data)
	local results = {}

	if target_data.opts.attributes.static then vim.list_extend(results, class_attrs) end

	if target_data.opts.attributes.instance == "constructor" then
	end

	if target_data.opts.attributes.instance == "all" then
	end

	return results
end
