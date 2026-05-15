return {
	comment = {
		placement = "current",
		blocks = {
			{
				name = "title",
				layout = {
					"-- ${%snip_idx:description}",
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
					"--- ${%snip_idx:title}",
				},
				insert_gap_between = {
					enabled = false,
					text = "--",
				},
			},
			{
				name = "parameters",
				insert_gap_between = { text = "--" },
				items = {
					layout = {
						"-- @param %item_name ${%snip_idx:type} ${%snip_idx:description}",
					},
					insert_gap_between = {
						text = "--",
					},
				},
			},
			{
				name = "returns",
				insert_gap_between = { text = "--" },
				items = {
					layout = {
						"-- @return ${%snip_idx:type} ${%snip_idx:description}",
					},
					insert_gap_between = {
						text = "--",
					},
				},
			},
		},
	},
}
