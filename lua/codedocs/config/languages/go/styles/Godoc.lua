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
	func = {
		placement = "above",
		blocks = {
			{
				name = "title",
				layout = {
					"// ${%snip_idx:title}",
				},
				insert_gap_between = {
					text = "//",
				},
			},
			{
				name = "parameters",
				insert_gap_between = { text = "//" },
				items = { insert_gap_between = { text = "//" } },
			},
			{
				name = "returns",
				insert_gap_between = { text = "//" },
				items = { insert_gap_between = { text = "//" } },
			},
		},
	},
}
