local lang_utils = require "codedocs.config.languages.utils"

return {
	comment = {
		relative_position = "empty_target_or_above",
		indented = false,
		sections = {
			lang_utils.new_section {
				name = "title",
				layout = {
					"// ${%snippet_tabstop_idx:description}",
				},
			},
		},
	},
	func = {
		relative_position = "above",
		indented = false,
		sections = {
			lang_utils.new_section {
				name = "title",
				layout = {
					"// ${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					text = "//",
				},
			},
			lang_utils.new_section(
				{ name = "parameters", insert_gap_between = { text = "//" } },
				{ insert_gap_between = { text = "//" } }
			),
			lang_utils.new_section(
				{ name = "returns", insert_gap_between = { text = "//" } },
				{ insert_gap_between = { text = "//" } }
			),
		},
	},
}
