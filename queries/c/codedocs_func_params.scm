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
				[
					(identifier)
					(pointer_declarator
						(identifier))
				] @item_name))))
