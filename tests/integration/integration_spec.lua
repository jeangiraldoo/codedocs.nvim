local Spec = require("codedocs.specs")
local annotation_builder = require("codedocs.annotation_builder")

local project_root = vim.fn.expand("<sfile>:p:h")
package.path = package.path .. ";" .. project_root .. "/tests/cases/?.lua"

local LANGS_TO_TEST = Spec.get_supported_langs()

local function mock_buffer(structure, cursor_pos)
	vim.api.nvim_buf_set_lines(0, 0, -1, false, structure)
	vim.api.nvim_win_set_cursor(0, { cursor_pos, 0 })
end

local function test_case(lang, expected_annotation)
	for style_name, expected_docs in pairs(expected_annotation) do
		local struct_name, node = require("codedocs.struct_detector")(Spec.get_struct_identifiers(lang))
		local struct_tree = Spec.get_struct_tree(lang, struct_name)
		local struct_style = Spec.get_struct_style(lang, struct_name, style_name)
		local data, _ = Spec.process_tree(struct_style, struct_tree, node)

		local docs = (struct_name == "comment") and struct_style.general.layout
			or annotation_builder(struct_style, data, struct_style.general.layout)
		assert.are.same(expected_docs, docs)
	end
end

describe("Annotation building using default options", function()
	for _, lang in ipairs(LANGS_TO_TEST) do
		it(lang, function()
			vim.api.nvim_command("enew")
			vim.bo.filetype = lang

			for _, cases in pairs(require(lang)) do
				for _, case in ipairs(cases) do
					mock_buffer(case.structure, case.cursor_pos)
					test_case(lang, case.expected_annotation)
				end
			end
		end)
	end
end)
