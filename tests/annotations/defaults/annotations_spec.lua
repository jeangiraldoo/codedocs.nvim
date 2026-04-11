package.path = package.path .. ";" .. debug.getinfo(1, "S").source:sub(2):match "(.*/)" .. "/tests"

local test_utils = require "tests.utils"
local Codedocs = require "codedocs"
local IGNORE = {}

local LANGS_TO_TEST = vim.iter(require("codedocs").get_supported_langs())
	:filter(function(v) return not vim.list_contains(IGNORE, v) end)
	:totable()

describe("Default style annotations", function()
	for _, lang in ipairs(LANGS_TO_TEST) do
		for target_name, target_cases in pairs(require("tests.annotations.defaults.test_cases." .. lang)) do
			describe(lang .. " - " .. target_name, function()
				for idx, target_case in ipairs(target_cases) do
					for _, style_name in ipairs(Codedocs.get_supported_styles(lang)) do
						it("(" .. style_name .. ") - Case #" .. idx, function()
							test_utils.mock_buffer(
								lang,
								target_case.structure,
								{ row = target_case.cursor_pos, col = target_case.cursor_col or 1 }
							)

							assert.are.same(
								target_case.expected_annotation[style_name],
								require("codedocs").orchestrate_annotation_build {
									name = lang,
									style_name = style_name,
								}
							)
						end)
					end
				end
			end)
		end
	end
end)
