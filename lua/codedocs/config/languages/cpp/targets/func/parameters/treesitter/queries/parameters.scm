(function_definition
	(function_declarator
		(parameter_list
			[
				(parameter_declaration
					type: [
						(primitive_type)
						(qualified_identifier)
						(struct_specifier
							(type_identifier))
						(sized_type_specifier)
						(type_identifier)
					] @item_type
					; Anything under the `declarator` field is considered to be the name.
					; Postprocessing is necessary for pointers
					declarator: (_) @item_name)
				(optional_parameter_declaration
					type: [
						(primitive_type)
						(qualified_identifier)
						(struct_specifier
							(type_identifier))
						(sized_type_specifier)
						(type_identifier)
					] @item_type
					; Anything under the `declarator` field is considered to be the name.
					; Postprocessing is necessary for pointers
					declarator: (_) @item_name)
			])))
