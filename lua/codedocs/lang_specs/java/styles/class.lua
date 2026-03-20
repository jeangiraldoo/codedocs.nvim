return {
	JavaDoc = {
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
			item_extraction = {
				attributes = {
					include_class_attrs = false,
					include_instance_attrs = false,
					include_only_constructor_instance_attrs = nil, -- Java attrs can only be declared in the class body
				},
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
				layout = {
					" * Attributes:",
				},
				insert_gap_between = {
					enabled = false,
					text = " *",
				},
				items = {
					layout = {
						"// %item_name",
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
