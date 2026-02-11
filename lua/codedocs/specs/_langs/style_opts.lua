--- Here are all the available opts for all languages

local ITEM_SECTIONS = {
	"attrs",
	"params",
	"return_type",
	"globals",
}

local COMMON_OPTS = {
	layout = {
		expected_type = "table", --Defines the docstring structure with at least two parts
	},
	insert_gap_between = {
		expected_type = "table",
		sub_opts = {
			enabled = {
				expected_type = "boolean",
			},
			text = {
				expected_type = "string",
			},
		},
	},
}

local GENERAL_OPTS = {
	layout = COMMON_OPTS.layout,
	direction = {
		expected_type = "boolean", -- True for above, false for below the function
	},
	insert_at = {
		expected_type = "number", -- Position at which lines are inserted
	},
	section_order = {
		expected_type = "table", -- Specifies the order of docstring sections
	},
	item_extraction = {
		expected_type = "table",
	},
}

local SECTION_WITH_ITEMS_OPTS = {
	items = {
		expected_type = "table",
		sub_opts = {
			insert_gap_between = {
				expected_type = "table",
				sub_opts = {
					enabled = {
						expected_type = "boolean", -- Adds spacing between items if multiple exist
					},
					text = {
						expected_type = "string", -- String to be inserted between items
					},
				},
			},
			indent = {
				expected_type = "boolean", -- Whether or not to indent items
			},
			template = {
				expected_type = "table", -- List of lines representing an item
			},
		},
	},
}
SECTION_WITH_ITEMS_OPTS = vim.tbl_extend("force", SECTION_WITH_ITEMS_OPTS, COMMON_OPTS)

local STYLE_OPTS = {
	general = GENERAL_OPTS,
	title = COMMON_OPTS,
}

for _, section_name in ipairs(ITEM_SECTIONS) do
	STYLE_OPTS[section_name] = SECTION_WITH_ITEMS_OPTS
end

return STYLE_OPTS
