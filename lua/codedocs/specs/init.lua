local Spec = {}

local CACHED_TREES = {}
local EXPECTED_OPTS_PER_SECTION = require("codedocs.specs._langs.style_opts")

local function _validate_section_opts(expected_opts, section_name, opts)
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
					_validate_section_opts(expected_opt_schema.sub_opts, section_name, actual_section_opt_value)
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

local function _get_lang_data(lang)
	local success, data = pcall(require, "codedocs.specs._langs." .. lang)
	if not success then return nil end

	return data
end

---Builds a list of the styles supported by a specific language
---
---It is assumed that all language structures support the same styles,
---hence it is only necessary to check what styles the `comment` structure supports
---@param lang_name string Language to get the supported styles from
---@return string[] style_names List of supported styles
function Spec.get_supported_styles(lang_name)
	if not Spec.is_lang_supported(lang_name) then return {} end

	local base_path = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h")

	local relative_path = "/_langs/" .. lang_name .. "/comment/styles"
	local files = vim.fn.readdir(vim.fs.joinpath(base_path, relative_path))

	local style_names = vim.tbl_map(function(filename) return vim.fn.fnamemodify(filename, ":r") end, files)
	return style_names
end

---Checks wether or not a style is supported by a specific language
---@param lang_name string
---@param style_name string
---@return boolean
function Spec.is_style_supported(lang_name, style_name)
	local supported_styles = Spec.get_supported_styles(lang_name)
	return vim.list_contains(supported_styles, style_name)
end

---Builds a list with the names of the structures a language supports
---@param lang_name string Language to get the supported struct names from
---@return string[] supported_struct_names
function Spec.get_supported_structs(lang_name)
	local struct_identifiers = Spec.get_struct_identifiers(lang_name)

	local values = vim.tbl_values(struct_identifiers)
	table.sort(values)
	local supported_struct_names = vim.fn.uniq(values)
	table.insert(supported_struct_names, "comment")

	return supported_struct_names
end

function Spec.set_default_lang_style(new_styles)
	for lang_name, new_default_style in pairs(new_styles) do
		if type(new_default_style) ~= "string" then
			vim.notify(
				"The value assigned as the default docstring style for " .. lang_name .. " must be a string",
				vim.log.levels.ERROR
			)
			return
		end

		if not Spec.is_lang_supported(lang_name) then
			vim.notify("There is no language called " .. lang_name .. " available in codedocs", vim.log.levels.ERROR)
			return
		end

		if not Spec.is_style_supported(lang_name, new_default_style) then
			vim.notify(
				"No style called " .. new_default_style .. " is supported by " .. lang_name,
				vim.log.levels.ERROR
			)
			return
		end

		local lang_data = _get_lang_data(lang_name)
		lang_data.default_style = new_default_style
	end
end

function Spec.get_default_style(lang_name)
	local lang_data = _get_lang_data(lang_name)
	return lang_data.default_style
end

function Spec.update_style(user_opts)
	for lang_name, user_styles in pairs(user_opts) do
		if not Spec.is_lang_supported(lang_name) then
			error("There is no language called " .. lang_name .. " available in codedocs")
		end

		for user_style_name, user_style_structs in pairs(user_styles) do
			for user_struct_name, user_struct_sections in pairs(user_style_structs) do
				local struct_style = Spec.get_struct_style(lang_name, user_struct_name, user_style_name)
				if struct_style then
					for section_name, section_opts in pairs(user_struct_sections) do
						local struct_section = struct_style[section_name]
						if struct_section == nil then
							vim.notify(
								string.format(
									"No section called %s in the %s structure in %s",
									section_name,
									user_struct_name,
									lang_name
								),
								vim.log.levels.ERROR
							)
							return
						end

						local user_section_opts_are_valid, msg =
							_validate_section_opts(EXPECTED_OPTS_PER_SECTION[section_name], section_name, section_opts)

						if not user_section_opts_are_valid and msg then
							vim.notify(msg, vim.log.levels.ERROR)
							return
						end

						struct_style[section_name] =
							vim.tbl_deep_extend("force", struct_style[section_name], section_opts)
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
	for section_name, section_opts in pairs(style) do
		local expected_opts = EXPECTED_OPTS_PER_SECTION[section_name]
		if not expected_opts then error(string.format("'%s' section_name is not supported", section_name), 0) end

		local are_opts_correct, error_msg = _validate_section_opts(expected_opts, section_name, section_opts)
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
	local function _build_node(node)
		local new_node = vim.tbl_extend("force", {}, node)
		if new_node.children then new_node.children = vim.tbl_map(_build_node, node.children) end

		local extend_new_node = require("codedocs.specs.node_types." .. new_node.type)
		return extend_new_node(new_node)
	end

	CACHED_TREES[lang] = CACHED_TREES[lang] or {}
	if not CACHED_TREES[lang][struct_name] then
		local struct_path = "codedocs.specs._langs." .. lang .. "." .. struct_name
		local lang_path = struct_path .. ".tree"
		local struct_trees_list = require(lang_path)

		local final_tree = {}
		for struct_section_name, trees in pairs(struct_trees_list) do
			final_tree[struct_section_name] = vim.tbl_map(_build_node, trees)
		end
		CACHED_TREES[lang][struct_name] = final_tree
	end

	return CACHED_TREES[lang][struct_name]
end

function Spec.process_tree(struct_style, struct_tree, node)
	local pos = node:range()

	local items = {}
	for _, section_name in pairs(struct_style.general.section_order) do
		local section_tree = struct_tree[section_name]

		items[section_name] = vim.iter(section_tree)
			:map(function(tree_node) return tree_node:process(node, struct_style) end)
			:find(
				function(section_items_list) return section_items_list and (not vim.tbl_isempty(section_items_list)) end
			) or {}
	end

	return items, pos
end

return Spec
