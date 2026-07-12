---This test specification is focused on ensuring that the `annotation builder` component works properly.
---The checks consist of:
---		- Mocking language-agnostic items
---		- Defining base options, and the way the annotation looks like when using said options
---		- Override the base options and check that the new annotation has the expected differences from the base one
---
---Regarding the `items` option, since all item-based sections use the same `items` suboptions,
---and those options only affect their own section, it’s enough to test them in one section

local Utils = require "codedocs.utils.tests"
local Codedocs = require "codedocs"

local DIR = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")

local MOCKED_ITEMS = {
	primary_section = {
		{ name = "a", type = "int" },
		{ name = "b", type = "" },
		{ name = "c", type = "int" },
		{ name = "", type = "string" },
	},
	secondary_section = {
		{ name = "d", type = "int" },
		{ name = "e", type = "int" },
		{ name = "f", type = "int" },
		{ name = "", type = "string" },
	},
}

describe("Annotation builder - ", function()
	local cases = Utils.read_dir_names(DIR .. "/cases")

	for _, case_name in ipairs(cases) do
		it("Case #" .. case_name, function()
			local blocks = require("codedocs.annotation_builder.cases." .. case_name .. ".input_blocks")
			local expected_output = vim.fn.readfile(DIR .. "/cases/" .. case_name .. "/output")

			local opts = require("codedocs.config").opts.annot_builder
			local lines = require("codedocs.annotation_builder").build_annot_lines(blocks, opts, 1, MOCKED_ITEMS)

			assert.are.same(expected_output, lines)
		end)
	end
end)
