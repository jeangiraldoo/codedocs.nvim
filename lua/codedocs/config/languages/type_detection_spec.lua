local Utils = require "codedocs.utils.tests"
local fs_utils = require "codedocs.utils.fs"
local config = require("codedocs.config").opts
local Codedocs = require "codedocs"

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
			local target_path = vim.fs.joinpath("codedocs/config/languages", lang, "targets", target_name)

			fs_utils.for_each_dir(target_path, function(extractor_name)
				local type_cases_path = vim.fs.joinpath(target_path, extractor_name, "extraction_cases/type_detection/")

				fs_utils.for_each_dir(type_cases_path, function(case_name)
					local target_case_path = vim.fs.joinpath(type_cases_path, case_name)

					local input_file_path = vim.fs.joinpath(target_case_path, "input")
					local input = fs_utils.readfile(input_file_path)

					local metadata_module_path = fs_utils.joinmodule {
						fs_utils.path_to_module(target_case_path),
						"metadata",
					}
					local metadata = require(metadata_module_path)

					local test_datatype = create_datatype_tester(input, lang, metadata, extractor_name)
					for _, standalone_datatype in ipairs(metadata.types_to_test) do
						test_datatype(standalone_datatype)

						for _, collection_datatype in ipairs(metadata.collections_with_generics) do
							local typed_collection = collection_datatype:gsub("%%data_type", standalone_datatype)
							test_datatype(typed_collection)
						end
					end
				end)
			end)
		end
	end
end)
