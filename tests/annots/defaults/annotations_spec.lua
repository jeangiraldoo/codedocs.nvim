local test_utils = require "tests.utils"
local Codedocs = require "codedocs"

local IGNORE = {}

local DIR = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")

local LANGS_TO_TEST = vim.iter(require("codedocs").get_supported_langs())
	:filter(function(v) return not vim.list_contains(IGNORE, v) end)
	:totable()

local function test_case(lang, style_name, annot_name, case_name)
	it(("%s - %s/%s (%s) "):format(lang, style_name, annot_name, case_name), function()
		local rel_path = ("cases/%s/%s/%s/"):format(lang, annot_name, case_name)
		local base_path = vim.fs.joinpath(DIR, rel_path)

		local lua_rel_path = rel_path:gsub("/", ".")

		local input = vim.fn.readfile(vim.fs.joinpath(base_path, "input"))

		local expected_output = vim.fn.readfile(vim.fs.joinpath(base_path, "output/" .. style_name))

		local metadata = require("tests.annotations.defaults." .. lua_rel_path .. ".metadata")

		test_utils.mock_buffer(lang, input, { row = metadata.cursor.row, col = metadata.cursor.col or 1 })

		local annot_data = Codedocs.get_annot_data(lang, {
			style_name = style_name,
			annot_name = annot_name,
		})
		local annot_result = Codedocs.build_annot(lang, annot_data)

		assert.are.same(expected_output, annot_result.lines)
	end)
end

describe("Default style annotations", function()
	local langs_config = require("codedocs.config").opts.languages

	for _, lang in ipairs(LANGS_TO_TEST) do
		for style_name, annots in pairs(langs_config[lang].styles) do
			for annot_name, _ in pairs(annots) do
				local annot_case_names = test_utils.read_dir_names(DIR .. ("/cases/%s/%s/"):format(lang, annot_name))

				for _, case_name in ipairs(annot_case_names) do
					test_case(lang, style_name, annot_name, case_name)
				end
			end
		end
	end
end)
