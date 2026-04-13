local Utils = require "tests.utils"
local config = require "codedocs.config"

Utils.for_style(function(lang_name, style_name)
	insulate("Setting default style (" .. lang_name .. "):", function()
		local original_default_style = config.languages[lang_name].default_style
		if original_default_style == style_name then return end

		it(original_default_style .. " -> " .. style_name, function()
			require("codedocs.init").setup {
				languages = {
					[lang_name] = {
						default_style = style_name,
					},
				},
			}

			local updated_default_style = config.languages[lang_name].default_style
			assert.equals(style_name, updated_default_style)
		end)
	end)
end)
