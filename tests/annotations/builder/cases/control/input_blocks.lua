return {
	{
		name = "title",
		layout = {
			"/**",
			" * ",
		},
		insert_gap_between = {
			enabled = true,
			text = " *",
		},
	},
	{
		name = "primary_section",
		layout = {},
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
	{
		name = "secondary_section",
		layout = {},
		insert_gap_between = {
			enabled = false,
			text = " * ",
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
		name = "footer",
		layout = {
			" */",
		},
		ignore_prev_gap = true,
		insert_gap_between = {
			enabled = true,
			text = " *",
		},
	},
}
