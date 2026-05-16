return {
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
	class = {
		placement = "above",
		blocks = {
			{
				name = "header",
				layout = {
					"/**",
					" * ${%snip_idx:title}",
				},
				gap_before = {
					attributes = {
						text = " *",
						enabled = false,
					},
					footer = {
						text = " *",
						enabled = false,
					},
				},
			},
			{
				name = "attributes",
				layout = { " * Attributes:" },
				gap_before = {
					footer = {
						enabled = false,
						text = " *",
					},
				},
				items = { layout = { "// %item_name" }, insert_gap_between = { text = " *" } },
			},
			{
				name = "footer",
				layout = {
					" */",
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
						enabled = true,
						text = " *",
					},
					returns = {
						enabled = true,
						text = " *",
					},
				},
			},
			{
				name = "parameters",
				gap_before = {
					returns = {
						text = " *",
						enabled = false,
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
}
