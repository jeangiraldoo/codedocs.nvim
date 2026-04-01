local LangSpecs = require "codedocs.lang_specs.init"

for _, lang_name in ipairs(require("codedocs").get_supported_langs()) do
	local lang_spec = LangSpecs.new(lang_name)
	local supported_styles = lang_spec:get_supported_styles()
	describe("Setting default style (" .. lang_name .. "):", function()
		for _, style_name in ipairs(supported_styles) do
			local current_default_style = lang_spec:get_default_style()
			if current_default_style ~= style_name then
				it(current_default_style .. " -> " .. style_name, function()
					require("codedocs.init").setup {
						languages = {
							[lang_name] = {
								styles = {
									default = style_name,
								},
							},
						},
					}

					assert.equals(style_name, lang_spec:get_default_style())
				end)
			end
		end
	end)
end
