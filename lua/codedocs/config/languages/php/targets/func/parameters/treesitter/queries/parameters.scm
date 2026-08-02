parameters: (formal_parameters
	(simple_parameter
		type: [
		  (primitive_type) @item_type
		  (union_type) @item_type
		  (named_type) @item_type
		  (disjunctive_normal_form_type) @item_type
		  (intersection_type) @item_type
		]?
		name: (variable_name
			(name) @item_name)))
