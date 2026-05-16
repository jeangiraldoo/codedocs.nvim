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
						enabled = true,
					},
				},
			},
			{
				name = "attributes",
				gap_before = {
					footer = {
						enabled = false,
						text = " *",
					},
				},
				items = {
					layout = {
						" * @property {%item_type} %item_name ${%snip_idx:description}",
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
			},
		},
	},
	func = {
		placement = "above",
		blocks = {
			{
				name = "title",
				layout = {
					"/**",
					" * ${%snip_idx:description}",
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
						enabled = false,
						text = " *",
					},
				},
				items = {
					layout = {
						" * @param {${%snip_idx:type}} %item_name ${%snip_idx:description}",
					},
					insert_gap_between = {
						text = " *",
					},
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
						" * @returns {${%snip_idx:type}} ${%snip_idx:description}",
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
			},
		},
	},
}
