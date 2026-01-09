local validator = require("codedocs.specs.validators.init")
local opts = require("codedocs.specs.langs.style_opts")

local Reader = {}

local function _get_data(lang) return require("codedocs.specs.langs." .. lang) end

function Reader:_get_struct_main_style(lang, struct_name)
	local lang_data = _get_data(lang)
	local default_style = lang_data.default_style

	local struct_path = "codedocs.specs.langs." .. lang .. "." .. struct_name
	return require(struct_path .. ".styles." .. default_style)
end

function Reader:get_struct_data(lang, struct_name)
	local lang_data = _get_data(lang)
	if not validator.basic.validate(lang_data, lang) then return false end

	local main_style = self:_get_struct_main_style(lang, struct_name)
	if not validator.style.validate(opts, main_style, struct_name) then return false end
	return main_style, opts, lang_data.identifier_pos
end

function Reader:get_struct_names(lang)
	local lang_data = _get_data(lang)
	local structs = lang_data.structs
	if not validator.structs.validate(lang, lang_data, structs) then return false end
	return structs
end

function Reader:get_struct_tree(lang, struct_name)
	local struct_path = "codedocs.specs.langs." .. lang .. "." .. struct_name
	local lang_path = struct_path .. ".tree"
	local tree = require(lang_path)
	return tree
end

return Reader
