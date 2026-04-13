--- Verifies that, for each language, under each style, there's an annotation that corresponds
--- to each defined code target

local utils = require "tests.utils"
local Codedocs = require "codedocs"

utils.for_style(function(lang_name, style_name)
	local supported_targets = utils.get_supported_targets(lang_name)
	for _, target_name in ipairs(supported_targets) do
		describe(lang_name .. " (" .. target_name .. ") /", function()
			it(style_name, function()
				local style = Codedocs.get_annotation_tbl(lang_name, style_name, target_name)
				assert.is_not_nil(style)
			end)
		end)
	end
end)
