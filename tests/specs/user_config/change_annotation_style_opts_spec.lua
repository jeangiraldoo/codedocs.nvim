---The goal of this test suite is to verify that style options for all language target sections are customizable
---
---This test is very important since customization is not something that I can directly notice is broken while
---working on the plugin (and by the moment of writing this it's broken a few times already), but any user will
---immediately tell. Additionally, the process of manually checking that customization works requires that I edit
---my own Neovim config, which is not ideal as I usually forget to revert back to what it used to look like

local Codedocs = require "codedocs"
local utils = require "tests.utils"

local BASE_MOCKED_OPTS = {
	COMMON_SECTIONS = {
		settings = {
			layout = {
				"Hours on the clock",
				"Fingers on the keyboard wait", --No better way to test the layout than with my very first Haiku
				"green message appears",
				"hand touches grass",
			},
			relative_position = "above",
			insert_at = 3,
		},
		blocks = {
			title = {
				layout = {
					"--------",
					"",
				},
			},
		},
	},
	ITEMS_SECTIONS = {
		---Structure-specific options (such as class attribute options) are not tested here.
		---They share the same code path as the options common to all item-related sections,
		---so validating the common ones is sufficient to guarantee correct behavior at this
		---level
		insert_gap_between = {
			enabled = true,
		},
		items = {
			insert_gap_between = {
				enabled = true,
			},
			layout = {
				"some layout %item_name",
			},
			indent = true,
		},
	},
}

local MOCKED_USER_STRUCT_OPTS = vim.iter({
	class = {
		sections = {
			attributes = BASE_MOCKED_OPTS.ITEMS_SECTIONS,
		},
	},
	func = {
		sections = {
			parameters = BASE_MOCKED_OPTS.ITEMS_SECTIONS,
			returns = BASE_MOCKED_OPTS.ITEMS_SECTIONS,
		},
	},
	comment = {},
}):fold({}, function(acc, target_name, target_sections)
	acc[target_name] = vim.tbl_deep_extend("error", target_sections, BASE_MOCKED_OPTS.COMMON_SECTIONS)
	return acc
end)

describe("Customizing style options", function()
	for _, lang_name in ipairs(Codedocs.get_supported_langs()) do
		for _, target_name in ipairs(utils.get_supported_targets(lang_name)) do
			describe("[" .. lang_name .. "/" .. target_name .. "]:", function()
				for _, style_name in ipairs(Codedocs.get_supported_styles(lang_name)) do
					it(style_name .. " style", function()
						local original_style =
							vim.deepcopy(Codedocs.get_target_style(lang_name, target_name, style_name))
						local original_mocked_user_opts = MOCKED_USER_STRUCT_OPTS[target_name]

						require("codedocs").setup {
							languages = {
								[lang_name] = {
									styles = {
										[style_name] = {
											[target_name] = original_mocked_user_opts,
										},
									},
								},
							},
						}

						local expected_final_style =
							vim.tbl_deep_extend("keep", vim.deepcopy(original_mocked_user_opts), original_style)

						assert.are.same(
							expected_final_style,
							Codedocs.get_target_style(lang_name, target_name, style_name)
						)
					end)
				end
			end)
		end
	end
end)
