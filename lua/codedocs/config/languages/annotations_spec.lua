-- local test_utils = require "tests.utils"
local Codedocs = require "codedocs"
local Test_utils = require "codedocs.utils.tests"

local IGNORE = {}

local source = debug.getinfo(1, "S").source:sub(2)
local DIR = vim.fn.resolve(vim.fn.fnamemodify(source, ":p:h"))

local LANGS_TO_TEST = vim.iter(require("codedocs").get_supported_langs())
	:filter(function(v) return not vim.list_contains(IGNORE, v) end)
	:totable()

local function test_case(lang, style_name, annot_name, case_name)
	it(("%s - %s/%s (%s) "):format(lang, style_name, annot_name, case_name), function()
		local rel_path = ("%s/styles/%s/%s/output_cases/%s"):format(lang, style_name, annot_name, case_name)
		local base_path = vim.fs.joinpath(DIR, rel_path)

		local input = vim.fn.readfile(vim.fs.joinpath(base_path, "input"))
		local expected_output = vim.fn.readfile(vim.fs.joinpath(base_path, "output"))

		local cursor, actual_input = Test_utils.parse_golden_file(input)

		Test_utils.mock_buffer(lang, actual_input, { row = cursor.row, col = cursor.col or 1 })

		local annot = Codedocs.prepare_annotation(lang, { style_name = style_name, annot_name = annot_name })

		assert.are.same(expected_output, annot.lines)
	end)
end

describe("Default style annotations", function()
	local langs_config = require("codedocs.config").opts.languages

	for _, lang in ipairs(LANGS_TO_TEST) do
		for style_name, style_opts in pairs(langs_config[lang].styles) do
			for annot_name, _ in pairs(style_opts.annots) do
				local annot_case_names = Test_utils.read_dir_names(
					DIR .. ("/%s/styles/%s/%s/output_cases"):format(lang, style_name, annot_name)
				)

				for _, case_name in ipairs(annot_case_names) do
					test_case(lang, style_name, annot_name, case_name)
				end
			end
		end
	end
end)
