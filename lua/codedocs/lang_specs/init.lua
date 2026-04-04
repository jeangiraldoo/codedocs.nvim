local defaults = require "codedocs.config"

local LangSpecs = {}

local EXPECTED_OPTS_PER_SECTION = require "codedocs.lang_specs.style_opts"

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

---@return string[] supported_styles List of style names
function LangSpecs:get_supported_styles() return self.supported_styles end

---@param style_name string
---@return boolean
function LangSpecs:is_style_supported(style_name)
	local supported_styles = self:get_supported_styles()
	return vim.list_contains(supported_styles, style_name)
end

---Builds a list with the names of the structures a language supports
---@return string[] supported_struct_names
function LangSpecs:get_supported_structs()
	local struct_identifiers = self:get_struct_identifiers()

	local values = vim.tbl_values(struct_identifiers)
	table.sort(values)
	local supported_struct_names = vim.fn.uniq(values)
	table.insert(supported_struct_names, "comment")

	return supported_struct_names
end

function LangSpecs.update_style(user_opts)
	for lang_name, user_styles in pairs(user_opts) do
		if not LangSpecs.is_lang_supported(lang_name) then
			error("There is no language called " .. lang_name .. " available in codedocs")
		end

		local lang_spec = LangSpecs.new(lang_name)
		for user_style_name, user_style_structs in pairs(user_styles) do
			for user_struct_name, user_struct_categories in pairs(user_style_structs) do
				local struct_style = lang_spec:get_struct_style(user_struct_name, user_style_name)
				if struct_style then
					if user_struct_categories.settings then
						local user_section_opts_are_valid, msg = _validate_section_opts(
							EXPECTED_OPTS_PER_SECTION.settings,
							"settings",
							user_struct_categories.settings
						)

						if not user_section_opts_are_valid and msg then
							vim.notify(msg, vim.log.levels.ERROR)
							return
						end

						struct_style.settings =
							vim.tbl_deep_extend("force", struct_style.settings, user_struct_categories.settings)
					end
				end

				if user_struct_categories.sections then
					for section_name, section_opts in pairs(user_struct_categories.sections) do
						local struct_section = struct_style.sections[section_name]
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

						local user_section_opts_are_valid, msg = _validate_section_opts(
							EXPECTED_OPTS_PER_SECTION.sections[section_name],
							section_name,
							section_opts
						)

						if not user_section_opts_are_valid and msg then
							vim.notify(msg, vim.log.levels.ERROR)
							return
						end

						struct_style.sections[section_name] =
							vim.tbl_deep_extend("force", struct_style.sections[section_name], section_opts)
					end
				end
			end
		end
	end
end

LangSpecs.get_supported_langs = (function()
	local source = debug.getinfo(1, "S").source
	local path = source:sub(2)

	local target_dir = vim.fs.dirname(path)

	local SUPPORTED_LANGS = {}

	for item_name, item_type in vim.fs.dir(target_dir) do
		if item_type == "directory" then table.insert(SUPPORTED_LANGS, item_name) end
	end

	return function() return SUPPORTED_LANGS end
end)()

function LangSpecs.is_lang_supported(lang) return vim.list_contains(LangSpecs.get_supported_langs(), lang) end

function LangSpecs.get_buffer_lang_name()
	local buffer_filetype = vim.bo.filetype
	return require("codedocs.lang_specs.aliases")[buffer_filetype] or buffer_filetype
end

function LangSpecs.new(lang)
	if not LangSpecs.is_lang_supported(lang) then error(lang .. " is not a supported language") end

	local spec_data = require("codedocs.lang_specs." .. lang)
	spec_data.structs = {}
	local new_lang_spec = setmetatable(spec_data, { __index = LangSpecs })

	return new_lang_spec
end

function LangSpecs:get_struct_identifiers() return self.struct_identifiers end

local function normalize_item_fields(items)
	return vim.tbl_map(function(item)
		if not item.name then
			item.name = ""
		elseif not item.type then
			item.type = ""
		end
		return item
	end, items)
end

local function _new_item_builder()
	return {
		current = nil,
		items = {},

		start_name = function(self, name) self.current = { name = name } end,
		start_type = function(self, type) self.current = { type = type } end,

		set_name = function(self, name)
			if self.current then self.current.name = name end
		end,
		set_type = function(self, type_)
			if self.current then self.current.type = type_ end
		end,

		emit = function(self)
			if self.current then
				table.insert(self.items, self.current)
				self.current = nil
			end
		end,
	}
