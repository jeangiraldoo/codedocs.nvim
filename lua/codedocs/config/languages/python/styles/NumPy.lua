return {
	comment = {
		placement = "current",
		blocks = {
			{
				name = "title",
				layout = {
					"# ${%snip_idx:description}",
				},
			},
		},
	},
	class = {
		placement = "below",
		blocks = {
			{
				name = "header",
				layout = {
					'%>"""',
					"%>${%snip_idx:title}",
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
						"%>%item_name : ${%snip_idx:%item_type}",
						"%>	${%snip_idx:description}",
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
		placement = "below",
		blocks = {
			{
				name = "header",
				layout = {
					'%>"""',
					"%>${%snip_idx:title}",
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
						"%>%item_name: ${%snip_idx:%item_type}",
						"%>	${%snip_idx:description}",
					},
				},
			},
			{
				name = "returns",
				layout = { "%>Returns", "%>-------" },
				insert_gap_between = { enabled = true },
				items = {
					layout = {
						"%>${%snip_idx:%item_type}",
						"%>	${%snip_idx:description}",
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
