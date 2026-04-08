local Codedocs = require "codedocs"

for _, lang_name in ipairs(Codedocs.get_supported_langs()) do
	local supported_styles = Codedocs.get_supported_styles(lang_name)
	describe("Setting default style (" .. lang_name .. "):", function()
		for _, style_name in ipairs(supported_styles) do
			local current_default_style = Codedocs.get_default_style(lang_name)
			if current_default_style ~= style_name then
				it(current_default_style .. " -> " .. style_name, function()
					require("codedocs.init").setup {
						languages = {
							[lang_name] = {
								default_style = style_name,
							},
						},
					}

					assert.equals(style_name, Codedocs.get_default_style(lang_name))
				end)
			end
		end
	end)
end
