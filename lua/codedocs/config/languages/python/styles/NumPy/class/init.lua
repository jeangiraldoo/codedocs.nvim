return {
	placement = "below",
	blocks = {
		{
			name = "header",
			layout = {
				'%>"""',
				"%>${%snip_idx:title}",
			},
			gap_before = {
				attributes = {
					text = "",
					enabled = true,
				},
			},
		},
		{
			name = "attributes",
			layout = { "%>Attributes:", "%>___________" },
			gap_before = {
				footer = {
					enabled = false,
					text = "",
				},
			},
			items = {
				{
					name = "attributes",
					layout = {
						"%>%item_name : ${%snip_idx:%item_type}",
						"%>	${%snip_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = "",
					},
					gap_before = {},
				},
			},
		},
		{
			name = "footer",
			layout = {
				'%>"""',
			},
		},
	},
}
