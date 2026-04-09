--- Verifies that, for each language, every structure implements all of its supported styles

local utils = require "tests.utils"
local Codedocs = require "codedocs"

describe("All styles are implemented for each target: ", function()
	for _, lang_name in ipairs(Codedocs.get_supported_langs()) do
		local supported_styles = Codedocs.get_supported_styles(lang_name)
		local supported_targets = utils.get_supported_targets(lang_name)

		for _, target_name in ipairs(supported_targets) do
			describe(lang_name .. " (" .. target_name .. ") /", function()
				for _, style_name in ipairs(supported_styles) do
					it(style_name, function()
						local style = Codedocs.get_target_style(lang_name, target_name, style_name)
						assert.is_not_nil(style)
					end)
				end
			end)
		end
	end
end)
