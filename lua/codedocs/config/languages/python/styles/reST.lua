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
				},
			},
			{
				name = "attributes",
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
				items = {
					layout = {
						"%>:param %item_name: ${%snip_idx:description}",
						"%>:type %item_name: ${%snip_idx:%item_type}",
					},
				},
			},
			{
				name = "returns",
				items = {
					layout = {
						"%>:return: ${%snip_idx:description}",
						"%>:rtype: ${%snip_idx:%item_type}",
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
