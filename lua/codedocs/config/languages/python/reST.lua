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
				layout = {},
				insert_gap_between = {
					enabled = false,
					text = "",
				},
				items = {
					layout = {
						":var %item_name: ${%snippet_tabstop_idx:description}",
						":vartype %item_name: ${%snippet_tabstop_idx:%item_type}",
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
				layout = {},
				insert_gap_between = {
					enabled = false,
					text = "",
				},
				items = {
					layout = {
						":param %item_name: ${%snippet_tabstop_idx:description}",
						":type %item_name: ${%snippet_tabstop_idx:%item_type}",
					},
					insert_gap_between = {
						enabled = false,
						text = "",
					},
				},
			},
			{
				name = "returns",
				layout = {},
				insert_gap_between = {
					enabled = false,
					text = "",
				},
				items = {
					layout = {
						":return: ${%snippet_tabstop_idx:description}",
						":rtype: ${%snippet_tabstop_idx:%item_type}",
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
