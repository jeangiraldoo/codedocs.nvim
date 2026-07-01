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
				" * @the_type [%item_type] @the_name {%item_name}",
			},
		},
	},
	{
		name = "secondary_section",
		item_names = { "secondary_section" },
		layout = {},
		gap_before = {
			footer = {
				enabled = false,
				text = " *",
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
		item_names = {},
		layout = {
			" */",
		},
	},
}
