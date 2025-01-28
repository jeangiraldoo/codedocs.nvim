local opts = require("codedocs.docs_gen.styles.opts")

local function require_lang_data(lang)
	local lang_data = require("codedocs.docs_gen.styles.langs." .. lang .. ".init")
	return lang_data
end

local function set_default_lang_style(new_styles)
	for lang_name, new_default_style in pairs(new_styles) do
		local lang_data = require_lang_data(lang_name)
		if not lang_data then
			error("There is no language called " .. lang_name .. " available in codedocs")
		end
		if type(new_default_style) ~= "string" then
			error("The value assigned as the default docstring style for " .. lang_name .. " must be a string")
		end
		local lang_styles = lang_data.styles
		if not lang_styles[new_default_style] then
			error(lang_name .. " does not have a docstring style called " .. new_default_style)
		end
		lang_data.default_style = new_default_style
	end
end

local function update_style_opts(section_opts, struct_section)
	for opt_name, opt_val in pairs (section_opts) do
		local opt_default_val = struct_section[opt_name]
		if opt_default_val ~= nil then
			struct_section[opt_name] = opt_val
		end
	end

end

local function process_style_structs(structs, style, lang_name)
	for struct_name, struct_sections in pairs(structs) do
		local struct_style = style[struct_name]
		if struct_style == nil then
			error("There is no structure called " .. struct_name .. " in " .. lang_name)
		end

		for section_name, section_opts in pairs(struct_sections) do
			local struct_section = struct_style[section_name]
				if struct_section == nil then
					error("There is no section called " .. section_name .. " in the " .. struct_name .. " structrure in " .. lang_name)
			end
			update_style_opts(section_opts, struct_section)
		end
	end
end

local function process_lang_styles(user_opts)
	for lang_name, styles in pairs(user_opts) do
		local lang_data = require_lang_data(lang_name)
		local lang_styles = lang_data.styles
		if not lang_data then
			error("There is no language called " .. lang_name .. " available in codedocs")
		end
		for style_name, structs in pairs(styles) do
			local style = lang_styles[style_name]
			if style == nil then
				error("There is no style called " .. style_name .. " in " .. lang_name)
			end
			process_style_structs(structs, style, lang_name)
		end
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
	update_style = process_lang_styles,
	get_lang_data = get_lang_data
}
