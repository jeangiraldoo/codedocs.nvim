local extractors = {}

function extractors.attributes(target_data)
	local results = {}

	if target_data.opts.attributes.static then
		local class_attrs = target_data.lang_query_parser [[
			(companion_object
				(class_body
					(property_declaration
						(variable_declaration
							(simple_identifier) @item_name
							(user_type) @item_type))))
		]]

		vim.list_extend(results, class_attrs)
	end

	if target_data.opts.attributes.instance == "constructor" then
		local constructor_instance_attrs = target_data.lang_query_parser [[
				(class_declaration
					(primary_constructor
						(class_parameter
							(binding_pattern_kind)
							(simple_identifier) @item_name
							(user_type) @item_type)))
			]]

		vim.list_extend(results, constructor_instance_attrs)
		return results
	end

	if target_data.opts.attributes.instance == "all" then
		local all_instance_attrs = target_data.lang_query_parser [[
			(class_declaration
				[
					(class_body
						(property_declaration
							(variable_declaration
								(simple_identifier) @item_name
								(user_type) @item_type)))
					(primary_constructor
						(class_parameter
							(binding_pattern_kind)
							(simple_identifier) @item_name
							(user_type) @item_type))
				])
		]]

		vim.list_extend(results, all_instance_attrs)
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
			instance = "none",
		},
	},
}
