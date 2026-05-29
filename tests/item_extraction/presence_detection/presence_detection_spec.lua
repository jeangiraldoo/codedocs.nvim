local Utils = require "tests.utils"
local config = require("codedocs.config").opts
local Codedocs = require "codedocs"

local DIR = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")
local LANGS_TO_TEST = Utils.read_dir_names(DIR .. "/cases")

local function create_subcase_tester(lang, target_name, target_case_name)
	return function(target_subcase)
		it(target_subcase, function()
			local target_case_path = vim.fs.joinpath(DIR, "cases", lang, target_name, target_case_name, target_subcase)
			local target_case_lua_path = target_case_path:gsub("/", ".")

			local input = vim.fn.readfile(vim.fs.joinpath(target_case_path, "input"))
			local metadata = require(target_case_lua_path .. ".metadata")

			Utils.mock_buffer(lang, input, metadata.cursor_pos)

			assert.are.same(metadata.expected_items, Codedocs.get_detected_annot_data(lang).items)
		end)
	end
end

describe("Typed item extraction", function()
	for _, lang in ipairs(LANGS_TO_TEST) do
		local lang_targets = config.languages[lang].targets

		for target_name, _ in pairs(lang_targets) do
			local dir_path = DIR .. "/cases/" .. lang .. "/" .. target_name

			local target_cases = Utils.read_dir_names(dir_path)

			for _, target_case_name in ipairs(target_cases) do
				local target_subcases = Utils.read_dir_names(dir_path .. "/" .. target_case_name)

				local subcase_tester = create_subcase_tester(lang, target_name, target_case_name)

				describe(lang .. " - " .. target_name .. " - " .. target_case_name, function()
					for _, target_subcase in ipairs(target_subcases) do
						subcase_tester(target_subcase)
					end
				end)
			end
		end
	end
end)
