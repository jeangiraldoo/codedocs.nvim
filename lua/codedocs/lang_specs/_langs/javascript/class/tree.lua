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
									(field_definition
										"static"
										(property_identifier) @item_name)) ]],
						},
					},
				},
				{
					type = "accumulator",
					condition = function(struct_style)
						local data = struct_style["attrs"]

						return (data["include_instance_attrs"] and data["include_only_constructor_instance_attrs"])
					end,
					children = {
						{
							type = "chain",
							children = {
								{
									type = "simple",
									query = [[
										(class_body
											(method_definition
												(property_identifier) @name
												(#eq? @name "constructor")) @target) ]],
								},
								{
									type = "simple",
									query = [[
										(assignment_expression
											(member_expression
												(property_identifier) @item_name)) ]],
								},
							},
						},
					},
				},
				{
					type = "accumulator",
					condition = function(struct_style)
						local data = struct_style["attrs"]

						return (data["include_instance_attrs"] and not data["include_only_constructor_instance_attrs"])
					end,
					children = {
						{
							type = "simple",
							query = [[
								(class_body
									(field_definition
										property: (property_identifier) @item_name) @field (#not-match? @field "static")) ]],
						},
						{
							type = "simple",
							query = [[
								(assignment_expression
									(member_expression
										(property_identifier) @item_name)) ]],
						},
					},
				},
			},
		},
	},
}
