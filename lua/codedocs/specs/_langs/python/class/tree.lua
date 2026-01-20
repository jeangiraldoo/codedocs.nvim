local GET_METHOD_ATTRS = {
	type = "simple",
	query = [[
		(attribute
			(identifier) @item_name
			(#not-eq? @item_name "self")
		)
	]],
}

local FIND_METHOD_ATTRS = {
	type = "finder",
	collect_found_nodes = true,
	target_node_type = "attribute",
}

local GET_ALL_ATTRS = {
	type = "chain",
	children = {
		{
			type = "simple",
			query = [[
				class_definition
					body: (block
						(function_definition) @target
					)
				)
			]],
		},
		FIND_METHOD_ATTRS,
		GET_METHOD_ATTRS,
	},
}

local GET_ONLY_CONSTRUCTOR_ATTRS = {
	type = "chain",
	children = {
		{
			type = "simple",
			query = [[
				(class_definition
					body: (block
						(function_definition
							name: (identifier) @name
							(#eq? @name "__init__")
						) @target
					)
				)
			]],
		},
		FIND_METHOD_ATTRS,
		GET_METHOD_ATTRS,
	},
}

local INCLUDE_INSTANCE_ATTRS_OR_NOT = {
	type = "boolean",
	condition_opt_key = "include_instance_attrs",
	children = {
		{
			type = "boolean",
			condition_opt_key = "include_only_construct_instance_attrs",
			children = {
				GET_ONLY_CONSTRUCTOR_ATTRS,
				GET_ALL_ATTRS,
			},
		},
	},
}

return {
	attrs = {
		{
			type = "boolean",
			condition_opt_key = "include_class_attrs",
			children = {
				{
					type = "accumulator",
					children = {
						{
							type = "simple",
							query = [[
								(class_definition
									body: (block
										(expression_statement
											(assignment
												left: (_) @item_name
											)
										)
									)
								)
							]],
						},
						INCLUDE_INSTANCE_ATTRS_OR_NOT,
					},
				},
				INCLUDE_INSTANCE_ATTRS_OR_NOT,
			},
		},
	},
}
