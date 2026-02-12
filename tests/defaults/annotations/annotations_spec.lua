local Spec = require("codedocs.specs")

local project_root = vim.fn.expand("<sfile>:p:h")
package.path = package.path .. ";" .. project_root .. "/tests/defaults/annotations/test_cases/?.lua"

local function mock_buffer(structure, cursor_pos)
	vim.api.nvim_buf_set_lines(0, 0, -1, false, structure)
	vim.api.nvim_win_set_cursor(0, { cursor_pos, 0 })
	vim.bo.swapfile = false
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
end

local function test_case(lang, style_name, expected_annotation)
	local struct_name, node = require("codedocs.struct_detector")(Spec.get_struct_identifiers(lang))
	local struct_style = Spec.get_struct_style(lang, struct_name, style_name)

	if struct_name == "comment" then
		local docs = require("codedocs.annotation_builder")(struct_style, {}, struct_style.settings.layout)
		assert.are.same(expected_annotation, docs)
		return
	end

	local struct_tree = Spec.get_struct_tree(lang, struct_name)
	local data, _ = Spec.process_tree(lang, struct_style, struct_tree, node)

	local annotation = require("codedocs.annotation_builder")(struct_style, data, struct_style.settings.layout)

	assert.are.same(expected_annotation, annotation)
end

describe("Default style annotations", function()
	for _, lang in ipairs(Spec.get_supported_langs()) do
		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_set_current_buf(buf)
		vim.bo.filetype = lang

		for struct_name, struct_cases in pairs(require(lang)) do
			describe(lang .. " - " .. struct_name, function()
				for idx, struct_case in ipairs(struct_cases) do
					for _, style_name in ipairs(Spec.get_supported_styles(lang)) do
						it("(" .. style_name .. ") - Case #" .. idx, function()
							mock_buffer(struct_case.structure, struct_case.cursor_pos)
							test_case(lang, style_name, struct_case.expected_annotation[style_name])
						end)
					end
				end
			end)
		end
	end
end)
