local Reader = require("codedocs.specs").reader
local annotation_builder = require("codedocs.annotation_builder")
local Processor = require("codedocs.tree_processor")

local project_root = vim.fn.expand("<sfile>:p:h") -- folder of this spec file
package.path = package.path .. ";" .. project_root .. "/tests/cases/?.lua"

local LANGS_TO_TEST = Reader.get_supported_langs()

local function mock_buffer(structure, cursor_pos)
	vim.api.nvim_buf_set_lines(0, 0, -1, false, structure)
	vim.api.nvim_win_set_cursor(0, { cursor_pos, 0 })
end

local function test_case(lang, struct_name, style_names, expected_annotation)
	local tree = vim.treesitter.get_parser(0, lang):parse()[1]:root()
	local node = Reader.is_ts_node_type_supported(lang, tree:child(0):type()) and tree:child(0) or tree:child(1)

	local _, opts, identifier_pos = Reader:get_struct_data(lang, struct_name)

	for _, style_name in ipairs(style_names) do
		local style = Reader:get_struct_style(lang, struct_name, style_name)
		local _, data =
			Processor:item_parser(node, style.general.section_order, struct_name, style, opts, identifier_pos, lang)
		local struct = style.general[opts.struct.val]

		local docs = (struct_name == "comment") and struct or annotation_builder(style, data, struct)
		local expected_docs = expected_annotation[style_name]
		assert.are.same(expected_docs, docs)
	end
end

describe("Annotation building using default options", function()
	for _, lang in ipairs(LANGS_TO_TEST) do
		it(lang, function()
			vim.api.nvim_command("enew")
			vim.bo.filetype = lang

			local style_names = Reader.get_style_names(lang)
			for struct_name, _ in pairs(Reader:get_struct_names(lang)) do
				for _, case in ipairs(require(lang)[struct_name]) do
					mock_buffer(case.structure, case.cursor_pos)
					test_case(lang, struct_name, style_names, case.expected_annotation)
				end
			end
		end)
	end
end)
