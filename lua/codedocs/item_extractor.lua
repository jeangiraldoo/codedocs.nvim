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

return function(lang_name, node, struct_extractors, extractor_opts)
	local items_list = {}
	for extractor_name, item_extractor in pairs(struct_extractors) do
		-- local item_extractor = struct_extractors[section_name]

		local raw_items = item_extractor {
			node = node,
			opts = extractor_opts,
			-- style = struct_style,
			lang_name = lang_name,
			generic_query_parser = generic_query_parser,
			lang_query_parser =
				---@param query TSQuery
				function(query) return generic_query_parser(node, lang_name, query) end,
		} or {}

		local final_items
		if vim.fn.has "nvim-0.12" == 1 then
			final_items = vim.iter(raw_items)
				:unique(function(item) return item.name end)
				:map(function(item)
					if not item.name then item.name = "" end
					if not item.type then item.type = "" end
					return item
				end)
				:totable()
		else ---TODO: remove when the minimum supported version is 0.12
			if #raw_items > 1 then raw_items = remove_duplicate_items_by_name(raw_items) end

			final_items = vim.tbl_map(function(item)
				if not item.name then item.name = "" end
				if not item.type then item.type = "" end
				return item
			end, raw_items)
		end

		items_list[extractor_name] = final_items
	end

	return items_list
end
