package.path = package.path .. ";" .. debug.getinfo(1, "S").source:sub(2):match "(.*/)" .. "/tests"
local DIR = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")

local Utils = require "tests.utils"
local config = require "codedocs.config"
local ItemExtractor = require "codedocs.item_extractor"

local LANGS_TO_TEST = Utils.read_dir_names(DIR .. "/cases")

local function create_datatype_tester(input, lang, metadata, target_case_name)
	return function(datatype)
		it(datatype, function()
			local typed_template = vim.iter(input)
				:map(function(line) return (line:gsub("%%data_type", datatype)) end)
				:totable()

			Utils.mock_buffer(lang, typed_template, metadata.cursor_pos)
			local actual_item = ItemExtractor.extract(lang).items[target_case_name][1]

			assert.are.same(metadata.expected_item_name, actual_item.name)
			assert.are.same(datatype, actual_item.type)
		end)
	end
end

describe("Typed item extraction", function()
	for _, lang in ipairs(LANGS_TO_TEST) do
		for target_name, _ in pairs(config.languages[lang].targets) do
			local dir_path = DIR .. "/cases/" .. lang .. "/" .. target_name

			local target_cases = Utils.read_dir_names(dir_path)

			for _, target_case_name in ipairs(target_cases) do
				local target_case_path = vim.fs.joinpath(DIR, "cases", lang, target_name, target_case_name)
				local target_case_lua_path = target_case_path:gsub("/", ".")

				local input = vim.fn.readfile(vim.fs.joinpath(target_case_path, "input"))
				local metadata = require(target_case_lua_path .. ".metadata")

				local test_datatype = create_datatype_tester(input, lang, metadata, target_case_name)
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
end)
