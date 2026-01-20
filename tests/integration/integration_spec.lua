local Spec = require("codedocs.specs")
local annotation_builder = require("codedocs.annotation_builder")

local project_root = vim.fn.expand("<sfile>:p:h")
package.path = package.path .. ";" .. project_root .. "/tests/cases/?.lua"

local LANGS_TO_TEST = Spec.get_supported_langs()

local function mock_buffer(structure, cursor_pos)
	vim.api.nvim_buf_set_lines(0, 0, -1, false, structure)
	vim.api.nvim_win_set_cursor(0, { cursor_pos, 0 })
end

local function test_case(struct_name, expected_annotation)
	for style_name, expected_docs in pairs(expected_annotation) do
		local _, data, style, _ = require("codedocs.specs.tree_processor")(vim.bo.filetype, style_name)

		local docs = (struct_name == "comment") and style.general.structure
			or annotation_builder(style, data, style.general.structure)
		assert.are.same(expected_docs, docs)
	end
end

describe("Annotation building using default options", function()
	for _, lang in ipairs(LANGS_TO_TEST) do
		it(lang, function()
			vim.api.nvim_command("enew")
			vim.bo.filetype = lang

			for struct_name, cases in pairs(require(lang)) do
				for _, case in ipairs(cases) do
					mock_buffer(case.structure, case.cursor_pos)
					test_case(struct_name, case.expected_annotation)
				end
			end
		end)
	end
end)
