return {
	attrs = {
		{
			type = "accumulator",
			children = {
				{
					type = "simple",
					condition = function(struct_style)
						local data = struct_style["attrs"]

						return data["include_class_attrs"]
					end,
					query = [[
						(class_definition
							body: (block
								(expression_statement
									(assignment
										left: (_) @item_name))))
					]],
				},
				{
					type = "accumulator",
					condition = function(struct_style)
						local data = struct_style["attrs"]

						return data["include_instance_attrs"]
					end,
					children = {
						{
							type = "chain",
							condition = function(struct_style)
								local data = struct_style["attrs"]

								return data["include_only_constructor_instance_attrs"]
							end,
							children = {
								{
									type = "simple",
									query = [[
										(function_definition
											name: (identifier) @func_name
											(#eq? @func_name "__init__")) @target ]],
								},
								{
									type = "simple",
									query = [[
										(attribute
											(identifier) @item_name (#not-eq? @item_name "self")) ]],
								},
							},
						},
						{
							type = "simple",
							condition = function(struct_style)
								local data = struct_style["attrs"]

								return not data["include_only_constructor_instance_attrs"]
							end,
							query = [[
								(assignment
									left: (attribute
										object: (identifier) @obj
										attribute: (identifier) @item_name
									)
									(#eq? @obj "self")
									(#has-ancestor? @item_name function_definition)) ]],
						},
					},
				},
			},
		},
	},
}
