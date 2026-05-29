local Util = require "tests.utils"
local Codedocs = require "codedocs"

describe("Add support for a new language", function()
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
		Util.mock_buffer("cobol", { "" }, { row = 1, col = 1 })

		it(("%s - %s (without items)"):format(data.lang_name, data.style_name), function()
			local annotation_data1 = Codedocs.get_annotation_data(
				data.lang_name,
				{ style_name = data.style_name, annotation_name = data.annotation.name }
			)
			local annotation_result = Codedocs.build_annotation("cobol", annotation_data1)

			assert.are.same(data.annotation.expected_lines, annotation_result.lines)
		end)
	end)
end)

describe("Adding new target-less annotation", function()
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

	Util.for_style(function(lang_name, style_name)
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
			local annotation_data =
				Codedocs.get_annotation_data(lang_name, { style_name = style_name, annotation_name = annotation.name })
			local annotation_result = Codedocs.build_annotation(lang_name, annotation_data)

			assert.are.same(annotation.expected_lines, annotation_result.lines)
		end)
	end)
end)

describe("Add new annotation with target", function()
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
					insert_gap_between = {
						text = "",
						before = {},
					},
				},
				{
					name = "someblock",
					layout = {
						"---${%snip_idx:block title}",
					},
					insert_gap_between = {
						text = "",
						before = {},
					},
					items = {
						layout = {
							"%item_name | %item_type",
						},
						insert_gap_between = {
							enabled = false,
							text = "",
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

		Util.mock_buffer("lua", {
			"if true then",
			"end",
		}, { row = 1, col = 1 })

		local annotation_data1 = Codedocs.get_annotation_data("lua", { annotation_name = target.name })
		local annotation_result = Codedocs.build_annotation("lua", annotation_data1)
		local annotation_lines = annotation_result.lines

		assert.are.same(annotation.expected_lines, annotation_lines)
	end)
end)
