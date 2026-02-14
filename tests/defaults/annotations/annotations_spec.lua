local LangSpecs = require("codedocs.lang_specs.init")

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
	local lang_spec = LangSpecs.new(lang)
	local struct_name, node = require("codedocs.struct_detector")(lang_spec:get_struct_identifiers())
	local struct_style = lang_spec:get_struct_style(struct_name, style_name)

	local items_data
	if struct_name == "comment" then
		items_data = {}
	else
		items_data = lang_spec:get_struct_items(struct_name, node, style_name)
	end

	local annotation = require("codedocs.annotation_builder")(struct_style, items_data, struct_style.settings.layout)

	assert.are.same(expected_annotation, annotation)
end

describe("Default style annotations", function()
	for _, lang in ipairs(LangSpecs.get_supported_langs()) do
		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_set_current_buf(buf)
		vim.bo.filetype = lang

		for struct_name, struct_cases in pairs(require(lang)) do
			describe(lang .. " - " .. struct_name, function()
				for idx, struct_case in ipairs(struct_cases) do
					for _, style_name in ipairs(LangSpecs.get_supported_styles(lang)) do
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
