local Spec = {
	get_opts = function() return require("codedocs.specs._langs.style_opts") end,
}

local opts = Spec.get_opts()

local cached_styles = {}

local function _get_lang_data(lang)
	local success, data = pcall(require, "codedocs.specs._langs." .. lang)
	if not success then return nil end

	return data
end

function Spec.set_default_lang_style(new_styles)
	for lang_name, new_default_style in pairs(new_styles) do
		if type(new_default_style) ~= "string" then
			error("The value assigned as the default docstring style for " .. lang_name .. " must be a string")
		end

		if not Spec.is_lang_supported(lang_name) then
			error("There is no language called " .. lang_name .. " available in codedocs")
		end

		local lang_data = _get_lang_data(lang_name)

		if not lang_data.styles[new_default_style] then
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

function Spec.process_style_structs(structs, style_name, lang_name)
	for struct_name, struct_sections in pairs(structs) do
		local struct_style = Spec:get_struct_style(lang_name, struct_name, style_name)
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

function Spec.update_style(user_opts)
	for lang_name, styles in pairs(user_opts) do
		if not Spec.is_lang_supported(lang_name) then
			error("There is no language called " .. lang_name .. " available in codedocs")
		end

		for style_name, structs in pairs(styles) do
			Spec.process_style_structs(structs, style_name, lang_name)
		end
	end
end

function Spec.set_settings(settings)
	if settings.debug == true then require("codedocs.utils.debug_logger").enable() end
end

--- Validates if a table is valid in terms of its content and length
-- @param opt_name The name of the opt that contains the table to validate
-- @param table The table to validate
local function _validate_table(opt_name, table, struct_name)
	if vim.tbl_isempty(table) then error(opt_name .. " setting for " .. vim.bo.filetype .. " has no items") end

	if struct_name == "func" and vim.tbl_count(table) < 2 then
		error(opt_name .. " setting for " .. vim.bo.filetype .. " expects at least 2 items")
	end

	if not vim.iter(table):all(function(item) return type(item) == "string" end) then
		error(opt_name .. " setting for " .. vim.bo.filetype .. " must contain a table with only strings")
	end
end

--- Validates the value assigned to a setting
-- @param setting_name The name of the setting that contains the value to validate
-- @param setting_type The datatype expected by the setting
-- @param value The value assined to the setting
local function _validate_value(setting_values, value, struct_name)
	if setting_values.type == "number" and value < 1 then
		error(
			string.format(
				"%s setting for %s must be a number greater than 0. Received %s",
				setting_values.val,
				vim.bo.filetype,
				value
			)
		)
	end

	if setting_values.type == "table" then _validate_table(setting_values.val, value, struct_name) end
end

--- Validates if all of the opts contain the expected data types and values
-- @param opts (table) Keys used to access setting values in a style
-- @param style (table) Settings to configure the language's docstring
local function _validate_style_opts(opts, style, struct_name)
	for _, opt in pairs(opts) do
		local opt_name = opt.val
		local opt_expected_type = opt.type
		for _, section_opts in pairs(style) do
			for section_opt_name, val in pairs(section_opts) do
				if opt_name == section_opt_name then
					if not (type(val) == opt_expected_type) then
						error(
							string.format(
								"%s setting for %s must be a %s. Received %s",
								opt_name,
								vim.bo.filetype,
								opt_expected_type,
								type(val)
							)
						)
					end
					_validate_value(opt, val, struct_name)
				end
			end
		end
	end
	return true
end

local function _resolve_style(raw_style)
	local resolved = {}

	for section, values in pairs(raw_style) do
		resolved[section] = {}
		for key, value in pairs(values) do
			local opt = opts[key]
			assert(opt, "Unknown style option: " .. key)
			assert(type(value) == opt.type, "Invalid type for " .. key)
			resolved[section][opt.val] = value
		end
	end

	return resolved
end

Spec.get_supported_langs = (function()
	local source = debug.getinfo(1, "S").source
	local path = source:sub(2)

	local base_dir = vim.fs.dirname(path)
	local target_dir = vim.fs.joinpath(base_dir, "_langs")

	local SUPPORTED_LANGS = {}

	for item_name, item_type in vim.fs.dir(target_dir) do
		if item_type == "directory" then table.insert(SUPPORTED_LANGS, item_name) end
	end

	return function() return SUPPORTED_LANGS end
end)()

function Spec.is_lang_supported(lang) return vim.list_contains(Spec.get_supported_langs(), lang) end

function Spec:get_struct_style(lang, struct, style_name)
	cached_styles[lang] = cached_styles[lang] or {}
	cached_styles[lang][struct] = cached_styles[lang][struct] or {}
	cached_styles[lang][struct][style_name] = cached_styles[lang][struct][style_name]
		or (function()
			local raw = require("codedocs.specs._langs." .. lang .. "." .. struct .. ".styles." .. style_name)
			local style = _resolve_style(raw)
			_validate_style_opts(opts, style, struct)
			return style
		end)()

	return cached_styles[lang][struct][style_name]
end

function Spec.get_lang_identifier_pos(lang) return _get_lang_data(lang).identifier_pos end

function Spec:_get_struct_main_style(lang, struct_name)
	local default_style = _get_lang_data(lang).default_style

	local main_style_path = self:get_struct_style(lang, struct_name, default_style)
	return main_style_path
end

function Spec.get_struct_identifiers(lang)
	local lang_data = _get_lang_data(lang)
	return lang_data.struct_identifiers
end

function Spec:get_struct_tree(lang, struct_name)
	local struct_path = "codedocs.specs._langs." .. lang .. "." .. struct_name
	local lang_path = struct_path .. ".tree"
	local tree = require(lang_path)
	return tree
end

return Spec
