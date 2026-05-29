return {
	annots = {
		comment = {
			placement = "current",
			blocks = {
				{
					name = "title",
					layout = {
						"// ${%snip_idx:description}",
					},
				},
			},
		},
		func = {
			placement = "above",
			blocks = {
				{
					name = "title",
					layout = {
						"// ${%snip_idx:title}",
					},
					gap_before = {
						parameters = {
							text = "//",
							enabled = true,
						},
					},
				},
				{
					name = "parameters",
					gap_before = {
						returns = {
							enabled = false,
							text = "//",
						},
					},
					items = { insert_gap_between = { text = "//" } },
				},
				{
					name = "returns",
					items = { insert_gap_between = { text = "//" } },
				},
			},
		},
	},
}
