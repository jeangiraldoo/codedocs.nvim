package.path = package.path .. ";" .. debug.getinfo(1, "S").source:sub(2):match "(.*/)" .. "/tests"

local test_utils = require "tests.utils"
-- local LangSpecs = require "codedocs.lang_specs.init"

local LANGS_TO_TEST = {
	"ruby",
	"lua",
	"javascript",
	"bash",
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
			local actual_item = require("codedocs.item_extractor").extract(lang).items[section_name][1]
			assert.are.same(expected_item_name, actual_item.name)
			assert.are.same(data_type, actual_item.type)
		end)
	end
end

local function test_block_types(lang, target_name, block_name, data)
	local test_datatype = create_datatype_tester(lang, target_name, block_name, data.template, data.cursor_pos)

	for _, type_name in ipairs(data.types_to_test) do
		test_datatype(type_name, data.expected_item_name)

		if data.collections_with_generics then
			for _, collection_template in ipairs(data.collections_with_generics) do
				local typed_collection = collection_template:gsub("%%data_type", type_name)
				test_datatype(typed_collection, data.expected_item_name)
			end
		end
	end
end

local function test_generic(lang, generic_cases)
	describe("generic cases", function()
		for idx, generic_case in ipairs(generic_cases) do
			it("#" .. idx, function()
				test_utils.mock_buffer(lang, generic_case.structure, generic_case.cursor_pos)

				assert.are.same(generic_case.expected_items, require("codedocs.item_extractor").extract(lang).items)
			end)
		end
	end)
end

local function test_blocks(lang, target_name, block_cases)
	for block_name, block_data in pairs(block_cases) do
		describe("[" .. block_name .. " block]", function()
			if block_data.generic then test_generic(lang, block_data.generic) end

			local block_typed_cases = block_data.typed_cases
			if block_typed_cases then test_block_types(lang, target_name, block_name, block_typed_cases) end
		end)
	end
end

describe("Typed item extraction", function()
	for _, lang in ipairs(LANGS_TO_TEST) do
		local targets_cases = require("tests.item_extraction.test_cases." .. lang)
		for target_name, target_cases in pairs(targets_cases) do
			describe(lang .. " - " .. target_name, function()
				local block_cases = target_cases.blocks
				if block_cases then test_blocks(lang, target_name, block_cases) end

				local generic_cases = target_cases.generic
				if generic_cases then test_generic(lang, generic_cases) end
			end)
		end
	end
end)
