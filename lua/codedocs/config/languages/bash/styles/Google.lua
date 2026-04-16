local language_utils = require "codedocs.config.languages.utils"

return {
	comment = {
		relative_position = "empty_target_or_above",
		indented = false,
		blocks = {
			language_utils.new_section {
				name = "title",
				layout = {
					"# ${%snippet_tabstop_idx:description}",
				},
			},
		},
	},
	shebang = {
		relative_position = "empty_target_or_above",
		indented = false,
		blocks = {
			language_utils.new_section {
				name = "title",
				layout = {
					"#${%snippet_tabstop_idx:!/usr/bin/env bash}",
				},
			},
		},
	},
	func = {
		relative_position = "above",
		indented = false,
		blocks = {
			language_utils.new_section {
				name = "header",
				layout = {
					"#######################################",
					"# ${%snippet_tabstop_idx:title}",
				},
			},
			language_utils.new_section(
				{ name = "globals", layout = { "# Globals:" } },
				{ layout = { "#   %item_name" } }
			),
			language_utils.new_section(
				{ name = "parameters", layout = { "# Arguments:" } },
				{ layout = { "#   ${%snippet_tabstop_idx:description}" } }
			),
			language_utils.new_section({ name = "returns", layout = { "Returns:" } }, { layout = { "%item_type:" } }),
			language_utils.new_section {
				name = "footer",
				layout = {
					"#######################################",
				},
				ignore_prev_gap = true,
			},
		},
	},
}
