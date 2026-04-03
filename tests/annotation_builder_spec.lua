---This test specification is focused on ensuring that the `annotation builder` component works properly.
---The checks consist of:
---		- Mocking language-agnostic items
---		- Defining base options, and the way the annotation looks like when using said options
---		- Override the base options and check that the new annotation has the expected differences from the base one
---
---Regarding the `items` option, since all item-based sections use the same `items` suboptions,
---and those options only affect their own section, it’s enough to test them in one section

local annotation_builder = require "codedocs.annotation_builder"

local MOCKED_ITEMS = {
	primary_section = {
		{
			name = "a",
			type = "int",
		},
		{
			name = "b",
			type = "",
		},
		{
			name = "c",
			type = "int",
		},
		{
			name = "",
			type = "string",
		},
	},
	secondary_section = {
		{
			name = "d",
			type = "int",
		},
		{
			name = "e",
			type = "int",
		},
		{
			name = "f",
			type = "int",
		},
		{
			name = "",
			type = "string",
		},
	},
}

local BASE_ANNOTATION = {
	expected_lines = {
		"/**",
		" * ",
		" *",
		" * @item a",
		" * @item b",
		" * @item c",
		" * @item",
		" * @secondary_item d",
		" * @secondary_item e",
		" * @secondary_item f",
		" * @secondary_item",
		" */",
	},
	opts = {
		settings = {
			layout = {
				"/**",
				" */",
			},
			insert_at = 2,
			section_order = {
				"primary_section",
				"secondary_section",
			},
		},
		sections = {
			{
				name = "title",
				layout = {
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
		},
	},
}

local CASES = {
	{
		expected_lines = {
			"---",
			"--* ",
			" *",
			"--* @item a",
			"--* @item b",
			"--* @item c",
			"--* @item ",
			"--* @secondary_item d",
			"--* @secondary_item e",
			"--* @secondary_item f",
			"--* @secondary_item ",
			" ]-",
		},
		opts_to_change = {
			settings = {
				layout = {
					"---",
					" ]-",
				},
			},
			sections = {
				{
					name = "title",
					layout = {
						"--* ",
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
						layout = {
							"--* @item %item_name",
						},
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
				},
				{
					name = "secondary_section",
					layout = {},
					insert_gap_between = {
						enabled = false,
						text = " * ",
					},
					items = {
						layout = {
							"--* @secondary_item %item_name",
						},
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
				},
			},
		},
	},
	{
		expected_lines = {
			"/**",
			" * ",
			" *",
			" * @item a",
			" * @item b",
			" * @item c",
			" * @item ",
			"--*",
			" * @secondary_item d",
			" * @secondary_item e",
			" * @secondary_item f",
			" * @secondary_item ",
			" */",
		},
		opts_to_change = {
			sections = {
				{
					name = "title",
					layout = {
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
						enabled = true,
						text = "--*",
					},
					items = {
						layout = {
							" * @item %item_name",
						},
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
				},
				{
					name = "secondary_section",
					layout = {},
					insert_gap_between = {
						enabled = true,
						text = "--* ",
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
			},
		},
	},
	{
		expected_lines = {
			"/**",
			" * ",
			" *",
			" * @secondary_item d",
			" * @secondary_item e",
			" * @secondary_item f",
			" * @secondary_item ",
			" * This is the primary section",
			" * ***************************",
			" * ",
			" * @item a",
			" * @item b",
			" * @item c",
			" * @item ",
			" */",
		},
		opts_to_change = {
			settings = {
				section_order = {
					"secondary_section",
					"primary_section",
				},
			},
			sections = {
				{
					name = "title",
					layout = {
						" * ",
					},
					insert_gap_between = {
						enabled = true,
						text = " *",
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
					name = "primary_section",
					insert_gap_between = {
						enabled = false,
						text = " *",
					},
					layout = {
						" * This is the primary section",
						" * ***************************",
						" * ",
					},
					items = {
						layout = {
							" * @item %item_name",
						},
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
				},
			},
		},
	},
	{
		expected_lines = {
			"/**",
			" * ",
			" *",
			" * @item a",
			" * ",
			" * @item b",
			" * ",
			" * @item c",
			" * ",
			" * @item ",
			" * @secondary_item d",
			" * ",
			" * @secondary_item e",
			" * ",
			" * @secondary_item f",
			" * ",
			" * @secondary_item ",
			" */",
		},
		opts_to_change = {
			sections = {
				{
					name = "title",
					layout = {
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
						layout = {
							" * @item %item_name",
						},
						insert_gap_between = {
							enabled = true,
							text = " * ",
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
							enabled = true,
							text = " * ",
						},
						indent = false,
						layout = {
							" * @secondary_item %item_name",
						},
					},
				},
			},
		},
	},
	{
		expected_lines = {
			"/**",
			" * ",
			" *",
			" * @the_type [int] @the_name {a}",
			" * @the_type [] @the_name {b}",
			" * @the_type [int] @the_name {c}",
			" * @the_type [string] @the_name {}",
			" * @secondary_item d",
			" * @secondary_item e",
			" * @secondary_item f",
			" * @secondary_item ",
			" */",
		},
		opts_to_change = {
			sections = {
				{
					name = "title",
					layout = {
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
							" * @the_type [%item_type] @the_name {%item_name}",
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
			},
		},
	},
	{
		expected_lines = {
			"/**",
			" * ",
			" *",
			" * @the_type [int] @the_name {a} ${1:description}",
			" * @the_type [] @the_name {b} ${2:description}",
			" * @the_type [int] @the_name {c} ${3:description}",
			" * @the_type [string] @the_name {} ${4:description}",
			" * @secondary_item d",
			" * @secondary_item e",
			" * @secondary_item f",
			" * @secondary_item ",
			" */",
		},
		opts_to_change = {
			sections = {
				{
					name = "title",
					layout = {
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
							" * @the_type [%item_type] @the_name {%item_name} ${%snippet_tabstop_idx:description}",
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
			},
		},
	},
}

describe("Annotation builder - ", function()
	for i, case in ipairs(CASES) do
		it("Case #" .. i, function()
			local base_opts_copy = vim.deepcopy(BASE_ANNOTATION.opts)
			local new_style = vim.tbl_deep_extend("force", base_opts_copy, case.opts_to_change)
			local annotation = annotation_builder(new_style, MOCKED_ITEMS, new_style.settings.layout)

			assert.are.same(case.expected_lines, annotation)
		end)
	end
end)
