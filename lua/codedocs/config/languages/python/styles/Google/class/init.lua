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
					enabled = true,
					text = "",
				},
			},
		},
		{
			name = "attributes",
			layout = { "%>Attributes:" },
			gap_before = {
				footer = {
					enabled = false,
					text = "",
				},
			},
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
		},
	},
}
