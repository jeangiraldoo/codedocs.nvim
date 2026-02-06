--- Here are all the available opts for all languages

local COMMON_OPTS = {
	layout = {
		expected_type = "table", --Defines the docstring structure with at least two parts
	},
	gap = {
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
	direction = {
		expected_type = "boolean", -- True for above, false for below the function
	},
	insert_at = {
		expected_type = "number", -- Position at which lines are inserted
	},
	section_order = {
		expected_type = "table", -- Specifies the order of docstring sections
	},
}
GENERAL_OPTS = vim.tbl_extend("force", GENERAL_OPTS, COMMON_OPTS)

local TITLE_OPTS = {
	gap = {
		expected_type = "boolean", -- Adds a blank line after the title if there's a section
	},
}
TITLE_OPTS = vim.tbl_extend("force", TITLE_OPTS, COMMON_OPTS)

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
			include_type = { -- Includes item type if true
				expected_type = "boolean",
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

local ATTRS_OPTS = {
	include_class_attrs = { -- Includes class attributes if true
		expected_type = "boolean",
	},
	include_instance_attrs = { -- Includes instance attributes if true
		expected_type = "boolean",
	},
	include_only_constructor_instance_attrs = { -- Includes only constructor-defined attributes if true
		expected_type = "boolean",
	},
}
ATTRS_OPTS = vim.tbl_extend("force", ATTRS_OPTS, COMMON_OPTS)
ATTRS_OPTS = vim.tbl_extend("force", ATTRS_OPTS, SECTION_WITH_ITEMS_OPTS)

return {
	general = GENERAL_OPTS,
	title = TITLE_OPTS,
	params = SECTION_WITH_ITEMS_OPTS,
	return_type = SECTION_WITH_ITEMS_OPTS,
	globals = SECTION_WITH_ITEMS_OPTS,
	attrs = ATTRS_OPTS,
}
