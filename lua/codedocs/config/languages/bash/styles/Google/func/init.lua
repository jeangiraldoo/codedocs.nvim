return {
	placement = "above",
	blocks = {
		{
			name = "header",
			layout = {
				"#######################################",
				"# ${%snip_idx:title}",
			},
		},
		{
			name = "globals",
			layout = { "# Globals:" },
			items = { layout = { "#   %item_name" } },
		},
		{
			name = "parameters",
			layout = { "# Arguments:" },
			items = { layout = { "#   ${%snip_idx:description}" } },
		},
		{
			name = "returns",
			layout = { "Returns:" },
			items = { layout = { "%item_type:" } },
		},
		{
			name = "footer",
			layout = {
				"#######################################",
			},
		},
	},
}
