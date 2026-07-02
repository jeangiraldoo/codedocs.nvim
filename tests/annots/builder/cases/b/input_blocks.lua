return {
	{
		name = "header",
		layout = {
			"/**",
			" * ",
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
			secondary_section = {
				text = "--*",
				enabled = true,
			},
		},
		items = {
			{
				name = "primary_section",
				layout = {
					" * @item %item_name",
				},
				gap_before = {
					enabled = false,
					text = " *",
				},
			},
		},
	},
	{
		name = "secondary_section",
		layout = {},
		items = {
			{
				name = "secondary_section",
				layout = {
					" * @secondary_item %item_name",
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