end

function LangSpecs:get_struct_items(struct_name, node, style_name)
	local function remove_duplicate_items_by_name(items)
		local seen = {}
		local deduplicated_list = {}

		for _, item in ipairs(items) do
			if not seen[item.name] then
				seen[item.name] = true
				table.insert(deduplicated_list, item)
			end
		end

		return deduplicated_list
	end

	local function _handle_capture(builder, capture_name, node_text, name_first)
		if capture_name == "item_name" then
			if name_first then
				builder:emit()
				builder:start_name(node_text)
			else
				if builder.current == nil then
					-- Edge case: handles items where the type is optional, but when it is present it goes before the name
					builder:start_name(node_text)
				else
					builder:set_name(node_text)
				end
				builder:emit()
			end
			return
		end

		if capture_name == "item_type" then
			if name_first then
				if builder.current == nil then
					-- Edge case: handles items with only a type (e.g. function return type) by emitting a nameless item
					builder:start_name ""
				end
				builder:set_type(node_text)
				builder:emit()
			else
				builder:emit()
				builder:start_type(node_text)
			end
		end
	end

	local function generic_query_parser(ts_node, filetype, query)
		local identifier_pos = require("codedocs.lang_specs.init").new(filetype):get_lang_identifier_pos()

		if not query then return {} end

		local query_obj = vim.treesitter.query.parse(filetype, query)
		local node_matches = query_obj:iter_matches(ts_node, 0)
		local query_capture_tags = query_obj.captures

		if vim.tbl_contains(query_capture_tags, "target") then
			local target_nodes = {}
			for _, match, _ in node_matches do
				for id, capture_node in pairs(match) do
					local nodes = type(capture_node) == "table" and capture_node or { capture_node }
					for _, ts_capture_node in ipairs(nodes) do
						if query_capture_tags[id] == "target" then table.insert(target_nodes, ts_capture_node) end
					end
				end
			end
			return target_nodes
		end

		local builder = _new_item_builder()
		local name_first = identifier_pos

		for _, match, metadata in node_matches do
			for id, capture_node in pairs(match) do
				local nodes = type(capture_node) == "table" and capture_node or { capture_node }

				for _, match_capture_node in ipairs(nodes) do
					local capture_name = query_capture_tags[id]

					local node_text = metadata.parse_as_blank ~= "true"
							and vim.treesitter.get_node_text(match_capture_node, 0)
						or ""

					_handle_capture(builder, capture_name, node_text, name_first)
				end
			end
		end

		builder:emit()
		return builder.items
	end

	local struct_style = self:get_struct_style(struct_name, style_name or self:get_default_style())

	local items_list = {}
	for _, section_name in pairs(struct_style.settings.section_order) do
		if section_name ~= "return_type" then
			local item_extractor = self.extractors[struct_name][section_name]

			local raw_items = item_extractor {
				node = node,
				style = struct_style,
				lang_name = self.lang_name,
				generic_query_parser = generic_query_parser,
				lang_query_parser =
					---@param query TSQuery
					function(query) return generic_query_parser(node, self.lang_name, query) end,
			} or {}

			if #raw_items > 1 then raw_items = remove_duplicate_items_by_name(raw_items) end

			items_list[section_name] = normalize_item_fields(raw_items)
		end
	end

	return items_list
end

function LangSpecs:get_struct_style(struct_name, style_name)
	local style = defaults.languages[self.lang_name].styles[struct_name][style_name]
	return style
end

function LangSpecs:get_default_style() return defaults.languages[self.lang_name].default_style end

function LangSpecs:get_lang_identifier_pos() return self.identifier_pos end

---@param style_name string
function LangSpecs:set_default_style(style_name)
	assert(
		type(style_name) == "string",
		("The value assigned as the default style for %s must be a string, got %s"):format(
			self.lang_name,
			type(style_name)
		)
	)

	if not self:is_style_supported(style_name) then
		vim.notify("No style called " .. style_name .. " is supported by " .. self.lang_name, vim.log.levels.ERROR)
		return
	end

	self.default_style = style_name
end

return LangSpecs
