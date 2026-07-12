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
				text = " *",
				enabled = false,
			},
		},
		items = {
			{
				name = "primary_section",
				layout = {
					" * @the_type [%item_type] @the_name {%item_name}",
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
