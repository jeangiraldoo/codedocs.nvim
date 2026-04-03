return {
	comment = {
		settings = {
			layout = {},
			insert_at = 1,
			relative_position = "empty_target_or_above",
			indent = false,
		},
		sections = {
			{
				name = "title",
				layout = {
					"// ${%snippet_tabstop_idx:description}",
				},
			},
		},
	},
	func = {
		settings = {
			layout = {
				"/**",
				" */",
			},
			insert_at = 2,
			relative_position = "above",
			indent = false,
		},
		sections = {
			{
				name = "title",
				layout = {
					" * ${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = true,
					text = " *",
				},
			},
			{
				name = "parameters",
				layout = {},
				insert_gap_between = {
					enabled = false,
					text = " *",
				},
				items = {
					layout = {
						" * @param ${%snippet_tabstop_idx:%item_type} \\$%item_name ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = " *",
					},
				},
			},
			{
				name = "returns",
				layout = {},
				insert_gap_between = {
					enabled = false,
					text = " *",
				},
				items = {
					layout = {
						" * @return ${%snippet_tabstop_idx:%item_type} ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = " *",
					},
				},
			},
		},
	},
}
