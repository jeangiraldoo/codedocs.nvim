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
				parameters = {
					enabled = true,
					text = "",
				},
				returns = {
					enabled = true,
					text = "",
				},
			},
		},
		{
			name = "parameters",
			item_names = { "parameters" },
			gap_before = {
				returns = {
					enabled = false,
					text = "",
				},
			},
			items = {
				layout = {
					"%>:param %item_name: ${%snip_idx:description}",
					"%>:type %item_name: ${%snip_idx:%item_type}",
				},
			},
		},
		{
			name = "returns",
			item_names = { "returns" },
			gap_before = {
				footer = {
					enabled = false,
					text = "",
				},
			},
			items = {
				layout = {
					"%>:return: ${%snip_idx:description}",
					"%>:rtype: ${%snip_idx:%item_type}",
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
