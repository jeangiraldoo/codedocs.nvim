local Utils = require "codedocs.utils.tests"
local config = require("codedocs.config").opts
local Codedocs = require "codedocs"

local DIR = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")
local LANGS_TO_TEST = {
	"c",
	"cpp",
	"go",
	"java",
	"kotlin",
	"php",
	"python",
	"rust",
	"typescript",
}

local function create_datatype_tester(input, lang, metadata, extractor_name)
	return function(datatype)
		it(datatype, function()
			local typed_template = vim.iter(input)
				:map(function(line) return (line:gsub("%%data_type", datatype)) end)
				:totable()

			Utils.mock_buffer(lang, typed_template, metadata.cursor_pos)

			local actual_item = Codedocs.get_target_data(lang).items[extractor_name][1]

			assert.are.same(metadata.expected_item_name, actual_item.name)
			assert.are.same(datatype, actual_item.type)
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
				local type_cases_path = path .. "/" .. extractor_name .. "/extraction_cases/type_detection/"
				local target_subcases = Utils.read_dir_names(type_cases_path)

				for _, case_name in ipairs(target_subcases) do
					local target_case_path = vim.fs.joinpath(type_cases_path, case_name)
					local target_case_lua_path = target_case_path:gsub("/", ".")

					local input = vim.fn.readfile(vim.fs.joinpath(target_case_path, "input"))
					local metadata = require(target_case_lua_path .. ".metadata")

					local test_datatype = create_datatype_tester(input, lang, metadata, extractor_name)
					for _, standalone_datatype in ipairs(metadata.types_to_test) do
						test_datatype(standalone_datatype)

						for _, collection_datatype in ipairs(metadata.collections_with_generics) do
							local typed_collection = collection_datatype:gsub("%%data_type", standalone_datatype)
							test_datatype(typed_collection)
						end
					end
				end
			end
		end
	end
end)
