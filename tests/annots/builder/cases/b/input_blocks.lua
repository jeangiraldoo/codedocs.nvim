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
				enabled = true,
				text = " *",
			},
		},
	},
	{
		name = "primary_section",
		item_names = { "primary_section" },
		layout = {},
		gap_before = {
			secondary_section = {
				text = "--*",
				enabled = true,
			},
		},
		items = {
			layout = {
				" * @item %item_name",
			},
			insert_gap_between = {
				enabled = false,
				text = " *",
			},
			items = {
				insert_gap_between = {
					enabled = false,
					text = " * ",
				},
				indent = false,
				layout = {
					" * @item %item_name",
				},
			},
		},
	},
	{
		name = "secondary_section",
		item_names = { "secondary_section" },
		layout = {},
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
		name = "footer",
		item_names = {},
		layout = {
			" */",
		},
	},
}
