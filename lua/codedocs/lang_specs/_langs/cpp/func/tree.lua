return {
	parameters = {
		{
			type = "simple",
			query = [[
				(function_definition
					(function_declarator
						(parameter_list
							(parameter_declaration
								[
									(primitive_type)
									(qualified_identifier
										(type_identifier))
									(struct_specifier
										(type_identifier))
								] @item_type
								[
									(identifier)
									(pointer_declarator
										(identifier))
									(reference_declarator
										(identifier))
								] @item_name))))]],
		},
	},
	returns = {
		{
			type = "simple",
			query = [[
				(function_definition
					(primitive_type) @item_type (#not-eq? @item_type "void"))]],
		},
	},
}
