local lang_utils = require "codedocs.config.languages.utils"

return {
	comment = {
		settings = {
			relative_position = "empty_target_or_above",
			indented = false,
		},
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
		settings = {
			relative_position = "above",
			indented = false,
		},
		sections = {
			lang_utils.new_section {
				name = "header",
				layout = {
					"/**",
					" * ${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = true,
					text = " *",
				},
			},
			lang_utils.new_section({ name = "parameters", insert_gap_between = { text = " *" } }, {
				layout = {
					" * @param %item_name ${%snippet_tabstop_idx:description}",
				},
				insert_gap_between = { text = " *" },
			}),
			lang_utils.new_section({ name = "returns", insert_gap_between = { text = " *" } }, {
				layout = {
					" * @return ${%snippet_tabstop_idx:description}",
				},
				insert_gap_between = { text = " *" },
			}),
			lang_utils.new_section {
				name = "footer",
				layout = {
					" */",
				},
				insert_gap_between = {
					enabled = false,
					text = " *",
				},
			},
		},
	},
}
