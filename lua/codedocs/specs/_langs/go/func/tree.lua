return {
	params = {
		{
			type = "function",
			callback = function(node, children, lang_name, struct_style)
				local raw_items = children[1]:process(node, lang_name, struct_style)

				local final_items = {}
				local standby = {}
				for _, item in ipairs(raw_items) do
					if item.name ~= "" and item.type == nil then
						table.insert(standby, item)
					elseif item.name ~= "" and item.type ~= "" then
						for _, standby_item in ipairs(standby) do
							standby_item.type = item.type
						end
						vim.list_extend(final_items, standby)
						standby = {}
						table.insert(final_items, item)
					end
				end

				return final_items
			end,
			children = {
				{
					type = "simple",
					query = [[
					(function_declaration
						(parameter_list
							(parameter_declaration
								(identifier) @item_name
								(type_identifier) @item_type
							)
						)
					)
					]],
				},
			},
		},
	},
	return_type = {
		{
			type = "simple",
			query = [[
				(function_declaration
					(type_identifier) @item_type
				)
			]],
		},
	},
}
