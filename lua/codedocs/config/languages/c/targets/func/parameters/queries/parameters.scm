(function_definition
	(function_declarator
		(parameter_list
			(parameter_declaration
				type: [
					(sized_type_specifier)
					(primitive_type)
					(struct_specifier
						(type_identifier))
					(type_identifier)
				] @item_type
				; Anything under `declarator` field is considered to be the name
				; Postprocessing is necessary for pointers
				declarator: (_) @item_name))))
