package.path = package.path .. ";" .. vim.fn.expand "<sfile>:p:h" .. "/tests"

local test_utils = require "tests.utils"
local LangSpecs = require "codedocs.lang_specs.init"

local LANGS_TO_TEST = LangSpecs.get_supported_langs()

describe("Basic item extraction", function()
	for _, lang in ipairs(LANGS_TO_TEST) do
		for _, cases in pairs(require("tests.specs.item_extraction.test_cases." .. lang)) do
			for idx, case in ipairs(cases) do
				it(lang .. " - Case #" .. idx, function()
					test_utils.mock_buffer(lang, case.structure, { row = case.cursor_pos, col = 0 })

					assert.are.same(case.expected_items, require("codedocs").extract_item_data(lang))
				end)
			end
		end
	end
end)
