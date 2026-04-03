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
					"# ${%snippet_tabstop_idx:description}",
				},
			},
		},
	},
	class = {
		settings = {
			relative_position = "below",
			indented = true,
		},
		sections = {
			{
				name = "header",
				layout = {
					'"""',
					"${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = true,
					text = "",
				},
			},
			{
				name = "attributes",
				layout = {
					"Attributes:",
				},
				insert_gap_between = {
					enabled = false,
					text = "",
				},
				items = {
					layout = {
						"%item_name (%item_type): ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = "",
					},
				},
			},
			{
				name = "footer",
				layout = {
					'"""',
				},
				ignore_prev_gap = true,
				insert_gap_between = {
					enabled = false,
					text = "",
				},
			},
		},
	},
	func = {
		settings = {
			relative_position = "below",
			indented = true,
		},
		sections = {
			{
				name = "header",
				layout = {
					'"""',
					"${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = true,
					text = "",
				},
			},
			{
				name = "parameters",
				layout = {
					"Args:",
				},
				insert_gap_between = {
					enabled = true,
					text = "",
				},
				items = {
					layout = {
						"%>%item_name (${%snippet_tabstop_idx:%item_type}): ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = "",
					},
				},
			},
			{
				name = "returns",
				layout = {
					"Returns:",
				},
				insert_gap_between = {
					enabled = false,
					text = "",
				},
				items = {
					layout = {
						"%>${%snippet_tabstop_idx:%item_type}: ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = "",
					},
				},
			},
			{
				name = "footer",
				layout = {
					'"""',
				},
				ignore_prev_gap = true,
				insert_gap_between = {
					enabled = false,
					text = "",
				},
			},
		},
	},
}
