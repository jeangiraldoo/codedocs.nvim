package.path = package.path .. ";" .. vim.fn.expand "<sfile>:p:h" .. "/tests"

local test_utils = require "tests.utils"
local LangSpecs = require "codedocs.lang_specs.init"

describe("Default style annotations", function()
	for _, lang in ipairs(LangSpecs.get_supported_langs()) do
		local lang_spec = LangSpecs.new(lang)
		for struct_name, struct_cases in pairs(require("tests.defaults.annotations.test_cases." .. lang)) do
			describe(lang .. " - " .. struct_name, function()
				for idx, struct_case in ipairs(struct_cases) do
					for _, style_name in ipairs(lang_spec:get_supported_styles()) do
						it("(" .. style_name .. ") - Case #" .. idx, function()
							test_utils.mock_buffer(
								lang,
								struct_case.structure,
								{ row = struct_case.cursor_pos, col = struct_case.cursor_col or 1 }
							)

							assert.are.same(
								struct_case.expected_annotation[style_name],
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
