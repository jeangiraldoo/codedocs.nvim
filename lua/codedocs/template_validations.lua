--- Displays an error message explaining what data type was expected and which one was received
-- @param setting_name (string) Name of the setting where the error occurred
-- @param setting_type (string) Expected data type
-- @param value_received Value assigned to the setting
-- @param filetype (string) Name of the programming language used in the current file
local function throw_integrity_error(setting_name, setting_type, value_received, filetype)
	local msg = 'The "%s" setting for ' .. filetype .. ' must be a %s. Received ' .. type(value_received)
	error(string.format(msg, setting_name, setting_type))
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

--- Validates if all of the settings contain the expected data types
-- @param settings (table) Keys used to access setting values in a template
-- @param template (table) Settings to configure the language's docstring
-- @param filetype (string) Name of the programming language used in the current file
local function validate_template_integrity(settings, template, filetype)
	for _, setting_values in pairs(settings) do
		local setting_name = setting_values.val
		local setting_type = setting_values.type
		local value_received = template[setting_name]
		local result = validate_type(setting_type, value_received)
		if not result then
			throw_integrity_error(setting_name, setting_type, value_received, filetype)
		end
	end
end

return {
	validate_template_integrity = validate_template_integrity
}
