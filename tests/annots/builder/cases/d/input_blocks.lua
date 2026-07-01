return {
	{
		name = "header",
		item_names = {},
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
		item_names = { "primary_section" },
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
		item_names = { "secondary_section" },
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
		item_names = {},
		layout = {
			" */",
		},
	},
}
