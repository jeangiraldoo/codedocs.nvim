local defaults = require "codedocs.config"

local LangSpecs = {}

---@return string[] supported_styles List of style names
function LangSpecs:get_supported_styles() return vim.tbl_keys(defaults.languages[self.lang_name].styles.definitions) end

---@param style_name string
---@return boolean
function LangSpecs:is_style_supported(style_name)
	local supported_styles = self:get_supported_styles()
	return vim.list_contains(supported_styles, style_name)
end

function LangSpecs.new(lang)
	if not vim.list_contains(require("codedocs").get_supported_langs(), lang) then
		error(lang .. " is not a supported language")
	end

	local spec_data = defaults.languages[lang]
	spec_data.structs = {}
	local new_lang_spec = setmetatable(spec_data, { __index = LangSpecs })

	return new_lang_spec
end

function LangSpecs:get_struct_style(struct_name, style_name)
	local style = defaults.languages[self.lang_name].styles.definitions[style_name][struct_name]
	return style
end

function LangSpecs:get_default_style() return defaults.languages[self.lang_name].styles.default end

return LangSpecs
