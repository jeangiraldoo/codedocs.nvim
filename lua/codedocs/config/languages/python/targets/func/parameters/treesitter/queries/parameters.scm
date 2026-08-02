(parameters
	[
		(typed_parameter
			(identifier) @item_name
			(#not-eq? @item_name "self")
			(type) @item_type)
		(typed_default_parameter
			(identifier) @item_name
			(#not-eq? @item_name "self")
			(type) @item_type)
		(default_parameter
			(identifier) @item_name
			(#not-eq? @item_name "self")
		)
		(identifier) @item_name (#not-eq? @item_name "self")
	])
