return {
	comment = {
		settings = {
			layout = {},
			relative_position = "empty_target_or_above",
			insert_at = 1,
			indented = false,
		},
		sections = {
			title = {
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
			section_order = {
				"attributes",
			},
			item_extraction = {
				attributes = {
					static = true,
					instance = "constructor",
				},
			},
			indented = true,
		},
		sections = {
			title = {
				layout = {
					"${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = true,
					text = "",
				},
			},
			attributes = {
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
			section_order = {
				"parameters",
				"returns",
			},
			indented = true,
		},
		sections = {
			title = {
				layout = {
					"${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = true,
					text = "",
				},
			},
			parameters = {
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
			returns = {
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
