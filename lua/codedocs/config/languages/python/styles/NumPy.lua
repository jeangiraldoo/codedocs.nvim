return {
	default_annot = "comment",
	annots = {
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
					layout = { "%>Parameters", "%>----------" },
					gap_before = {
						returns = {
							enabled = true,
							text = "",
						},
					},
					items = {
						layout = {
							"%>%item_name: ${%snip_idx:%item_type}",
							"%>	${%snip_idx:description}",
						},
					},
				},
				{
					name = "returns",
					layout = { "%>Returns", "%>-------" },
					gap_before = {
						footer = {
							enabled = false,
							text = "",
						},
					},
					items = {
						layout = {
							"%>${%snip_idx:%item_type}",
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
		},
	},
}
