--- Verifies that, for each language, every structure implements all of its supported styles

local Specs = require("codedocs.specs")

describe("All styles are implemented for each structure: ", function()
	for _, lang_name in ipairs(Specs.get_supported_langs()) do
		local supported_styles = Specs.get_supported_styles(lang_name)
		local supported_structs = Specs.get_supported_structs(lang_name)

		for _, struct_name in ipairs(supported_structs) do
			describe(lang_name .. " (" .. struct_name .. ") /", function()
				for _, style_name in ipairs(supported_styles) do
					it(style_name, function()
						local style = Specs.get_struct_style(lang_name, struct_name, style_name)
						assert.is_not_nil(style)
					end)
				end
			end)
		end
	end
end)
