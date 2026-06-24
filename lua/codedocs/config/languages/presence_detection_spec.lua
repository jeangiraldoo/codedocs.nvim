local Utils = require "tests.utils"
local config = require("codedocs.config").opts
local Codedocs = require "codedocs"

local DIR = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")
local LANGS_TO_TEST = {
	"bash",
	"c",
	"cpp",
	"go",
	"java",
	"javascript",
	"kotlin",
	"lua",
	"php",
	"python",
	"ruby",
	"rust",
	"typescript",
}

local function create_subcase_tester(lang, extractor_name, target_name)
	return function(target_subcase)
		it(target_subcase, function()
			local target_case_path = vim.fs.joinpath(
				DIR,
				lang,
				"targets",
				target_name,
				extractor_name,
				"extraction_cases/item_detection",
				target_subcase
			)
			local target_case_lua_path = target_case_path:gsub("/", ".")

			local input = vim.fn.readfile(vim.fs.joinpath(target_case_path, "input"))
			print(vim.inspect(input))
			local metadata = require(target_case_lua_path .. ".metadata")

			Utils.mock_buffer(lang, input, metadata.cursor_pos)

			assert.are.same(metadata.expected_items, Codedocs.get_detected_target_data(lang).items)
		end)
	end
end

describe("Typed item extraction", function()
	for _, lang in ipairs(LANGS_TO_TEST) do
		local lang_targets = config.languages[lang].targets

		for target_name, _ in pairs(lang_targets) do
			local path = DIR .. "/" .. lang .. "/targets/" .. target_name
			local extractor_names = Utils.read_dir_names(path)

			for _, extractor_name in ipairs(extractor_names) do
				local target_subcases =
					Utils.read_dir_names(path .. "/" .. extractor_name .. "/extraction_cases/item_detection/")

				for _, target_case_name in ipairs(target_subcases) do
					local subcase_tester = create_subcase_tester(lang, extractor_name, target_name)

					describe(
						lang .. " - " .. target_name .. " - " .. target_case_name,
						function() subcase_tester(target_case_name) end
					)
				end
			end
		end
	end
end)
