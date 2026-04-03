return {
	comment = {
		settings = {
			relative_position = "empty_target_or_above",
			indented = false,
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
	class = {
		settings = {
			relative_position = "above",
			indented = false,
		},
		sections = {
			{
				name = "header",
				layout = {
					"/**",
					" * ${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = true,
					text = " *",
				},
			},
			{
				name = "attributes",
				layout = {},
				insert_gap_between = {
					enabled = false,
					text = " *",
				},
				items = {
					layout = {
						" * @property {%item_type} %item_name ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = " *",
					},
				},
			},
			{
				name = "footer",
				layout = {
					" */",
				},
				ignore_prev_gap = true,
				insert_gap_between = {
					enabled = false,
					text = " *",
				},
			},
		},
	},
	func = {
		settings = {
			relative_position = "above",
			indented = false,
		},
		sections = {
			{
				name = "title",
				layout = {
					"/**",
					" * ${%snippet_tabstop_idx:description}",
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
						" * @param {${%snippet_tabstop_idx:type}} %item_name ${%snippet_tabstop_idx:description}",
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
						" * @returns {${%snippet_tabstop_idx:type}} ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = " *",
					},
				},
			},
			{
				name = "footer",
				layout = {
					" */",
				},
				ignore_prev_gap = true,
				insert_gap_between = {
					enabled = false,
					text = " *",
				},
			},
		},
	},
}
