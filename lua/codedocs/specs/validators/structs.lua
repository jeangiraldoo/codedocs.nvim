--- This module validates that a language's specification is structured properly

local function format_path(template, values)
    return (template:gsub("{(.-)}", values))
end

local function validate_struct_style(struct_path, struct_styles, struct_name, lang, path_formats)
	if not struct_styles then
		local msg = "The 'styles' field has not been defined for " .. lang
		vim.notify(msg, vim.log.levels.ERROR)
		return false
	end

	for style_name, _ in pairs(struct_styles) do
		local style_path_in_struct = format_path(
			path_formats.style,
			{
				struct_path = struct_path,
				style_name = style_name
			}
		)
		local style_module_exists, _ = pcall(require, style_path_in_struct)
		if not style_module_exists then
			local msg = string.format(
				"The %s style module for the %s structure in %s can't be found",
				style_name,
				struct_name,
				lang
			)
			vim.notify(msg, vim.log.levels.ERROR)
			return false
		end
	end
	return true
end

local function validate_struct_tree(struct_path, path_formats, struct_name)
	local tree_path = format_path(
		path_formats.tree,
		{
			struct_path = struct_path
		}
	)
	local tree_module_exists, _ = pcall(require, tree_path)

	if not tree_module_exists then
		local msg = "The 'tree' module for the %s structure can't be found"
		vim.notify(string.format(msg, struct_name), vim.log.levels.ERROR)
		return false
	end
	return true
end

local function validate_struct_dirs(structs, struct_styles, lang, path_formats)
	for struct_name, _ in pairs(structs) do
		local path_to_struct = format_path(
			path_formats.dir,
			{
				lang_name = lang,
				struct_name = struct_name
			}
		)
		local is_dir = vim.fn.isdirectory(path_to_struct)

		if is_dir == 0 then
			local msg = string.format(
				"The directory for the '%s' structure in %s can't be found",
				struct_name,
				lang
			)
			vim.notify(msg, vim.log.levels.ERROR)
			return false
		end
		local struct_path = format_path(
			path_formats.struct_path,
			{
				lang_name = lang,
				struct_name = struct_name
			}
		)
		if not validate_struct_tree(struct_path, path_formats, struct_name) then return false end

		if not validate_struct_style(struct_path, struct_styles, struct_name, lang, path_formats) then return false end
	end
	return true
end

local function validate(lang, lang_data, structs, path_formats)
	if structs == nil then
		vim.notify("There is no 'structs' section in " .. lang, vim.log.levels.ERROR)
		return false
	end
	local struct_styles = lang_data.styles
	return validate_struct_dirs(structs, struct_styles, lang, path_formats)
end
return {
	validate = validate,
}
