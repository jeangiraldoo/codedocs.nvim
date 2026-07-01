return {
	placement = "below",
	blocks = {
		{
			name = "header",
			item_names = {},
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
			item_names = { "attributes" },
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
			item_names = {},
			layout = {
				'%>"""',
			},
		},
	},
}
