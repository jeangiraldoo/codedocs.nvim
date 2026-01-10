local opts = require("lua.codedocs.specs._langs.style_opts")

local Reader = {}

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

local function _get_data(lang) return require("codedocs.specs._langs." .. lang) end

function Reader:_get_struct_main_style(lang, struct_name)
	local default_style = _get_data(lang).default_style

	local main_style_path = string.format("codedocs.specs._langs.%s.%s.styles.%s", lang, struct_name, default_style)
	return require(main_style_path)(opts)
end

function Reader:get_struct_data(lang, struct_name)
	local function validate_basic_fields(lang_fields, lang_name)
		local required_fields = {
			"default_style",
			"identifier_pos",
		}

		for _, field_name in ipairs(required_fields) do
			if lang_fields[field_name] == nil then
				vim.notify(
					("The '%s' field has not been defined for %s"):format(field_name, lang_name),
					vim.log.levels.ERROR
				)
				return false
			end
		end
		return true
	end

	local lang_data = _get_data(lang)
	if not validate_basic_fields(lang_data, lang) then return false end

	local main_style = self:_get_struct_main_style(lang, struct_name)
	if not _validate_style_opts(opts, main_style, struct_name) then return false end
	return main_style, opts, lang_data.identifier_pos
end

function Reader:get_struct_names(lang)
	local function validate_struct_style(struct_path, struct_styles, struct_name)
		if not struct_styles then
			local msg = "The 'styles' field has not been defined for " .. lang
			vim.notify(msg, vim.log.levels.ERROR)
			return false
		end

		for style_name, _ in pairs(struct_styles) do
			local style_path_in_struct = struct_path .. ".styles." .. style_name
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

	local function validate_struct_tree(struct_path, struct_name)
		local tree_path = struct_path .. ".tree"
		local tree_module_exists, _ = pcall(require, tree_path)

		if not tree_module_exists then
			local msg = "The 'tree' module for the %s structure can't be found"
			vim.notify(string.format(msg, struct_name), vim.log.levels.ERROR)
			return false
		end
		return true
	end

	local function validate_struct_dirs(structs, struct_styles)
		for struct_name, _ in pairs(structs) do
			local script_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")

			local path_to_struct = script_dir .. "/_langs/" .. lang .. "/" .. struct_name

			local is_dir = vim.fn.isdirectory(path_to_struct)

			if is_dir == 0 then
				local msg =
					string.format("The directory for the '%s' structure in %s can't be found", struct_name, lang)
				vim.notify(msg, vim.log.levels.ERROR)
				return false
			end
			local struct_path = "codedocs.specs._langs." .. lang .. "." .. struct_name
			if not validate_struct_tree(struct_path, struct_name) then return false end

			if not validate_struct_style(struct_path, struct_styles, struct_name) then return false end
		end
		return true
	end

	local function validate(lang_data, structs)
		if structs == nil then
			vim.notify("There is no 'structs' section in " .. lang, vim.log.levels.ERROR)
			return false
		end
		local struct_styles = lang_data.styles
		return validate_struct_dirs(structs, struct_styles)
	end

	local lang_data = _get_data(lang)
	local structs = lang_data.structs
	if not validate(lang_data, structs) then return false end
	return structs
end

function Reader:get_struct_tree(lang, struct_name)
	local struct_path = "codedocs.specs._langs." .. lang .. "." .. struct_name
	local lang_path = struct_path .. ".tree"
	local tree = require(lang_path)
	return tree
end

return Reader
