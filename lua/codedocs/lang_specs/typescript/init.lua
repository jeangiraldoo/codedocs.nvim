local Class_extractors = {}

function Class_extractors.attrs(struct_data)
	local settings = struct_data.style.settings.item_extraction.attrs
	local results = {}

	if settings.include_class_attrs then
		local class_attrs = struct_data.lang_query_parser [[
			(class_body
				(public_field_definition
					"static"
					(property_identifier) @item_name))
		]]

		vim.list_extend(results, class_attrs)
	end

	if settings.include_instance_attrs then
		if settings.include_only_constructor_instance_attrs then
			local constructor_node = struct_data.lang_query_parser([[
				(class_body
					(method_definition
						(property_identifier) @name
						(#eq? @name "constructor")) @target)
			]])[1]

			if constructor_node then
				local constructor_instance_attrs = struct_data.generic_query_parser(
					constructor_node,
					struct_data.lang_name,
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

		local body_instance_attrs = struct_data.lang_query_parser [[
			(public_field_definition
				(property_identifier) @item_name
				(#not-match? @item_name "static"))
		]]

		local function_defined_instance_attrs = struct_data.lang_query_parser [[
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

local Func_extractors = {}

function Func_extractors.parameters(struct_data)
	return struct_data.lang_query_parser [[
		[
			(method_definition
				(formal_parameters
					(required_parameter
						(identifier) @item_name
						(type_annotation
							(predefined_type) @item_type))))
			(function_declaration
				(formal_parameters
					(required_parameter
						(identifier) @item_name
						(type_annotation
							(predefined_type) @item_type))))
		]
	]]
end

function Func_extractors.returns(struct_data)
	local items = struct_data.lang_query_parser [[
		[
			(method_definition
				(type_annotation
					[
						(predefined_type)
						(array_type)
					] @item_type (#not-eq? @item_type "void")))
			(function_declaration
				(type_annotation
					[
						(predefined_type)
						(array_type)
					] @item_type (#not-eq? @item_type "void")))
		]
	]]

	if #items > 0 then return items end

	return struct_data.lang_query_parser [[
		(return_statement
			(_) @item_type (#set! parse_as_blank "true"))
	]]
end

return {
	lang_name = "typescript",
	default_style = "TSDoc",
	identifier_pos = true,
	struct_identifiers = {
		method_definition = "func",
		function_declaration = "func",
		class_declaration = "class",
	},
	extractors = {
		class = Class_extractors,
		func = Func_extractors,
	},
}
