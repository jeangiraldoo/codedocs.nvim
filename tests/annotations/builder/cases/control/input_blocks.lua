return {
	{
		name = "title",
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
				text = " *",
				enabled = false,
			},
		},
		items = {
			insert_gap_between = {
				enabled = false,
				text = " * ",
			},
			layout = {
				" * @item %item_name",
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
				enabled = false,
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
