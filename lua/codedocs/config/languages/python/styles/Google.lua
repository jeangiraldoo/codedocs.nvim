local lang_utils = require "codedocs.config.languages.utils"

return {
	comment = {
		relative_position = "empty_target_or_above",
		indented = false,
		blocks = {
			lang_utils.new_section {
				name = "title",
				layout = {
					"# ${%snippet_tabstop_idx:description}",
				},
			},
		},
	},
	class = {
		relative_position = "below",
		indented = true,
		blocks = {
			lang_utils.new_section {
				name = "header",
				layout = {
					'"""',
					"${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = true,
					text = "",
				},
			},
			lang_utils.new_section({ name = "attributes", layout = { "Attributes:" } }, {
				layout = {
					"%item_name (%item_type): ${%snippet_tabstop_idx:description}",
				},
				insert_gap_between = {
					text = "",
				},
			}),
			lang_utils.new_section {
				name = "footer",
				layout = {
					'"""',
				},
				ignore_prev_gap = true,
			},
		},
	},
	func = {
		relative_position = "below",
		indented = true,
		blocks = {
			lang_utils.new_section {
				name = "header",
				layout = {
					'"""',
					"${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = true,
				},
			},
			lang_utils.new_section(
				{ name = "parameters", layout = { "Args:" }, insert_gap_between = { enabled = true } },
				{
					layout = {
						"%>%item_name (${%snippet_tabstop_idx:%item_type}): ${%snippet_tabstop_idx:description}",
					},
				}
			),
			lang_utils.new_section({ name = "returns", layout = { "Returns:" } }, {
				layout = {
					"%>${%snippet_tabstop_idx:%item_type}: ${%snippet_tabstop_idx:description}",
				},
			}),
			lang_utils.new_section {
				name = "footer",
				layout = {
					'"""',
				},
				ignore_prev_gap = true,
			},
		},
	},
}
