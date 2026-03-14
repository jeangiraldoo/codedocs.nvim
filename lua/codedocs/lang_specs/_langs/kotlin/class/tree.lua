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
						(companion_object
							(class_body
								(property_declaration
									(variable_declaration
										(simple_identifier) @item_name
										(user_type) @item_type))))
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
							type = "simple",
							condition = function(struct_style)
								local data = struct_style["attrs"]

								return data["include_only_constructor_instance_attrs"]
							end,
							query = [[
								(class_declaration
									(primary_constructor
										(class_parameter
											(binding_pattern_kind)
											(simple_identifier) @item_name
											(user_type) @item_type)))
							]],
						},
						{
							type = "simple",
							condition = function(struct_style)
								local data = struct_style["attrs"]

								return not data["include_only_constructor_instance_attrs"]
							end,
							query = [[
								(class_declaration
									[
										(class_body
											(property_declaration
												(variable_declaration
													(simple_identifier) @item_name
													(user_type) @item_type)))
										(primary_constructor
											(class_parameter
												(binding_pattern_kind)
												(simple_identifier) @item_name
												(user_type) @item_type))
									])
							]],
						},
					},
				},
			},
		},
	},
}
