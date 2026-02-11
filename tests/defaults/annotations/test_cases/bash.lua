return {
	comment = {
		{
			structure = {
				"",
			},
			cursor_pos = 1,
			expected_annotation = {
				Google = {
					"# ${1:description}",
				},
			},
		},
	},
	func = {
		{
			structure = {
				"SOME_GLOBAL=2",
				"SESSION_ID=3",
				"dir=1",
				"local house=1",
				"local age=1",
				"local name=1",
				"",
				"foo() {",
				'	if [[ -d "${dir}/${SESSION_ID}" ]]; then',
				'		echo "$1"',
				'		echo "$2"',
				'		echo "$3"',
				'		echo "$4"',
				'		echo "${SESSION_ID}"',
				"	fi",
				"}",
			},
			cursor_pos = 8,
			expected_annotation = {
				Google = {
					"#######################################",
					"# ${1:title}",
					"# Globals:",
					"#   SESSION_ID",
					"#   dir",
					"# Arguments:",
					"#   ${2:description}",
					"#   ${3:description}",
					"#   ${4:description}",
					"#   ${5:description}",
					"#######################################",
				},
			},
		},
	},
}
