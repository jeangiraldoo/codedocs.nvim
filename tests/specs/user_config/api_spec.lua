local Spec = require("codedocs.specs")

for _, lang_name in ipairs(Spec.get_supported_langs()) do
	local supported_styles = Spec.get_supported_styles(lang_name)
	describe("Setting default style (" .. lang_name .. "):", function()
		for _, style_name in ipairs(supported_styles) do
			local current_default_style = Spec.get_default_style(lang_name)
			if current_default_style ~= style_name then
				it(current_default_style .. " -> " .. style_name, function()
					Spec.set_default_lang_style({ [lang_name] = style_name })
					assert.equals(style_name, Spec.get_default_style(lang_name))
				end)
			end
		end
	end)
end
