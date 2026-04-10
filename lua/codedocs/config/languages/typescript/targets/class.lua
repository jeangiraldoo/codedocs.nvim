local extractors = {}

function extractors.attributes(target_data)
	local results = {}

	if target_data.opts.attributes.static then
		local class_attrs = target_data.lang_query_parser [[
			(class_body
				(public_field_definition
					"static"
					(property_identifier) @item_name))
		]]

		vim.list_extend(results, class_attrs)
	end

	if target_data.opts.attributes.instance == "constructor" then
		local constructor_node = target_data.lang_query_parser([[
				(class_body
					(method_definition
						(property_identifier) @name
						(#eq? @name "constructor")) @target)
			]])[1]

		if constructor_node then
			local constructor_instance_attrs = target_data.generic_query_parser(
				constructor_node,
				target_data.lang_name,
				[[
						(assignment_expression
							(member_expression
								object: (this)
								property: (property_identifier) @item_name))
					]]
			)

			vim.list_extend(results, constructor_instance_attrs)
			return results
		end
	end

	if target_data.opts.attributes.instance == "all" then
		local body_instance_attrs = target_data.lang_query_parser [[
			(public_field_definition
				(property_identifier) @item_name
				(#not-match? @item_name "static"))
		]]

		local function_defined_instance_attrs = target_data.lang_query_parser [[
			(assignment_expression
				(member_expression
					object: (this)
					property: (property_identifier) @item_name (#has-ancestor? @item_name method_definition)))
		]]

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
