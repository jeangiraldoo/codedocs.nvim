return {
	comment = {
		settings = {
			layout = {},
			insert_at = 1,
			relative_position = "empty_target_or_above",
			indented = false,
		},
		sections = {
			title = {
				layout = {
					"// ${%snippet_tabstop_idx:description}",
				},
			},
		},
	},
	class = {
		settings = {
			layout = {
				"/**",
				" */",
			},
			relative_position = "above",
			insert_at = 2,
			section_order = {
				"attributes",
			},
			indented = false,
		},
		sections = {
			title = {
				layout = {
					" * ${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = true,
					text = " *",
				},
			},
			attributes = {
				layout = {},
				insert_gap_between = {
					enabled = false,
					text = " *",
				},
				items = {
					layout = {},
					insert_gap_between = {
						enabled = false,
						text = " *",
					},
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
			relative_position = "above",
			insert_at = 2,
			section_order = {
				"parameters",
				"returns",
			},
			indented = false,
		},
		sections = {
			title = {
				layout = {
					" * ${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = true,
					text = " *",
				},
			},
			parameters = {
				layout = {},
				insert_gap_between = {
					enabled = false,
					text = " *",
				},
				items = {
					layout = {
						" * @param %item_name ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = " *",
					},
				},
			},
			returns = {
				layout = {},
				insert_gap_between = {
					enabled = false,
					text = " *",
				},
				items = {
					layout = {
						" * @return ${%snippet_tabstop_idx:description}",
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
