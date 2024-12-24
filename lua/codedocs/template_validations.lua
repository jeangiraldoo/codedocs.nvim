--- Displays an error message with info about the problematic setting and value
-- @param setting_name The name of the setting the problematic value is assigned to
-- @param error_msg Error message to append to the base message
local function display_error(setting_name, error_msg)
	local filetype = vim.api.nvim_buf_get_option(1, "filetype")
	local base_msg = "The " .. setting_name .. " setting for " .. filetype .. " must "
	error("\n" .. base_msg .. error_msg)
end

--- Validates if all of the items in a table are strings
-- @param table Table to validate
-- @return boolean
local function validate_table_items(table)
	for _, item in pairs(table) do
		if type(item) ~= "string" then
			return {false, item}
		end
	end
	return {true, ""}
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
-- @param settings (table) Keys used to access setting values in a template
-- @param setting_name The name of the setting that contains the table to validate
-- @param table The table to validate
local function validate_table(settings, setting_name, table)
	local res_items = validate_table_items(table)
	local table_length = get_table_length(table)
	if table_length < 2 then
		display_error(setting_name, "contain at least 2 items. Received " .. table_length)
	elseif setting_name == settings.structure.val and table_length > 3 then
		display_error(setting_name, "contain either 2 or 3 items. Received " .. table_length)
	elseif not res_items[1] then
		display_error(setting_name, "contain a table with strings. Received a table with at least a " .. type(res_items[2]))
	end
end

--- Validates the value assigned to a setting
-- @param setting_name The name of the setting that contains the value to validate
-- @param setting_type The datatype expected by the setting
-- @param value The value assined to the setting
local function validate_value(settings, setting_values, value)
	if setting_values.type == "number" and value < 1 then
		display_error(setting_values.val, "contain a number higher than 0. Received " .. value)
	end

	if setting_values.type == "table" then
		validate_table(settings, setting_values.val, value)
	end
end

--- Validates if the value assigned to a setting corresponds to its expected data type
-- @param setting_type (string) Expected data type
-- @param actual_value Value assigned to the setting
-- @return boolean
local function validate_type(setting_type, actual_value)
	if type(actual_value) ~= setting_type then
		return false
	end
	return true
end

--- Validates if all of the settings contain the expected data types and values
-- @param settings (table) Keys used to access setting values in a template
-- @param template (table) Settings to configure the language's docstring
local function validate_template(settings, template)
	for _, setting_values in pairs(settings) do
		local setting_name = setting_values.val
		local setting_type = setting_values.type
		local value_received = template[setting_name]

		if not validate_type(setting_type, value_received) then
			display_error(setting_name, "be a " .. setting_type .. ". Received " .. type(value_received))
		end
		validate_value(settings, setting_values, value_received)
	end
end

return {
	validate_template = validate_template
}
