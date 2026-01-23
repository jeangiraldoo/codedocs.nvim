local annotation_builder = require("codedocs.annotation_builder")

local COMMON_DATA = {
	ITEMS = {
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
	},
	BASE_STYLE = {
		expected_annotation = {
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
			general = {
				structure = {
					"/**",
					" * ",
					" */",
				},
				title_pos = 2,
				title_gap = true,
				title_gap_text = " *",
				section_gap = false,
				section_gap_text = " *",
				section_underline = "",
				section_title_gap = false,
				item_gap = false,
				section_order = { "primary_section", "secondary_section" },
			},
			primary_section = {
				title = "",
				inline = true,
				indent = false,
				include_type = false,
				type_first = false,
				name_kw = "@item",
				type_kw = "",
				name_wrapper = { "", "" },
				type_wrapper = { "", "" },
				is_type_below_name_first = false,
			},
			secondary_section = {
				title = "",
				inline = true,
				indent = false,
				include_type = false,
				type_first = false,
				name_kw = "@secondary_item",
				type_kw = "",
				name_wrapper = { "", "" },
				type_wrapper = { "", "" },
				is_type_below_name_first = false,
			},
		},
	},
}

local GENERAL_SECTION_CASES = {
	{
		expected_annotation = {
			"---",
			"--* ",
			"--* @item a",
			"--* @item b",
			"--* @item c",
			"--* @item",
			"--* @secondary_item d",
			"--* @secondary_item e",
			"--* @secondary_item f",
			"--* @secondary_item",
			" ]-",
		},
		opts_to_change = {
			general = {
				structure = {
					"---",
					"--* ",
					" ]-",
				},
				title_gap = false,
			},
		},
	},
	{
		expected_annotation = {
			"/**",
			" * ",
			" *",
			" * @item a",
			" * @item b",
			" * @item c",
			" * @item",
			"--*",
			" * @secondary_item d",
			" * @secondary_item e",
			" * @secondary_item f",
			" * @secondary_item",
			" */",
		},
		opts_to_change = {
			general = {
				section_gap = true,
				section_gap_text = "--*",
			},
		},
	},
	{
		expected_annotation = {
			"/**",
			" * ",
			" *",
			" * ", ---BUG: This shouldnt be here
			" * @secondary_item d",
			" * @secondary_item e",
			" * @secondary_item f",
			" * @secondary_item",
			" * This is the primary section",
			" * ***************************",
			" * ", ---BUG: section_gap_text option needed
			" * @item a",
			" * @item b",
			" * @item c",
			" * @item",
			" */",
		},
		opts_to_change = {
			general = {
				section_underline = "*",
				section_title_gap = true,
				section_order = {
					"secondary_section",
					"primary_section",
				},
			},
			primary_section = {
				title = "This is the primary section",
			},
		},
	},
	{
		expected_annotation = {
			"/**",
			" * ",
			" *",
			" * @item a",
			" * ",
			" * @item b",
			" * ",
			" * @item c",
			" * ",
			" * @item",
			" * @secondary_item d",
			" * ",
			" * @secondary_item e",
			" * ",
			" * @secondary_item f",
			" * ",
			" * @secondary_item",
			" */",
		},
		opts_to_change = {
			general = {
				item_gap = true,
			},
		},
	},
}

---Since all sections use the same item options,
---and those options only affect their own section,
---it’s enough to test them in one section
local ITEM_CASES = {
	{
		expected_annotation = {
			"/**",
			" * ",
			" *",
			" * 	@item a int",
			" * 	@item b",
			" * 	@item c int",
			" * 	@item string",
			" * @secondary_item d",
			" * @secondary_item e",
			" * @secondary_item f",
			" * @secondary_item",
			" */",
		},
		opts_to_change = {
			primary_section = {
				indent = true,
				include_type = true,
			},
		},
	},
	{
		expected_annotation = {
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
			" * @secondary_item",
			" */",
		},
		opts_to_change = {
			primary_section = {
				include_type = true,
				type_first = true,
				name_kw = "@the_name",
				type_kw = "@the_type",
				name_wrapper = {
					"{",
					"}",
				},
				type_wrapper = {
					"[",
					"]",
				},
			},
		},
	},
	---BUG: is_type_below_name_first doesnt have a properly defined behaviour
}

local CASES = {
	general = GENERAL_SECTION_CASES,
	item = ITEM_CASES,
}

local function test_case(name, case)
	it(name, function()
		local copy = vim.deepcopy(COMMON_DATA.BASE_STYLE.opts)
		local new_style = vim.tbl_deep_extend("force", copy, case.opts_to_change)
		local annotation = annotation_builder(new_style, COMMON_DATA.ITEMS, new_style.general.structure)

		assert.are.same(case.expected_annotation, annotation)
	end)
end

describe("Test annotation builder - ", function()
	for section_name, section_cases in pairs(CASES) do
		describe(section_name .. " options - ", function()
			for i, case in ipairs(section_cases) do
				test_case("Case #" .. i, case)
			end
		end)
	end
end)
