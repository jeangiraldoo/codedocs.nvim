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
			layout = { "%>Args:" },
			gap_before = {
				returns = {
					enabled = true,
					text = "",
				},
			},
			items = {
				layout = {
					"%>%>%item_name (${%snip_idx:%item_type}): ${%snip_idx:description}",
				},
			},
		},
		{
			name = "returns",
			item_names = { "returns" },
			layout = { "%>Returns:" },
			gap_before = {
				footer = {
					enabled = false,
					text = "",
				},
			},
			items = {
				layout = {
					"%>%>${%snip_idx:%item_type}: ${%snip_idx:description}",
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
