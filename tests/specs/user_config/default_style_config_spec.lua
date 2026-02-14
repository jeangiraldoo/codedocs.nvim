local LangSpecs = require("codedocs.lang_specs.init")

for _, lang_name in ipairs(LangSpecs.get_supported_langs()) do
	local lang_spec = LangSpecs.new(lang_name)
	local supported_styles = LangSpecs.get_supported_styles(lang_name)
	describe("Setting default style (" .. lang_name .. "):", function()
		for _, style_name in ipairs(supported_styles) do
			local current_default_style = lang_spec:get_default_style()
			if current_default_style ~= style_name then
				it(current_default_style .. " -> " .. style_name, function()
					LangSpecs.set_default_lang_style({ [lang_name] = style_name })
					assert.equals(style_name, lang_spec:get_default_style())
				end)
			end
		end
	end)
end
