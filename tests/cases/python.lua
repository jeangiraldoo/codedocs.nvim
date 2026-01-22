---BUG: most stuff needs help
return {
	func = {
		---No parametres, no return
		{
			structure = {
				"def foo():",
				"	pass",
			},
			cursor_pos = 1,
			expected_annotation = {
				Google = {
					'"""',
					"",
					"",
					'"""',
				},
				reST = {
					'"""',
					"",
					"",
					'"""',
				},
				Numpy = {
					'"""',
					"",
					"",
					'"""',
				},
			},
		},
		--Only return type annotation
		{
			structure = {
				"def foo() -> bool:",
				"	pass",
			},
			cursor_pos = 1,
			expected_annotation = {
				Google = {
					'"""',
					"",
					"",
					"Returns:",
					"	bool:",
					'"""',
				},
				reST = {
					'"""',
					"",
					"",
					":return:",
					":rtype: bool",
					'"""',
				},
				Numpy = {
					'"""',
					"",
					"",
					"Returns",
					"-------",
					"bool",
					'"""',
				},
			},
		},
		---Parametres (no annotation) and return statement
		{
			structure = {
				"def foo(a, b, c):",
				"	return a",
			},
			cursor_pos = 1,
			expected_annotation = {
				Google = {
					'"""',
					"",
					"",
					"Args:",
					"	a ():",
					"	b ():",
					"	c ():",
					"Returns:",
					"	:",
					'"""',
				},
				reST = {
					'"""',
					"",
					"",
					":param a:",
					":type a:",
					":param b:",
					":type b:",
					":param c:",
					":type c:",
					":return:",
					":rtype:",
					'"""',
				},
				Numpy = {
					'"""',
					"",
					"",
					"Parameters",
					"----------",
					"a : ",
					"b : ",
					"c : ",
					"",
					"Returns",
					"-------",
					"",
					'"""',
				},
			},
		},
	},
	class = {
		{
			structure = {
				"class Foo:",
				'	a = ""',
			},
			cursor_pos = 1,
			expected_annotation = {
				Google = {
					'"""',
					"",
					"",
					"Attributes:",
					"	a ():",
					'"""',
				},
				reST = {
					'"""',
					"",
					"",
					":var a:",
					":vartype a:",
					'"""',
				},
				Numpy = {
					'"""',
					"",
					"",
					"Attributes:",
					"___________",
					"a :",
					'"""',
				},
			},
		},
	},
}
