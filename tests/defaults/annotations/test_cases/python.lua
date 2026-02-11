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
				Numpy = {
					"# ${1:description}",
				},
				reST = {
					"# ${1:description}",
				},
			},
		},
	},
	func = {
		{
			structure = {
				"def foo(a: int, b: int) -> int:",
				"	a + b",
			},
			cursor_pos = 1,
			expected_annotation = {
				Google = {
					'"""',
					"${1:title}",
					"",
					"Args:",
					"	a (${2:int}): ${3:description}",
					"	b (${4:int}): ${5:description}",
					"",
					"Returns:",
					"	${6:int}: ${7:description}",
					'"""',
				},
				Numpy = {
					'"""',
					"${1:title}",
					"",
					"Parameters",
					"----------",
					"a: ${2:int}",
					"	${3:description}",
					"b: ${4:int}",
					"	${5:description}",
					"",
					"Returns",
					"-------",
					"${6:int}",
					"	${7:description}",
					'"""',
				},
				reST = {
					'"""',
					"${1:title}",
					"",
					":param a: ${2:description}",
					":type a: ${3:int}",
					":param b: ${4:description}",
					":type b: ${5:int}",
					":return: ${6:description}",
					":rtype: ${7:int}",
					'"""',
				},
			},
		},
	},
}
