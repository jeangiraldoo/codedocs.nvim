return {
	comment = {
		relative_position = "empty_target_or_above",
		indented = false,
		blocks = {
			{
				name = "title",
				layout = {
					"# ${%snippet_tabstop_idx:description}",
				},
			},
		},
	},
	class = {
		relative_position = "below",
		indented = true,
		blocks = {
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
				layout = { "Attributes:" },
				items = {
					layout = {
						"%item_name (%item_type): ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
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
			},
		},
	},
	func = {
		relative_position = "below",
		indented = true,
		blocks = {
			{
				name = "header",
				layout = {
					'"""',
					"${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = true,
				},
			},
			{
				name = "parameters",
				layout = { "Args:" },
				insert_gap_between = { enabled = true },
				items = {
					layout = {
						"%>%item_name (${%snippet_tabstop_idx:%item_type}): ${%snippet_tabstop_idx:description}",
					},
				},
			},
			{
				name = "returns",
				layout = { "Returns:" },
				items = {
					layout = {
						"%>${%snippet_tabstop_idx:%item_type}: ${%snippet_tabstop_idx:description}",
					},
				},
			},
			{
				name = "footer",
				layout = {
					'"""',
				},
				ignore_prev_gap = true,
			},
		},
	},
}
