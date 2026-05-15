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
				insert_gap_between = {
					enabled = true,
					text = " *",
				},
			},
			{
				name = "attributes",
				insert_gap_between = { text = " *" },
				items = {
					insert_gap_between = {
						text = " *",
					},
				},
			},
			{
				name = "footer",
				layout = {
					" */",
				},
				ignore_prev_gap = true,
				insert_gap_between = {
					text = " *",
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
				insert_gap_between = {
					enabled = true,
					text = " *",
				},
			},
			{
				name = "parameters",
				insert_gap_between = { text = " *" },
				items = {
					layout = {
						" * @param %item_name - ${%snip_idx:description}",
					},
					insert_gap_between = {
						text = " *",
					},
				},
			},
			{
				name = "returns",
				insert_gap_between = { text = " *" },
				items = {
					layout = {
						" * @returns ${%snip_idx:description}",
					},
					insert_gap_between = {
						text = " *",
					},
				},
			},
			{
				name = "footer",
				layout = {
					" */",
				},
				ignore_prev_gap = true,
				insert_gap_between = {
					text = " *",
				},
			},
		},
	},
}
