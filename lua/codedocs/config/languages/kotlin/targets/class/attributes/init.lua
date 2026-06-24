return function(target_data)
	local results = {}

	if target_data.opts.attributes.static then
		local class_attrs = target_data.extract_items {
			query = vim.treesitter.query.get("kotlin", "codedocs_class_static_attributes"),
		}

		vim.list_extend(results, class_attrs)
	end

	if target_data.opts.attributes.instance == "constructor" then
		local constructor_instance_attrs = target_data.extract_items {
			query = vim.treesitter.query.get("kotlin", "codedocs_class_constructor_instance_attrs"),
		}

		vim.list_extend(results, constructor_instance_attrs)
		return results
	end

	if target_data.opts.attributes.instance == "all" then
		local all_instance_attrs = target_data.extract_items {
			query = vim.treesitter.query.get("kotlin", "codedocs_class_all_instance_attributes"),
		}

		vim.list_extend(results, all_instance_attrs)
	end

	return results
end
