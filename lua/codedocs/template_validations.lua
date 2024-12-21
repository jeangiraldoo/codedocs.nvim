local function throw_integrity_error(setting_name, msg)
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	local base_msg = 'The "%s" setting for ' .. filetype .. ' must '
	error(string.format(base_msg, setting_name) .. msg)
end

local function validate_type(setting_name, setting_type, actual_value)
	if type(actual_value) ~= setting_type then
		local msg = string.format('be a %s. Received ', setting_type) .. type(actual_value)
		throw_integrity_error(setting_name, msg)
	end
end

local function validate_template_integrity(settings, template, filetype)
	for _, setting_values in pairs(settings) do
		validate_type(setting_values.val, setting_values.type, template[setting_values.val])
	end
end

return {
	validate_template_integrity = validate_template_integrity
}
