local Spec = require("codedocs.specs")

local project_root = vim.fn.expand("<sfile>:p:h")
package.path = package.path .. ";" .. project_root .. "/tests/specs/item_extraction/test_cases/?.lua"

local LANGS_TO_TEST = Spec.get_supported_langs()

local function mock_buffer(structure, cursor_pos)
	vim.api.nvim_buf_set_lines(0, 0, -1, false, structure)
	vim.api.nvim_win_set_cursor(0, { cursor_pos, 0 })
end

local function test_case(lang, expected_items)
	local struct_name, node = require("codedocs.struct_detector")(Spec.get_struct_identifiers(lang))
	local struct_tree = Spec.get_struct_tree(lang, struct_name)
	local struct_style = Spec.get_struct_style(lang, struct_name, Spec.get_default_style(lang))
	local data, _ = Spec.process_tree(struct_style, struct_tree, node)

	assert.are.same(expected_items, data)
	-- local docs = (struct_name == "comment") and struct_style.general.layout
	-- 	or annotation_builder(struct_style, data, struct_style.general.layout)
	-- assert.are.same(expected_docs, docs)
end

describe("Annotation building using default options", function()
	for _, lang in ipairs(LANGS_TO_TEST) do
		vim.api.nvim_command("enew")
		vim.bo.filetype = lang

		for _, cases in pairs(require(lang)) do
			for idx, case in ipairs(cases) do
				it(lang .. " - Case #" .. idx, function()
					mock_buffer(case.structure, case.cursor_pos)
					test_case(lang, case.expected_items)
				end)
			end
		end
	end
end)
