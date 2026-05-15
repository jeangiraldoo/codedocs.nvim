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
					text = "",
				},
			},
			{
				name = "attributes",
				layout = { "%>Attributes:" },
				items = {
					layout = {
						"%>%item_name (%item_type): ${%snip_idx:description}",
					},
					insert_gap_between = {
						text = "",
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
				layout = { "%>Args:" },
				insert_gap_between = { enabled = true },
				items = {
					layout = {
						"%>%>%item_name (${%snip_idx:%item_type}): ${%snip_idx:description}",
					},
				},
			},
			{
				name = "returns",
				layout = { "%>Returns:" },
				items = {
					layout = {
						"%>%>${%snip_idx:%item_type}: ${%snip_idx:description}",
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
