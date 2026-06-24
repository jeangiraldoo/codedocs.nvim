local extractors = {}

function extractors.attributes(target_data)
	local results = {}

	if target_data.opts.attributes.static then
		local class_attrs = target_data.extract_items {
			query = vim.treesitter.query.get("typescript", "codedocs_class_static_attributes"),
		}

		vim.list_extend(results, class_attrs)
	end

	if target_data.opts.attributes.instance == "constructor" then
		local query = vim.treesitter.query.get("typescript", "codedocs_class_constructor")

		local constructor_node = target_data.extract_ts_nodes({ query = query })[1]

		if constructor_node then
			local constructor_instance_attrs = target_data.extract_items {
				node = constructor_node,
				query = vim.treesitter.query.get("typescript", "codedocs_class_constructor_instance_attributes"),
			}

			vim.list_extend(results, constructor_instance_attrs)
			return results
		end
	end

	if target_data.opts.attributes.instance == "all" then
		local body_instance_attrs = target_data.extract_items {
			query = vim.treesitter.query.get("typescript", "codedocs_class_body_instance_attributes"),
		}

		local function_defined_instance_attrs = target_data.extract_items {
			query = vim.treesitter.query.get("typescript", "codedocs_class_func_instance_attributes"),
		}

		vim.list_extend(results, body_instance_attrs)
		vim.list_extend(results, function_defined_instance_attrs)
	end

	return results
end

return {
	node_identifiers = {
		"class_declaration",
	},
	extractors = extractors,
	opts = {
		attributes = {
			static = true,
			instance = "none",
		},
	},
}
