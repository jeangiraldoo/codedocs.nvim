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
					[
						(identifier)
						(pointer_declarator
							(identifier))
						(reference_declarator
							(identifier))
					] @item_name)
				(optional_parameter_declaration
					type: [
						(primitive_type)
						(qualified_identifier)
						(struct_specifier
							(type_identifier))
						(sized_type_specifier)
						(type_identifier)
					] @item_type
					[
						(identifier)
						(pointer_declarator
							(identifier))
						(reference_declarator
							(identifier))
					] @item_name)
			])))
