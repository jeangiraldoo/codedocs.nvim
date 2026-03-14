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
							(public_field_definition
								"static"
								(property_identifier) @item_name))
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
										(class_body
											(method_definition
												(property_identifier) @name
												(#eq? @name "constructor")) @target)
									]],
								},
								{
									type = "simple",
									query = [[
										(assignment_expression
											(member_expression
												(property_identifier) @item_name))
									]],
								},
							},
						},
						{
							type = "accumulator",
							condition = function(struct_style)
								local data = struct_style["attrs"]

								return not data["include_only_constructor_instance_attrs"]
							end,
							children = {
								{
									type = "simple",
									query = [[
										(public_field_definition
											(property_identifier) @item_name
											(#not-match? @item_name "static"))
									]],
								},
								{
									type = "simple",
									query = [[
										(assignment_expression
											(member_expression
												object: (this)
												property: (property_identifier) @item_name (#has-ancestor? @item_name method_definition)))
									]],
								},
							},
						},
					},
				},
			},
		},
	},
}
