local Utils = require "codedocs.utils.tests"
local Codedocs = require "codedocs"

local function describe_customization(title, callback)
	describe(title, function()
		callback()

		teardown(function() package.loaded["codedocs.config"] = nil end)
	end)
end

describe_customization("Change default style", function()
	local config = require("codedocs.config").opts

	Utils.for_style(function(lang_name, style_name)
		insulate(lang_name, function()
			local original_default_style = config.languages[lang_name].default_style
			if original_default_style == style_name then return end

			it(original_default_style .. " -> " .. style_name, function()
				Codedocs.setup {
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
end)

describe_customization("Adding new target-less annotation", function()
	local annotation = {
		name = "new_annotation",
		opts = {
			placement = "current",
			blocks = {
				{
					name = "title",
					insert_gap_between = {
						text = "",
						before = {},
					},
					layout = {
						"---${%snip_idx:title}",
						"---Second line",
					},
				},
			},
		},
		expected_lines = {
			"---${1:title}",
			"---Second line",
		},
	}

	Utils.for_style(function(lang_name, style_name)
		require("codedocs").setup {
			languages = {
				[lang_name] = {
					styles = {
						[style_name] = {
							annots = {
								[annotation.name] = annotation.opts,
							},
						},
					},
				},
			},
		}

		it(lang_name .. " - " .. style_name .. "(without items)", function()
			local target_data = Codedocs.get_target_data(lang_name, { annot_name = annotation.name })
			local annot_lines = require("codedocs.annotation_builder").prepare_annotation(
				lang_name,
				{ annot_name = annotation.name },
				target_data
			).lines
			assert.are.same(annotation.expected_lines, annot_lines)
		end)
	end)
end)

describe_customization("Add new annotation with target", function()
	---Adding test cases per language would require mocking buffers with language-specific code, making the test more
	---verbose without adding much value. Since the previous test already verifies that non–code-related annotations can
	---be created, it’s sufficient here to confirm that a code-related annotation can be generated for a given language

	local annotation = {
		opts = {
			placement = "current",
			blocks = {
				{
					name = "title",
					layout = {
						"---first line",
					},
					gap_before = {},
				},
				{
					name = "someblock",
					layout = {
						"---${%snip_idx:block title}",
					},
					gap_before = {},
					items = {
						{
							name = "someblock",
							layout = {
								"%item_name | %item_type",
							},
							insert_gap_between = {
								enabled = false,
								text = "",
							},
							gap_before = {},
						},
					},
				},
			},
		},
		expected_lines = {
			"---first line",
			"---${1:block title}",
			"apollo | first",
			"artemis | second",
		},
	}

	local target = {
		name = "if_statement",
		opts = {
			node_identifiers = {
				"if_statement",
			},
			extractors = {
				someblock = function()
					return {
						{
							name = "apollo",
							type = "first",
						},
						{
							name = "artemis",
							type = "second",
						},
					}
				end,
			},
		},
	}

	it("Lua - EmmyLua - if_statement (with items)", function()
		require("codedocs").setup {
			languages = {
				lua = {
					styles = {
						EmmyLua = {
							annots = {
								[target.name] = annotation.opts,
							},
						},
					},
					targets = { [target.name] = target.opts },
				},
			},
		}

		Utils.mock_buffer("lua", {
			"if true then",
			"end",
		}, { row = 1, col = 1 })

		local target_data = Codedocs.get_target_data("lua", { annot_name = target.name, style_name = "EmmyLua" })
		local lines = require("codedocs.annotation_builder").prepare_annotation(
			"lua",
			{ annot_name = target.name, style_name = "EmmyLua" },
			target_data
		).lines

		assert.are.same(annotation.expected_lines, lines)
	end)
end)

---The goal of this test suite is to verify that style options for all language target sections are customizable
---
---This test is very important since customization is not something that I can directly notice is broken while
---working on the plugin (and by the moment of writing this it's broken a few times already), but any user will
---immediately tell. Additionally, the process of manually checking that customization works requires that I edit
---my own Neovim config, which is not ideal as I usually forget to revert back to what it used to look like

local BASE_MOCKED_OPTS = {
	COMMON_SECTIONS = {
		settings = {
			layout = {
				"Hours on the clock",
				"Fingers on the keyboard wait", --No better way to test the layout than with my very first Haiku
				"green message appears",
				"hand touches grass",
			},
			placement = "above",
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
			gap_before = {},
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

describe_customization("Customizing style options", function()
	for _, lang_name in ipairs(require("codedocs.config").get_supported_langs()) do
		for _, target_name in ipairs(Utils.get_supported_targets(lang_name)) do
			describe("[" .. lang_name .. "/" .. target_name .. "]:", function()
				for _, style_name in ipairs(require("codedocs.config").get_supported_styles(lang_name)) do
					it(style_name .. " style", function()
						local original_style = vim.deepcopy(
							require("codedocs.annotation_builder").get_annot_tbl(lang_name, style_name, target_name)
						)
						local original_mocked_user_opts = MOCKED_USER_STRUCT_OPTS[target_name]

						Codedocs.setup {
							languages = {
								[lang_name] = {
									styles = {
										[style_name] = {
											annots = {
												[target_name] = original_mocked_user_opts,
											},
										},
									},
								},
							},
						}

						local expected_final_style =
							vim.tbl_deep_extend("keep", vim.deepcopy(original_mocked_user_opts), original_style)

						assert.are.same(
							expected_final_style,
							require("codedocs.annotation_builder").get_annot_tbl(lang_name, style_name, target_name)
						)
					end)
				end
			end)
		end
	end
end)

describe_customization("Add support for a new language", function()
	local data = {
		lang_name = "cobol",
		style_name = "cobolito",
		annotation = {
			name = "super_cobol",
			opts = {
				placement = "current",
				blocks = {
					{
						name = "title",
						insert_gap_between = {
							text = "",
							before = {},
						},
						layout = {
							"---${%snip_idx:title}",
							"---Second line",
						},
						gap_before = {},
					},
				},
			},
			expected_lines = {
				"---${1:title}",
				"---Second line",
			},
		},
	}

	insulate(("%s - %s style"):format(data.lang_name, data.style_name), function()
		it(("%s - %s (without items)"):format(data.lang_name, data.style_name), function()
			Codedocs.setup {
				languages = {
					cobol = {
						default_style = data.style_name,
						styles = {
							[data.style_name] = {
								annots = {
									[data.annotation.name] = data.annotation.opts,
								},
							},
						},
						targets = {},
					},
				},
			}
			Utils.mock_buffer("cobol", { "" }, { row = 1, col = 1 })

			local target_data = Codedocs.get_target_data(data.lang_name, { annot_name = data.annotation.name })
			local annot_lines = require("codedocs.annotation_builder").prepare_annotation(
				data.lang_name,
				{ annot_name = data.annotation.name },
				target_data
			).lines

			assert.are.same(data.annotation.expected_lines, annot_lines)
		end)
	end)
end)
