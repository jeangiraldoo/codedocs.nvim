local Spec = {}

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
				if struct_style then
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

function Spec._validate_style_opts(style)
	local function validate(expected_opts, section_name, opts)
		for actual_section_opt_name, actual_section_opt_value in pairs(opts) do
			if expected_opts[actual_section_opt_name] == nil then
				return false, string.format("Invalid opt in '%s' section: %s", section_name, actual_section_opt_name)
			end
			local expected_opt_schema = expected_opts[actual_section_opt_name]

			if expected_opt_schema.expected_type ~= type(actual_section_opt_value) then
				vim.notify(
					string.format(
						"Invalid value for %s option in %s section: %s",
						actual_section_opt_name,
						section_name,
						type(actual_section_opt_value)
					),
					vim.log.levels.ERROR
				)
				return false
			end

			if expected_opt_schema.expected_type == "table" then
				if expected_opt_schema.sub_opts then
					local success, error_msg =
						validate(expected_opt_schema.sub_opts, section_name, actual_section_opt_value)
					if not success then return false, error_msg end
				elseif
					actual_section_opt_name ~= "template"
					and not (vim.iter(actual_section_opt_value):all(function(v) return type(v) == "string" end))
				then
					return false,
						string.format(
							"'%s' option in the '%s' must contain only strings",
							actual_section_opt_name,
							section_name
						)
				end
			end
		end

		return true
	end

	local EXPECTED_OPTS_PER_SECTION = require("codedocs.specs._langs.style_opts")
	for section_name, section_opts in pairs(style) do
		local expected_opts = EXPECTED_OPTS_PER_SECTION[section_name]
		if not expected_opts then error(string.format("'%s' section_name is not supported", section_name), 0) end

		local are_opts_correct, error_msg = validate(expected_opts, section_name, section_opts)
		if not are_opts_correct then return false, error_msg end
	end
	return true
end

function Spec.get_struct_style(lang, struct_name, style_name)
	if Spec.is_lang_supported(lang) then
		local style = require(string.format("codedocs.specs._langs.%s.%s.styles.%s", lang, struct_name, style_name))
		local is_style_correct, error_msg = Spec._validate_style_opts(style)
		if not is_style_correct then error(error_msg) end

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
