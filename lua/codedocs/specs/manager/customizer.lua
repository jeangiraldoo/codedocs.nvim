local paths = require("codedocs.specs.paths")
local path_formats, format_path = paths.path_formats, paths.format_path

local function set_default_lang_style(new_styles)
	for lang_name, new_default_style in pairs(new_styles) do
		local lang_data = require(format_path(path_formats.data, {
			lang_name = lang_name,
		}))
		if not lang_data then error("There is no language called " .. lang_name .. " available in codedocs") end
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
	for opt_name, opt_val in pairs(section_opts) do
		local opt_default_val = struct_section[opt_name]
		if opt_default_val ~= nil then struct_section[opt_name] = opt_val end
	end
end

local function process_style_structs(structs, style_name, lang_data, lang_name)
	for struct_name, struct_sections in pairs(structs) do
		local struct_path = format_path(path_formats.struct_path, {
			lang_name = lang_name,
			struct_name = struct_name,
		})
		local style_path = format_path(path_formats.style, {
			struct_path = struct_path,
			style_name = style_name,
		})
		local struct_style = require(style_path)
		for section_name, section_opts in pairs(struct_sections) do
			local struct_section = struct_style[section_name]
			if struct_section == nil then
				error(
					"There is no section called "
						.. section_name
						.. " in the "
						.. struct_name
						.. " structrure in "
						.. lang_name
				)
			end
			update_style_opts(section_opts, struct_section)
		end
	end
end

local function update_style(user_opts)
	for lang_name, styles in pairs(user_opts) do
		local success, lang_data = pcall(require, format_path(path_formats.data, lang_name))

		if not success then error("There is no language called " .. lang_name .. " available in codedocs") end
		for style_name, structs in pairs(styles) do
			process_style_structs(structs, style_name, lang_data, lang_name)
		end
	end
end

return {
	update_style = update_style,
	set_default_lang_style = set_default_lang_style,
}
