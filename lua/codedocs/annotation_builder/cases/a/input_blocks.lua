return {
	{
		name = "header",
		layout = {
			"---",
			"--* ",
		},
		gap_before = {
			primary_section = {
				enabled = true,
				text = " *",
			},
		},
	},
	{
		name = "primary_section",
		layout = {},
		gap_before = {
			text = " *",
		},
		items = {
			{
				name = "primary_section",
				layout = {
					"--* @item %item_name",
				},
				gap_before = {
					text = " *",
				},
			},
		},
	},
	{
		name = "secondary_section",
		layout = {},
		insert_gap_between = {
			text = " * ",
		},
		items = {
			{
				name = "secondary_section",
				layout = {
					"--* @secondary_item %item_name",
				},
				gap_before = {
					enabled = false,
					text = " * ",
				},
			},
		},
	},
	{
		name = "footer",
		layout = {
			" ]-",
		},
		gap_before = {
			text = " *",
		},
	},
}
