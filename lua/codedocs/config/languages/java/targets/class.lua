local extractors = {}

function extractors.attributes(target_data)
	local results = {}
	if target_data.opts.attributes.static then
		local class_attrs = target_data.extract_items {
			query = vim.treesitter.query.get("java", "codedocs_class_static_attributes"),
		}
		vim.list_extend(results, class_attrs)
	end

	if target_data.opts.attributes.instance == "all" then
		local instance_attrs = target_data.extract_items {
			query = vim.treesitter.query.get("java", "codedocs_class_instance_attributes"),
		}
		vim.list_extend(results, instance_attrs)
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
			static = false,
			instance = "none", -- Java attrs can only be declared in the class body
		},
	},
}
