local function validate(lang_fields, lang_name)
	local missing_field
	if lang_fields.default_style == nil then
		missing_field = "default_style"
	elseif lang_fields.identifier_pos  == nil then
		missing_field = "identifier_pos"
	end

	if missing_field then
		local msg = string.format(
			"The '%s' field has not been defined for %s",
			missing_field,
			lang_name
		)
		vim.notify(msg , vim.log.levels.ERROR)
		return false
	end
	return true
end

return {
	validate = validate
}
