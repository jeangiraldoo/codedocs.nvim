local Spec = {
	get_opts = function() return require("codedocs.specs._langs.style_opts") end,
}

local opts = Spec.get_opts()

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

function Spec.process_style_structs(structs, style_name, lang_name)
	for struct_name, struct_sections in pairs(structs) do
		local struct_style = Spec.get_struct_style(lang_name, struct_name, style_name)
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

			for opt_name, opt_val in pairs(section_opts) do
				local opt_default_val = struct_section[opt_name]
				if opt_default_val ~= nil then struct_section[opt_name] = opt_val end
			end
		end
	end
end

function Spec.update_style(user_opts)
	for lang_name, styles in pairs(user_opts) do
		if not Spec.is_lang_supported(lang_name) then
			error("There is no language called " .. lang_name .. " available in codedocs")
		end

		for style_name, structs in pairs(styles) do
			for struct_name, struct_sections in pairs(structs) do
				local struct_style = Spec.get_struct_style(lang_name, struct_name, style_name)
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

					for opt_name, opt_val in pairs(section_opts) do
						local opt_default_val = struct_section[opt_name]
						if opt_default_val ~= nil then struct_section[opt_name] = opt_val end
					end
				end
			end
		end
	end
end

function Spec.set_settings(settings)
	if settings.debug == true then require("codedocs.utils.debug_logger").enable() end
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

function Spec.get_struct_style(lang, struct_name, style_name)
	local function _validate_value(setting_name, setting_type, value)
		if setting_type == "number" and value < 1 then
			error(
				string.format(
					"%s setting for %s must be a number greater than 0. Received %s",
					setting_name,
					vim.bo.filetype,
					value
				)
			)
		end

		if setting_type == "table" then
			if vim.tbl_isempty(table) then
				error(setting_name .. " setting for " .. vim.bo.filetype .. " has no items")
			end

			if struct_name == "func" and vim.tbl_count(table) < 2 then
				error(setting_name .. " setting for " .. vim.bo.filetype .. " expects at least 2 items")
			end

			if not vim.iter(table):all(function(item) return type(item) == "string" end) then
				error(setting_name .. " setting for " .. vim.bo.filetype .. " must contain a table with only strings")
			end
		end
	end

	local function _validate_style_opts(style)
		for opt_name, expected_opt_type in pairs(opts) do
			for _, section_opts in pairs(style) do
				if section_opts[opt_name] then
					local actual_type = type(section_opts[opt_name])
					if actual_type ~= expected_opt_type then
						error(
							string.format(
								"%s setting for %s must be a %s. Received %s",
								opt_name,
								vim.bo.filetype,
								expected_opt_type,
								actual_type
							)
						)
					end
					_validate_value(opt_name, actual_type, section_opts[opt_name])
				end
			end
		end
		return true
	end

	if Spec.is_lang_supported(lang) then
		local style = require(string.format("codedocs.specs._langs.%s.%s.styles.%s", lang, struct_name, style_name))
		-- _validate_style_opts(style)
		return style
	end
end

function Spec.get_lang_identifier_pos(lang) return _get_lang_data(lang).identifier_pos end

function Spec:_get_struct_main_style(lang, struct_name)
	local default_style = _get_lang_data(lang).default_style

	local main_style_path = self.get_struct_style(lang, struct_name, default_style)
	return main_style_path
end

function Spec.get_struct_identifiers(lang)
	local lang_data = _get_lang_data(lang)
	return lang_data.struct_identifiers
end

function Spec.get_struct_tree(lang, struct_name)
	local struct_path = "codedocs.specs._langs." .. lang .. "." .. struct_name
	local lang_path = struct_path .. ".tree"
	local tree = require(lang_path)
	return tree
end

return Spec
