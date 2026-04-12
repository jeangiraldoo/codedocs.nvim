--- Verifies that, for each language, under each style, there's an annotation that corresponds
--- to each defined code target

local utils = require "tests.utils"
local Codedocs = require "codedocs"

describe("All styles implemented an annotation per target: ", function()
	for _, lang_name in ipairs(Codedocs.get_supported_langs()) do
		local supported_styles = Codedocs.get_supported_styles(lang_name)
		local supported_targets = utils.get_supported_targets(lang_name)

		for _, target_name in ipairs(supported_targets) do
			describe(lang_name .. " (" .. target_name .. ") /", function()
				for _, style_name in ipairs(supported_styles) do
					it(style_name, function()
						local style = Codedocs.get_annotation_tbl(lang_name, style_name, target_name)
						assert.is_not_nil(style)
					end)
				end
			end)
		end
	end
end)
