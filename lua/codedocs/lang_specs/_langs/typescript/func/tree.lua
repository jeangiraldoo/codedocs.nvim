return {
	parameters = {
		{
			type = "simple",
			query = [[
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
				] ]],
		},
	},
	returns = {
		{
			type = "simple",
			query = [[
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
				] ]],
		},
		{
			type = "simple",
			query = [[
				(return_statement
					(_) @item_type (#set! parse_as_blank "true")) ]],
		},
	},
}
