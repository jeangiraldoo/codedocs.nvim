local LangSpecs = require("codedocs.lang_specs.init")

local project_root = vim.fn.expand("<sfile>:p:h")
package.path = package.path .. ";" .. project_root .. "/tests/specs/item_extraction/test_cases/?.lua"

local LANGS_TO_TEST = LangSpecs.get_supported_langs()

local function mock_buffer(structure, cursor_pos)
	vim.api.nvim_buf_set_lines(0, 0, -1, false, structure)
	vim.api.nvim_win_set_cursor(0, { cursor_pos, 0 })
end

describe("Annotation building using default options", function()
	for _, lang in ipairs(LANGS_TO_TEST) do
		vim.api.nvim_command("enew")
		vim.bo.filetype = lang

		for _, cases in pairs(require(lang)) do
			for idx, case in ipairs(cases) do
				it(lang .. " - Case #" .. idx, function()
					mock_buffer(case.structure, case.cursor_pos)

					assert.are.same(case.expected_items, require("codedocs").extract_item_data(lang))
				end)
			end
		end
	end
end)
