local GET_METHODS = [[
	(class_definition
		body: (block
			(function_definition) @target
		)
	)
]]

local GET_CONSTRUCTOR = [[
	(class_definition
		body: (block
			(function_definition
				name: (identifier) @name
				(#eq? @name "__init__")
			) @target
		)
	)
]]

local GET_METHOD_ATTRS = [[
	(attribute
		(identifier) @item_name
		(#not-eq? @item_name "self")
	)
]]

local FIND_METHOD_ATTRS = {
	type = "finder",
	data = {
		node_type = "attribute",
		mode = true,
		def_val = "",
	},
}

local GET_ALL_ATTRS = {
	type = "chain",
	children = { GET_METHODS, FIND_METHOD_ATTRS, GET_METHOD_ATTRS },
}

local GET_ONLY_CONSTRUCTOR_ATTRS = {
	type = "chain",
	children = { GET_CONSTRUCTOR, FIND_METHOD_ATTRS, GET_METHOD_ATTRS },
}

local GET_INSTANCE_ATTRS = {
	type = "boolean",
	children = { GET_ONLY_CONSTRUCTOR_ATTRS, GET_ALL_ATTRS },
}

local INCLUDE_INSTANCE_ATTRS_OR_NOT = {
	type = "boolean",
	children = { GET_INSTANCE_ATTRS },
}

return {
	attrs = {
		{
			type = "boolean",
			children = {
				{
					type = "accumulator",
					children = {
						{
							type = "simple",
							children = {
								[[
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
						},
						INCLUDE_INSTANCE_ATTRS_OR_NOT,
					},
				},
				INCLUDE_INSTANCE_ATTRS_OR_NOT,
			},
		},
	},
}
