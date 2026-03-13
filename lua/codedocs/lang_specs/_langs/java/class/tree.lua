return {
	attrs = {
		{
			type = "accumulator",
			children = {
				{
					type = "accumulator",
					condition = function(struct_style)
						local data = struct_style["attrs"]

						return data["include_class_attrs"]
					end,
					children = {
						{
							type = "simple",
							query = [[
								(class_body
									(field_declaration
										(modifiers) @name (#match? @name "static")
										(type_identifier) @item_type
										(variable_declarator
											(identifier) @item_name))) ]],
						},
					},
				},
				{
					type = "accumulator",
					condition = function(struct_style)
						local data = struct_style["attrs"]

						return data["include_instance_attrs"]
					end,
					children = {
						{
							type = "simple",
							query = [[
								(class_body
									(field_declaration
										(modifiers) @name
										(#not-match? @name "static")
										(type_identifier) @item_type
										(variable_declarator
											(identifier) @item_name))) ]],
						},
					},
				},
			},
		},
	},
}
