return {
	Google = {
		settings = {
			layout = {
				'"""',
				'"""',
			},
			insert_at = 2,
			relative_position = "below",
			section_order = {
				"attributes",
			},
			item_extraction = {
				attributes = {
					include_class_attrs = true,
					include_instance_attrs = true,
					include_only_constructor_instance_attrs = true,
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
		},
	},
	Numpy = {
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
					include_class_attrs = true,
					include_instance_attrs = true,
					include_only_constructor_instance_attrs = true,
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
	reST = {
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
					include_class_attrs = true,
					include_instance_attrs = true,
					include_only_constructor_instance_attrs = true,
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
}
