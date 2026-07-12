return {
	{
		name = "header",
		layout = {
			"/**",
			" * ",
		},
		gap_before = {
			secondary_section = {
				enabled = true,
				text = " *",
			},
		},
	},
	{
		name = "secondary_section",
		layout = {},
		gap_before = {
			primary_section = {
				enabled = false,
				text = " *",
			},
		},
		items = {
			{
				name = "secondary_section",
				layout = {
					" * @secondary_item %item_name",
				},
			},
		},
	},
	{
		name = "primary_section",
		layout = {
			" * This is the primary section",
			" * ***************************",
			" * ",
		},
		gap_before = {
			footer = {
				enabled = false,
				text = " *",
			},
		},
		items = {
			{
				name = "primary_section",
				layout = {
					" * @item %item_name",
				},
				gap_before = {
					text = " *",
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
