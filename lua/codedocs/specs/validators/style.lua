--- Displays an error message with info about the problematic setting and value
-- @param setting_name The name of the setting the problematic value is assigned to
-- @param error_msg Error message to append to the base message
local function display_error(opt_name, error_msg)
	local filetype = vim.api.nvim_buf_get_option(1, "filetype")
	local base_msg = "The " .. opt_name .. " setting for " .. filetype .. " must "
	error("\n" .. base_msg .. error_msg)
end

--- Validates if all of the items in a table are strings
-- @param table Table to validate
-- @return boolean
local function validate_table_items(table)
	for _, item in pairs(table) do
		if type(item) ~= "string" then return { false, item } end
	end
	return { true, "" }
end

--- Returns the length of a table
-- @param table The table to get the length from
-- @return number Number of elements in the table
local function get_table_length(table)
	local total_items = 0
	for _ in pairs(table) do
		total_items = total_items + 1
	end
	return total_items
end

--- Validates if a table is valid in terms of its content and length
-- @param opt_name The name of the opt that contains the table to validate
-- @param table The table to validate
local function validate_table(opt_name, table, struct_name)
	local res_items = validate_table_items(table)
	local table_length = get_table_length(table)
	if table_length < 1 then
		display_error(opt_name, "contain at least one item. Received " .. table_length)
	elseif struct_name == "func" and table_length < 2 then
		display_error(opt_name, "contain at least 2 items. Received " .. table_length)
	elseif not res_items[1] then
		display_error(opt_name, "contain a table with strings. Received a table with at least a " .. type(res_items[2]))
	end
end

--- Validates the value assigned to a setting
-- @param setting_name The name of the setting that contains the value to validate
-- @param setting_type The datatype expected by the setting
-- @param value The value assined to the setting
local function validate_value(setting_values, value, struct_name)
	if setting_values.type == "number" and value < 1 then
		display_error(setting_values.val, "contain a number higher than 0. Received " .. value)
	end

	if setting_values.type == "table" then validate_table(setting_values.val, value, struct_name) end
end

--- Validates if the value assigned to a setting corresponds to its expected data type
-- @param opt_type (string) Expected data type
-- @param actual_value Value assigned to the setting
-- @return boolean
local function validate_type(opt_type, actual_value)
	if type(actual_value) ~= opt_type then return false end
	return true
end

--- Validates if all of the opts contain the expected data types and values
-- @param opts (table) Keys used to access setting values in a style
-- @param style (table) Settings to configure the language's docstring
local function validate(opts, style, struct_name)
	for _, opt in pairs(opts) do
		for _, opt_data in pairs(opt) do
			local opt_name = opt_data.val
			local opt_expected_type = opt_data.type
			for _, section_opts in pairs(style) do
				for section_opt_name, val in pairs(section_opts) do
					if opt_name == section_opt_name then
						if not validate_type(opt_expected_type, val) then
							display_error(opt_name, "be a " .. opt_expected_type .. ". Received " .. type(val))
						end
						validate_value(opt, val, struct_name)
					end
				end
			end
		end
	end
	return true
end

return {
	validate = validate,
}
