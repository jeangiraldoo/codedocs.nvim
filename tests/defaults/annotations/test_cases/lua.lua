return {
	comment = {
		{
			structure = {
				"",
			},
			cursor_pos = 1,
			expected_annotation = {
				EmmyLua = {
					"---${1:description}",
				},
				LDoc = {
					"-- ${1:description}",
				},
			},
		},
	},
	func = {
		{
			structure = {
				"local function foo(a, b)",
				"	return a + b",
				"end",
			},
			cursor_pos = 1,
			expected_annotation = {
				EmmyLua = {
					"---${1:title}",
					"---@param a ${2:type} ${3:description}",
					"---@param b ${4:type} ${5:description}",
					"---@return ${6:type} ${7:description}",
				},
				LDoc = {
					"--- ${1:title}",
					"-- @param a ${2:type} ${3:description}",
					"-- @param b ${4:type} ${5:description}",
					"-- @return ${6:type} ${7:description}",
				},
			},
		},
	},
}
