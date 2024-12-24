--- Validates if a table has more than 2 elements, and that said elements are strings
-- @param setting_name The name of the setting that contains the value to validate
-- @param table The table assigned to the setting
local function validate_table(setting_name, table)
	local msg = ""
	local item_count = 0
	for _, item in pairs(table) do
		if type(item) ~= "string" then
			msg = "contain a table with strings. Received a table a with at least a " .. type(item)
		end
		item_count = item_count + 1
	end
	if item_count < 2 then
		msg = "contain at least 2 items. Received " .. item_count
	end
	if msg ~= "" then
		return {false, msg}
	else
		return {true, ""}
	end
end

--- Validates the value assigned to a setting
-- @param setting_name The name of the setting that contains the value to validate
-- @param setting_type The datatype expected by the setting
-- @param value The value assined to the setting
local function validate_value(setting_name, setting_type, value)
	if setting_type == "number" then
		if value < 1 then
			return {res, "contain a number higher than 0. Received " .. value}
		end
	end

	if setting_type == "table" then
		return validate_table(setting_name, value)
	end	
	return {true, ""}
end

--- Validates if the value assigned to a setting corresponds to its expected data type
-- @param setting_type (string) Expected data type
-- @param actual_value Value assigned to the setting
local function validate_type(setting_type, actual_value)
	if type(actual_value) ~= setting_type then
		return false
	end
	return true
end

--- Validates if all of the settings contain the expected data types and values
-- @param settings (table) Keys used to access setting values in a template
-- @param template (table) Settings to configure the language's docstring
-- @param filetype (string) Name of the programming language used in the current file
local function validate_template(settings, template, filetype)
	for _, setting_values in pairs(settings) do
		local setting_name = setting_values.val
		local setting_type = setting_values.type
		local value_received = template[setting_name]

		local base_msg = "The " .. setting_name .. " setting for " .. filetype .. " must "

		local type_result = validate_type(setting_type, value_received)
		if not type_result then
			error(base_msg .. "be a " .. setting_type .. ". Received " .. type(value_received))
		end

		local value_result = validate_value(setting_name, setting_type, value_received)
		if not value_result[1] then
			error(base_msg .. value_result[2])
		end
	end
end

return {
	validate_template = validate_template
}
