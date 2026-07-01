return {
	{
		name = "header",
		item_names = {},
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
		item_names = { "secondary_section" },
		layout = {},
		gap_before = {
			primary_section = {
				enabled = false,
				text = " *",
			},
		},
		items = {
			insert_gap_between = {
				enabled = false,
				text = " * ",
			},
			indent = false,
			layout = {
				" * @secondary_item %item_name",
			},
		},
	},
	{
		name = "primary_section",
		item_names = { "primary_section" },
		gap_before = {
			footer = {
				enabled = false,
				text = " *",
			},
		},
		layout = {
			" * This is the primary section",
			" * ***************************",
			" * ",
		},
		items = {
			layout = {
				" * @item %item_name",
			},
			insert_gap_between = {
				text = " *",
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
