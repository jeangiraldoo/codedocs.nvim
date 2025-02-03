local paths = require("codedocs.specs.paths")
local path_formats, format_path = paths.path_formats, paths.format_path
local validator = require("codedocs.specs.validators.init")
local opts = require("codedocs.specs.langs.style_opts")

local function get_lang_data(lang, struct_name)
	local struct_path = format_path(
		path_formats.struct_path,
		{
			lang_name = lang,
			struct_name = struct_name
		}
	)
	local lang_data = require(
		format_path(
			path_formats.data,
			{
				lang_name = lang
			}
		)
	)
	if not validator.basic.validate(lang_data, lang) then return false end
	local default_style, identifier_pos = lang_data.default_style, lang_data.identifier_pos
	local main_style = require(
		format_path(
			path_formats.style,
			{
				struct_path = struct_path,
				style_name = default_style
			}
		)
	)
	if not validator.style.validate(opts, main_style, struct_name) then return false end
	return {opts, main_style, identifier_pos}
end

local function get_lang_structs(lang)
	local lang_data = require(
		format_path(
			path_formats.data,
			{
				lang_name = lang
			}
		)
	)
	local structs = lang_data.structs
	if not validator.structs.validate(lang, lang_data, structs, path_formats) then
		return false
	end
	return structs
end

local function get_struct_tree(lang, struct_name)
	local struct_path = format_path(
		path_formats.struct_path,
		{
			lang_name = lang,
			struct_name = struct_name
		}
	)
	local lang_path = format_path(
		path_formats.tree,
		{
			struct_path = struct_path
		}
	)
	return require(lang_path)
end

return {
	get_struct_style = get_lang_data,
	get_struct_names = get_lang_structs,
	get_struct_tree = get_struct_tree
}
