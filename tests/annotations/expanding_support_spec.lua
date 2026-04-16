local Util = require "tests.utils"

local ANNOTATION_DATA = {
	without_items = {
		new_annotation_name = "new_annotation",
		expected_lines = {
			"---${1:title}",
			"---Second line",
		},
	},
	with_items = {
		new_annotation_name = "if_statement",
		expected_lines = {
			"---first line",
			"---${1:block title}",
			"apollo | first",
			"artemis | second",
		},
	},
}

describe("Add support for a new language", function()
	insulate("Cobol - Cobolito style", function()
		require("codedocs").setup {
			languages = {
				cobol = {
					default_style = "cobolito",
					styles = {
						cobolito = {
							[ANNOTATION_DATA.without_items.new_annotation_name] = {
								relative_position = "empty_target_or_above",
								indented = false,
								blocks = {
									{
										name = "title",
										layout = {
											"---${%snippet_tabstop_idx:title}",
											"---Second line",
										},
									},
								},
							},
						},
					},
					targets = {},
				},
			},
		}
		Util.mock_buffer("cobol", { "" }, { row = 1, col = 1 })

		it("cobol - cobolito (without items)", function()
			local annotation_lines = require("codedocs").build_annotation("cobol", {
				style_name = "cobolito",
				annotation_name = ANNOTATION_DATA.without_items.new_annotation_name,
			}).lines
			assert.are.same(ANNOTATION_DATA.without_items.expected_lines, annotation_lines)
		end)
	end)
end)

describe("Adding new annotation", function()
	Util.for_style(function(lang_name, style_name)
		require("codedocs").setup {
			languages = {
				[lang_name] = {
					styles = {
						[style_name] = {
							[ANNOTATION_DATA.without_items.new_annotation_name] = {
								relative_position = "empty_target_or_above",
								indented = false,
								blocks = {
									{
										name = "title",
										layout = {
											"---${%snippet_tabstop_idx:title}",
											"---Second line",
										},
									},
								},
							},
						},
					},
				},
			},
		}

		it(lang_name .. " - " .. style_name .. "(without items)", function()
			local annotation_lines = require("codedocs").build_annotation(lang_name, {
				style_name = style_name,
				annotation_name = ANNOTATION_DATA.without_items.new_annotation_name,
			}).lines
			assert.are.same(ANNOTATION_DATA.without_items.expected_lines, annotation_lines)
		end)
	end)

	---Adding test cases per language would require mocking buffers with language-specific code, making the test more
	---verbose without adding much value. Since the previous test already verifies that non–code-related annotations can
	---be created, it’s sufficient here to confirm that a code-related annotation can be generated for a given language
	it("Lua - EmmyLua - if_statement (with items)", function()
		require("codedocs").setup {
			languages = {
				lua = {
					styles = {
						EmmyLua = {
							[ANNOTATION_DATA.with_items.new_annotation_name] = {
								relative_position = "empty_target_or_above",
								indented = false,
								blocks = {
									{
										name = "title",
										layout = {
											"---first line",
										},
										insert_gap_between = {
											enabled = false,
											text = "",
										},
									},
									{
										name = "someblock",
										layout = {
											"---${%snippet_tabstop_idx:block title}",
										},
										insert_gap_between = {
											enabled = false,
											text = "",
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
						},
					},
					targets = {
						[ANNOTATION_DATA.with_items.new_annotation_name] = {
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
					},
				},
			},
		}

		Util.mock_buffer("lua", {
			"if true then",
			"end",
		}, { row = 1, col = 1 })

		local annotation_lines = require("codedocs").build_annotation("lua", {
			annotation_name = ANNOTATION_DATA.with_items.new_annotation_name,
		}).lines
		assert.are.same(ANNOTATION_DATA.with_items.expected_lines, annotation_lines)
	end)
end)
