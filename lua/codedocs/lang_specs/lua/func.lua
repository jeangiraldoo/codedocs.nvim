---@class Settings
---@field insert_at number
---@field section_order string[]
---@field indented boolean
---@field relative_position "above" | "below" | "empty_target_or_above"
---@field layout string[]

---@class SectionOpts
---@field layout string[]
---@field insert_gap_between { enabled: boolean, text: string }

---@class ItemsField
---@field layout string[]
---@field insert_gap_between { enabled: boolean, text: string }

---@class ItemBasedSectionOpts: SectionOpts
---@field items ItemsField

---@alias ItemBasedSections "parameters" | "returns"
---@alias NonItemBasedSections "parameters" | "returns"

---@class style
---@field settings Settings
---@field sections table<ItemBasedSections, ItemBasedSectionOpts> | table<NonItemBasedSections, SectionOpts>

---@class CodedocsLuaFuncStyles
---@field EmmyLua style
---@field LDoc style
return {
	EmmyLua = {
		settings = {
			layout = {},
			relative_position = "above",
			insert_at = 1,
			section_order = {
				"parameters",
				"returns",
			},
			indented = false,
		},
		sections = {
			title = {
				layout = {
					"---${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = false,
					text = "--",
				},
			},
			parameters = {
				layout = {},
				insert_gap_between = {
					enabled = false,
					text = "---",
				},
				items = {
					layout = {
						"---@param %item_name ${%snippet_tabstop_idx:type} ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = "---",
					},
				},
			},
			returns = {
				layout = {},
				insert_gap_between = {
					enabled = false,
					text = "---",
				},
				items = {
					layout = {
						"---@return ${%snippet_tabstop_idx:type} ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = "---",
					},
				},
			},
		},
	},
	LDoc = {
		settings = {
			layout = {},
			relative_position = "above",
			insert_at = 1,
			section_order = {
				"parameters",
				"returns",
			},
			indent = false,
		},
		sections = {
			title = {
				layout = {
					"--- ${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = false,
					text = "--",
				},
			},
			parameters = {
				layout = {},
				insert_gap_between = {
					enabled = false,
					text = "--",
				},
				items = {
					layout = {
						"-- @param %item_name ${%snippet_tabstop_idx:type} ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = "--",
					},
				},
			},
			returns = {
				layout = {},
				insert_gap_between = {
					enabled = false,
					text = "--",
				},
				items = {
					layout = {
						"-- @return ${%snippet_tabstop_idx:type} ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = "--",
					},
				},
			},
		},
	},
}
