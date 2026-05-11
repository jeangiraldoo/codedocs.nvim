return {
	comment = {
		relative_position = "empty_target_or_above",
		indented = false,
		blocks = {
			{
				name = "title",
				layout = {
					"# ${%snippet_tabstop_idx:description}",
				},
			},
		},
	},
	export = {
		relative_position = "empty_target_or_above",
		indented = false,
		blocks = {
			{
				name = "title",
				layout = {
					"@export ${%snippet_tabstop_idx:property}",
				},
			},
		},
	},
	onready = {
		relative_position = "empty_target_or_above",
		indented = false,
		blocks = {
			{
				name = "title",
				layout = {
					"@onready ${%snippet_tabstop_idx:property}",
				},
			},
		},
	},
	warning_ignore = {
		relative_position = "empty_target_or_above",
		indented = false,
		blocks = {
			{
				name = "title",
				layout = {
					'@warning_ignore("${%snippet_tabstop_idx:warning}")',
				},
			},
		},
	},
}
