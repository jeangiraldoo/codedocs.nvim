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
				},
			},
			{
				name = "attributes",
				items = {
					layout = {
						":var %item_name: ${%snippet_tabstop_idx:description}",
						":vartype %item_name: ${%snippet_tabstop_idx:%item_type}",
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
				items = {
					layout = {
						":param %item_name: ${%snippet_tabstop_idx:description}",
						":type %item_name: ${%snippet_tabstop_idx:%item_type}",
					},
				},
			},
			{
				name = "returns",
				items = {
					layout = {
						":return: ${%snippet_tabstop_idx:description}",
						":rtype: ${%snippet_tabstop_idx:%item_type}",
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
