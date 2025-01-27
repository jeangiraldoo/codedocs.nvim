local function require_module(val)
	return require("codedocs.docs_gen.styles" .. val)
end

local opts = require_module(".opts")
local function get_lang_data(lang)
	local lang_data = require("codedocs.docs_gen.styles.langs." .. lang .. ".init")
	local lang_styles, lang_default_style = lang_data.styles, lang_data.default_style
	local main_style = lang_styles[lang_default_style]
	return opts, main_style
end

local style_manager = require_module(".manager")

return {
	opts = opts,
	style_manager = style_manager,
	get_lang_data = get_lang_data
}
