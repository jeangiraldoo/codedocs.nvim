(function_declaration
	(parameter_list
		(parameter_declaration
			(identifier) @item_name
			type: [
				(slice_type)
				(array_type)
				(map_type)
				(function_type)
				(channel_type)
				(pointer_type)
				(struct_type)
				(type_identifier)
			] @item_type)))
