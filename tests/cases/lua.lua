return {
	func = {
		---No parametres, no return
		{
			structure = {
				"local function foo()",
				"end",
			},
			cursor_pos = 1,
			expected_annotation = {
				LDoc = {
					"--- ",
				},
				EmmyLua = {
					"---",
				},
			},
		},
		---No parametres, return statement present
		{
			structure = {
				"local function foo()",
				"	return a",
				"end",
			},
			cursor_pos = 1,
			expected_annotation = {
				LDoc = {
					"--- ",
					"-- @return",
				},
				EmmyLua = {
					"---",
					"---@return",
				},
			},
		},
		---Parametres and return statement present
		{
			structure = {
				"local function foo(a, b, c)",
				"	return a",
				"end",
			},
			cursor_pos = 1,
			expected_annotation = {
				LDoc = {
					"--- ",
					"-- @param a",
					"-- @param b",
					"-- @param c",
					"-- @return",
				},
				EmmyLua = {
					"---",
					"---@param a",
					"---@param b",
					"---@param c",
					"---@return",
				},
			},
		},
	},
}
