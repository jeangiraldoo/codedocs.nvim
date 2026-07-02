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
			layout = { "%>Args:" },
			gap_before = {
				returns = {
					enabled = true,
					text = "",
				},
			},
			items = {
				{
					name = "parameters",
					layout = {
						"%>%>%item_name (${%snip_idx:%item_type}): ${%snip_idx:description}",
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
			name = "returns",
			layout = { "%>Returns:" },
			gap_before = {
				footer = {
					enabled = false,
					text = "",
				},
			},
			items = {
				{
					name = "returns",
					layout = {
						"%>%>${%snip_idx:%item_type}: ${%snip_idx:description}",
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
