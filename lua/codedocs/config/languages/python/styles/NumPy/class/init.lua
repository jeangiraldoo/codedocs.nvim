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
			gap_before = {
				footer = {
					enabled = false,
					text = "",
				},
			},
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
		},
	},
}
