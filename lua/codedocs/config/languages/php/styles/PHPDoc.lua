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
	phptag = {
		placement = "current",
		blocks = {
			{
				name = "title",
				layout = {
					"<?php",
					"${%snip_idx:code}",
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
						" * @param ${%snip_idx:%item_type} \\$%item_name ${%snip_idx:description}",
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
						" * @return ${%snip_idx:%item_type} ${%snip_idx:description}",
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
