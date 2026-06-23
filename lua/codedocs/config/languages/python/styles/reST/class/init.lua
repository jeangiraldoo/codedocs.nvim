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
					text = "",
					enabled = true,
				},
			},
			items = {
				layout = {
					"%>:var %item_name: ${%snip_idx:description}",
					"%>:vartype %item_name: ${%snip_idx:%item_type}",
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
