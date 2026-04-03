return {
	comment = {
		settings = {
			layout = {},
			relative_position = "empty_target_or_above",
			insert_at = 1,
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
			layout = {
				'"""',
				'"""',
			},
			relative_position = "below",
			insert_at = 2,
			indented = true,
		},
		sections = {
			{
				name = "title",
				layout = {
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
					"___________",
				},
				insert_gap_between = {
					enabled = false,
					text = "",
				},
				items = {
					layout = {
						"%item_name : ${%snippet_tabstop_idx:%item_type}",
						"	${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = "",
					},
				},
			},
		},
	},
	func = {
		settings = {
			layout = {
				'"""',
				'"""',
			},
			relative_position = "below",
			insert_at = 2,
			indented = true,
		},
		sections = {
			{
				name = "title",
				layout = {
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
					"Parameters",
					"----------",
				},
				insert_gap_between = {
					enabled = true,
					text = "",
				},
				items = {
					layout = {
						"%item_name: ${%snippet_tabstop_idx:%item_type}",
						"	${%snippet_tabstop_idx:description}",
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
					"Returns",
					"-------",
				},
				insert_gap_between = {
					enabled = true,
					text = "",
				},
				items = {
					layout = {
						"${%snippet_tabstop_idx:%item_type}",
						"	${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = "",
					},
				},
			},
		},
	},
}
