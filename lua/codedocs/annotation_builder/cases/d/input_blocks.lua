return {
	{
		name = "header",
		layout = {
			"/**",
			" * ",
		},
		gap_before = {
			primary_section = {
				text = " *",
				enabled = true,
			},
		},
	},
	{
		name = "primary_section",
		layout = {},
		gap_before = {
			secondary_section = {
				text = " *",
				enabled = false,
			},
		},
		items = {
			{
				name = "primary_section",
				layout = {
					" * @item %item_name",
				},
				insert_gap_between = {
					enabled = true,
					text = " * ",
				},
				gap_before = {
					enabled = false,
					text = " * ",
				},
			},
		},
	},
	{
		name = "secondary_section",
		layout = {},
		gap_before = {
			footer = {
				text = " * ",
				enabled = false,
			},
		},
		items = {
			{
				name = "secondary_section",
				layout = {
					" * @secondary_item %item_name",
				},
				insert_gap_between = {
					enabled = true,
					text = " * ",
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
			" */",
		},
	},
}
