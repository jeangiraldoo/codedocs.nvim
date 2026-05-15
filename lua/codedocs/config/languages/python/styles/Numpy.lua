return {
	comment = {
		relative_position = "empty_target_or_above",
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
		blocks = {
			{
				name = "header",
				layout = {
					'%>"""',
					"%>${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = true,
				},
			},
			{
				name = "attributes",
				layout = { "%>Attributes:", "%>___________" },
				items = {
					layout = {
						"%>%item_name : ${%snippet_tabstop_idx:%item_type}",
						"%>	${%snippet_tabstop_idx:description}",
					},
				},
			},
			{
				name = "footer",
				layout = {
					'%>"""',
				},
				ignore_prev_gap = true,
			},
		},
	},
	func = {
		relative_position = "below",
		blocks = {
			{
				name = "header",
				layout = {
					'%>"""',
					"%>${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = true,
				},
			},
			{
				name = "parameters",
				layout = { "%>Parameters", "%>----------" },
				insert_gap_between = { enabled = true },
				items = {
					layout = {
						"%>%item_name: ${%snippet_tabstop_idx:%item_type}",
						"%>	${%snippet_tabstop_idx:description}",
					},
				},
			},
			{
				name = "returns",
				layout = { "%>Returns", "%>-------" },
				insert_gap_between = { enabled = true },
				items = {
					layout = {
						"%>${%snippet_tabstop_idx:%item_type}",
						"%>	${%snippet_tabstop_idx:description}",
					},
				},
			},
			{
				name = "footer",
				layout = {
					'%>"""',
				},
				ignore_prev_gap = true,
			},
		},
	},
}
