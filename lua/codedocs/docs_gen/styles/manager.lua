local function set_default_lang_style(new_styles)
	local defaults = require("codedocs.docs_gen.styles.init")
	local default_styles = defaults.default_styles
	local lang_styles = defaults.lang_styles
	for key, value in pairs(new_styles) do
		if not default_styles[key] then
			error("There is no language called " .. key .. " available in codedocs")
		elseif type(value) ~= "string" then
			error("The value assigned as the default docstring style for " .. key .. " must be a string")
		elseif not lang_styles[key][value] then
			error(key .. " does not have a docstring style called " .. value)
		end
		default_styles[key] = value
	end
end

return {
	set_default_lang_style = set_default_lang_style
}
