local validator = require("codedocs.specs.validators.init")
local opts = require("codedocs.specs.langs.style_opts")

local function get_lang_data(lang, struct_name)
	local struct_path = "codedocs.specs.langs." .. lang .. "." .. struct_name
	local lang_data = require("codedocs.specs.langs." .. lang .. ".init")
	if not validator.basic.validate(lang_data, lang) then return false end

	local default_style, identifier_pos = lang_data.default_style, lang_data.identifier_pos
	local main_style = require(struct_path .. ".styles." .. default_style)
	if not validator.style.validate(opts, main_style, struct_name) then return false end
	return { opts, main_style, identifier_pos }
end

local function get_lang_structs(lang)
	local lang_data = require("codedocs.specs.langs." .. lang .. ".init")
	local structs = lang_data.structs
	if not validator.structs.validate(lang, lang_data, structs) then return false end
	return structs
end

local function get_struct_tree(lang, struct_name)
	local struct_path = "codedocs.specs.langs." .. lang .. "." .. struct_name
	local lang_path = struct_path .. ".tree"
	local tree = require(lang_path)
	print(vim.inspect(tree))
	return tree
end

return {
	get_struct_style = get_lang_data,
	get_struct_names = get_lang_structs,
	get_struct_tree = get_struct_tree,
}
