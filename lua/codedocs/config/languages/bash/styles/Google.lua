return {
	comment = {
		placement = "current",
		blocks = {
			{
				name = "title",
				layout = {
					"# ${%snip_idx:description}",
				},
			},
		},
	},
	shebang = {
		placement = "current",
		blocks = {
			{
				name = "title",
				layout = {
					"#${%snip_idx:!/usr/bin/env bash}",
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
				ignore_prev_gap = true,
			},
		},
	},
}
