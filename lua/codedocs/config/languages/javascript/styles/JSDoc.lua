return {
	comment = {
		relative_position = "empty_target_or_above",
		blocks = {
			{
				name = "title",
				layout = {
					"// ${%snippet_tabstop_idx:description}",
				},
			},
		},
	},
	class = {
		relative_position = "above",
		blocks = {
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
				insert_gap_between = { text = " *" },
				items = {
					layout = {
						" * @property {%item_type} %item_name ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
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
					text = " *",
				},
			},
		},
	},
	func = {
		relative_position = "above",
		blocks = {
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
				insert_gap_between = { text = " *" },
				items = {
					layout = {
						" * @param {${%snippet_tabstop_idx:type}} %item_name ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						text = " *",
					},
				},
			},
			{
				name = "returns",
				insert_gap_between = { text = " *" },
				items = {
					layout = {
						" * @returns {${%snippet_tabstop_idx:type}} ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
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
					text = " *",
				},
			},
		},
	},
}
