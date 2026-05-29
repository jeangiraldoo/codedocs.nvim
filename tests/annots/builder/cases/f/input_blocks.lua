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
			text = " *",
			enabled = false,
		},
		items = {
			insert_gap_between = {
				enabled = false,
				text = " * ",
			},
			layout = {
				" * @the_type [%item_type] @the_name {%item_name} ${%snip_idx:description}",
			},
		},
	},
	{
		name = "secondary_section",
		layout = {},
		gap_before = {
			text = " * ",
			enabled = false,
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
