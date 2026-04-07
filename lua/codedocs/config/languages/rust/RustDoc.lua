local lang_utils = require "codedocs.config.languages.utils"

return {
	comment = {
		relative_position = "empty_target_or_above",
		indent = false,
		blocks = {
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
		indent = false,
		blocks = {
			lang_utils.new_section {
				name = "title",
				layout = {
					"/// ${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = true,
					text = "///",
				},
			},
			lang_utils.new_section({
				name = "parameters",
				layout = { "/// # Arguments", "///" },
				insert_gap_between = { enabled = true, text = "///" },
			}, {
				layout = {
					"/// * `%item_name` - ${%snippet_tabstop_idx:description}",
				},
				insert_gap_between = {
					text = "///",
				},
			}),
			lang_utils.new_section({
				name = "returns",
				layout = { "/// # Returns", "///" },
				insert_gap_between = {
					enabled = true,
					text = "///",
				},
			}, {
				layout = {
					"/// ${%snippet_tabstop_idx:description}",
				},
				insert_gap_between = {
					text = "///",
				},
			}),
		},
	},
}
