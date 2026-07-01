return {
	placement = "above",
	blocks = {
		{
			name = "header",
			item_names = {},
			layout = {
				"#######################################",
				"# ${%snip_idx:title}",
			},
		},
		{
			name = "globals",
			item_names = { "globals" },
			layout = { "# Globals:" },
			items = { layout = { "#   %item_name" } },
		},
		{
			name = "parameters",
			item_names = { "parameters" },
			layout = { "# Arguments:" },
			items = { layout = { "#   ${%snip_idx:description}" } },
		},
		{
			name = "returns",
			item_names = { "returns" },
			layout = { "Returns:" },
			items = { layout = { "%item_type:" } },
		},
		{
			name = "footer",
			item_names = {},
			layout = {
				"#######################################",
			},
		},
	},
}
