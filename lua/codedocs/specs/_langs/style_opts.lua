--- Here are all the available opts for all languages

return {
	--- General
	layout = "table", --Defines the docstring structure with at least two parts
	direction = "boolean", -- True for above, false for below the function
	insert_at = "number", -- Position at which lines are inserted
	section_order = "table", -- Specifies the order of docstring sections

	--- Title
	cursor_pos = "number", -- Title line offset within the docstring
	gap = "boolean", -- Adds a blank line after the title if there's a section

	--- Item
	insert_gap_between = {
		enabled = "boolean", -- Adds spacing between sections if more than one exists
		text = "string", -- String to be inserted in between 2 sections
	},
	items = {
		insert_gap_between = {
			enabled = "boolean", -- Adds spacing between items if multiple exist
			text = "string", -- String to be inserted between items
		},
		include_type = "boolean", -- Includes item type if true
		indent = "boolean", -- Whether or not to indent items
		template = "table", -- List of lines representing an item
	},

	--- Class attr items
	include_class_attrs = "boolean", -- Includes class attributes if true
	include_instance_attrs = "boolean", -- Includes instance attributes if true
	include_only_constructor_instance_attrs = "boolean", -- Includes only constructor-defined attributes if true
}
