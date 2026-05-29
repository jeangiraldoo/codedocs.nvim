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
					name = "header",
					layout = {
						"/**",
						" * ${%snip_idx:title}",
					},
					gap_before = {
						parameters = {
							text = " *",
							enabled = true,
						},
						returns = {
							text = " *",
							enabled = true,
						},
					},
				},
				{
					name = "parameters",
					gap_before = {
						returns = {
							enabled = false,
							text = " *",
						},
					},
					items = {
						layout = {
							" * @param %item_name ${%snip_idx:description}",
						},
						insert_gap_between = { text = " *" },
					},
				},
				{
					name = "returns",
					gap_before = {
						footer = {
							enabled = false,
							text = " *",
						},
					},
					items = {
						layout = {
							" * @return ${%snip_idx:description}",
						},
						insert_gap_between = { text = " *" },
					},
				},
				{
					name = "footer",
					layout = {
						" */",
					},
				},
			},
		},
	},
}
