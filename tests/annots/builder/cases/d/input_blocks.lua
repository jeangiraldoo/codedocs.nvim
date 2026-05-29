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
			layout = {
				" * @item %item_name",
			},
			insert_gap_between = {
				enabled = true,
				text = " * ",
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
			insert_gap_between = {
				enabled = true,
				text = " * ",
			},
			layout = {
				" * @secondary_item %item_name",
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
