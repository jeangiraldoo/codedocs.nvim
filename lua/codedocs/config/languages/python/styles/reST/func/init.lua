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
			gap_before = {
				returns = {
					enabled = false,
					text = "",
				},
			},
			items = {
				{
					name = "parameters",
					layout = {
						"%>:param %item_name: ${%snip_idx:description}",
						"%>:type %item_name: ${%snip_idx:%item_type}",
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
						"%>:return: ${%snip_idx:description}",
						"%>:rtype: ${%snip_idx:%item_type}",
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
