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
						(class_body
							(field_declaration
								(modifiers) @name (#match? @name "static")
								(type_identifier) @item_type
								(variable_declarator
									(identifier) @item_name)))
					]],
				},
				{
					type = "simple",
					condition = function(struct_style)
						local data = struct_style["attrs"]

						return data["include_instance_attrs"]
					end,
					query = [[
						(class_body
							(field_declaration
								(modifiers) @name
								(#not-match? @name "static")
								(type_identifier) @item_type
								(variable_declarator
									(identifier) @item_name)))
					]],
				},
			},
		},
	},
}
