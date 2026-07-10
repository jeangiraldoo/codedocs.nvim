(assignment
	left: (attribute
		object: (identifier) @obj
		attribute: (identifier) @item_name
	)
	(#eq? @obj "self")
	(#has-ancestor? @item_name function_definition))
