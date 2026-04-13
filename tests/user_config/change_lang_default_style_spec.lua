local Codedocs = require "codedocs"
local Utils = require "tests.utils"

Utils.for_style(function(lang_name, style_name)
	insulate("Setting default style (" .. lang_name .. "):", function()
		local current_default_style = Codedocs.get_default_style(lang_name)
		if current_default_style == style_name then return end

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
	end)
end)
