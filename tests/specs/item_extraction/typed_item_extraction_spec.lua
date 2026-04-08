package.path = package.path .. ";" .. debug.getinfo(1, "S").source:sub(2):match "(.*/)" .. "/tests"

local test_utils = require "tests.utils"
-- local LangSpecs = require "codedocs.lang_specs.init"

local LANGS_TO_TEST = {
	"kotlin",
	"c",
	"cpp",
	"go",
	"java",
	"php",
	"python",
	"rust",
	"typescript",
}
-- local LANGS_TO_TEST = LangSpecs.get_supported_langs()

local function create_datatype_tester(lang, target_name, section_name, template, cursor_pos)
	return function(data_type, expected_item_name)
		it(("%s (%s / %s) - %s"):format(lang, target_name, section_name, data_type), function()
			local typed_template = vim.iter(template)
				:map(function(line) return (line:gsub("%%data_type", data_type)) end)
				:totable()

			test_utils.mock_buffer(lang, typed_template, cursor_pos)
			local actual_item = require("codedocs").extract_item_data(lang)[section_name][1]
			assert.are.same(expected_item_name, actual_item.name)
			assert.are.same(data_type, actual_item.type)
		end)
	end
end

local function generate_tests_for_section(lang, target_name, section_name, section_data)
	local test_datatype =
		create_datatype_tester(lang, target_name, section_name, section_data.template, section_data.cursor_pos)

	for _, type_name in ipairs(section_data.types_to_test) do
		test_datatype(type_name, section_data.expected_item_name)

		if section_data.collections_with_generics then
			for _, collection_template in ipairs(section_data.collections_with_generics) do
				local typed_collection = collection_template:gsub("%%data_type", type_name)
				test_datatype(typed_collection, section_data.expected_item_name)
			end
		end
	end
end

describe("Typed item extraction", function()
	for _, lang in ipairs(LANGS_TO_TEST) do
		local cases = require("tests.specs.item_extraction.typed_test_cases." .. lang)
		for target_name, target_sections in pairs(cases) do
			for section_name, section_data in pairs(target_sections) do
				generate_tests_for_section(lang, target_name, section_name, section_data)
			end
		end
	end
end)
