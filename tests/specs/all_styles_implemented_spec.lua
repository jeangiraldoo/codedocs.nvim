--- Verifies that, for each language, every structure implements all of its supported styles

local LangSpecs = require "codedocs.lang_specs.init"
local utils = require "tests.utils"

describe("All styles are implemented for each structure: ", function()
	for _, lang_name in ipairs(require("codedocs").get_supported_langs()) do
		local lang_spec = LangSpecs.new(lang_name)

		local supported_styles = lang_spec:get_supported_styles()
		local supported_structs = utils.get_supported_structs(lang_name)

		for _, struct_name in ipairs(supported_structs) do
			describe(lang_name .. " (" .. struct_name .. ") /", function()
				for _, style_name in ipairs(supported_styles) do
					it(style_name, function()
						local style = lang_spec:get_struct_style(struct_name, style_name)
						assert.is_not_nil(style)
					end)
				end
			end)
		end
	end
end)
