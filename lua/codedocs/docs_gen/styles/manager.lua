local opts = require("codedocs.docs_gen.styles.opts")

local function set_default_lang_style(new_styles)
	for key, value in pairs(new_styles) do
		local lang_data = require("codedocs.docs_gen.styles.langs." .. key .. ".init")
		if not lang_data then
			error("There is no language called " .. key .. " available in codedocs")
		end
		if type(value) ~= "string" then
			error("The value assigned as the default docstring style for " .. key .. " must be a string")
		end
		local lang_styles = lang_data.styles
		if not lang_styles[value] then
			error(key .. " does not have a docstring style called " .. value)
		end
		lang_data.default_style = value
	end
end

local function get_lang_data(lang, struct_name)
	local lang_data = require("codedocs.docs_gen.styles.langs." .. lang .. ".init")
	local lang_styles, lang_default_style = lang_data.styles, lang_data.default_style
	local main_style = lang_styles[lang_default_style]
	local struct_style = main_style[struct_name]
	return opts, struct_style
end

return {
	set_default_lang_style = set_default_lang_style,
	get_lang_data = get_lang_data
}
