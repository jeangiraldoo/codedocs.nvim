local defaults = require "codedocs.config"

local LangSpecs = {}

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
	return defaults.aliases[buffer_filetype] or buffer_filetype
end

function LangSpecs.new(lang)
	if not LangSpecs.is_lang_supported(lang) then error(lang .. " is not a supported language") end

	local spec_data = require("codedocs.lang_specs." .. lang)
	spec_data.structs = {}
	local new_lang_spec = setmetatable(spec_data, { __index = LangSpecs })

	return new_lang_spec
end

function LangSpecs:get_struct_identifiers() return self.extraction.struct_identifiers end

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
			local item_extractor = self.extraction.extractors[struct_name][section_name]

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
	local style = defaults.languages[self.lang_name].styles.definitions[style_name][struct_name]
	return style
end

function LangSpecs:get_default_style() return defaults.languages[self.lang_name].styles.default end

function LangSpecs:get_lang_identifier_pos() return self.identifier_pos end

return LangSpecs
