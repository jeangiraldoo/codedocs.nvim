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
}
