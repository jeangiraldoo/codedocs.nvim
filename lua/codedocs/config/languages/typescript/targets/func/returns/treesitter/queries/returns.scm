[
	(method_definition
		return_type: (type_annotation
			[
				(predefined_type)
				(array_type)
				(union_type)
				(generic_type)
				(tuple_type)
				(type_identifier)
				(literal_type)
				(object_type)
				(function_type)
			] @item_type (#not-eq? @item_type "void")))
	(function_declaration
		return_type: (type_annotation
			[
				(predefined_type)
				(array_type)
				(union_type)
				(generic_type)
				(tuple_type)
				(type_identifier)
				(literal_type)
				(object_type)
				(function_type)
			] @item_type (#not-eq? @item_type "void")))
]
