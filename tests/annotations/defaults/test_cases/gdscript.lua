return {
	comment = {
		{
			structure = { "" },
			cursor_pos = 1,
			expected_annotation = {
				Codedocs = {
					"# ${1:description}",
				},
			},
		},
	},
	export = {
		{
			structure = { "" },
			cursor_pos = 1,
			expected_annotation = {
				Codedocs = {
					"@export ${1:property}",
				},
			},
		},
	},
	onready = {
		{
			structure = { "" },
			cursor_pos = 1,
			expected_annotation = {
				Codedocs = {
					"@onready ${1:property}",
				},
			},
		},
	},
	warning_ignore = {
		{
			structure = { "" },
			cursor_pos = 1,
			expected_annotation = {
				Codedocs = {
					'@warning_ignore("${1:warning}")',
				},
			},
		},
	},
}
