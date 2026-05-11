local language_utils = require "codedocs.config.languages.utils"

return {
	comment = {
		relative_position = "empty_target_or_above",
		indented = false,
		blocks = {
			{
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
			{
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
			{
				name = "header",
				layout = {
					"#######################################",
					"# ${%snippet_tabstop_idx:title}",
				},
			},
			{
				name = "globals",
				layout = { "# Globals:" },
				items = { layout = { "#   %item_name" } },
			},
			{
				name = "parameters",
				layout = { "# Arguments:" },
				items = { layout = { "#   ${%snippet_tabstop_idx:description}" } },
			},
			{
				name = "returns",
				layout = { "Returns:" },
				items = { layout = { "%item_type:" } },
			},
			{
				name = "footer",
				layout = {
					"#######################################",
				},
				ignore_prev_gap = true,
			},
		},
	},
}
