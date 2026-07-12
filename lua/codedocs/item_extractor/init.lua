local Item_extractor = {}

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

local function extract_ts_nodes(ts_node, query_obj)
	local node_matches = query_obj:iter_matches(ts_node, 0)

	local target_nodes = {}
	for _, match, _ in node_matches do
		for _, capture_node in pairs(match) do
			local nodes = type(capture_node) == "table" and capture_node or { capture_node }
			for _, ts_capture_node in ipairs(nodes) do
				table.insert(target_nodes, ts_capture_node)
			end
		end
	end

	return target_nodes
end

local function generic_query_parser(ts_node, query_obj)
	if not query_obj then return {} end

	local query_capture_tags = query_obj.captures

	local items = {}

	for _, match, metadata in query_obj:iter_matches(ts_node, 0) do
		local new_item = {}

		for id, capture_node in pairs(match) do
			local nodes = type(capture_node) == "table" and capture_node or { capture_node }

			for _, match_capture_node in ipairs(nodes) do
				local capture_name = query_capture_tags[id]

				local node_text = metadata.parse_as_blank ~= "true"
						and vim.treesitter.get_node_text(match_capture_node, 0)
					or ""

				if capture_name == "item_name" then new_item.name = node_text end

				if capture_name == "item_type" then new_item.type = node_text end
			end
		end

		local exists = false

		for _, v in ipairs(items) do
			if vim.deep_equal(v, new_item) then
				exists = true
				break
			end
		end

		if vim.tbl_count(new_item) > 0 and not exists then table.insert(items, new_item) end
	end

	return items
end

local function _extract_items(extractors, target_data, language_name, target_name)
	local items = {}

	for extractor_name, item_extractor in pairs(extractors) do
		local function load_query(query_name)
			local Query_loader = require "codedocs.item_extractor.query_loader"
			return Query_loader.load(language_name, target_name, extractor_name, query_name)
		end

		local raw_items = item_extractor {
			node = target_data.node,
			load_query = load_query,
			extract_ts_nodes = function(data) return extract_ts_nodes(data.node or target_data.node, data.query) end,
			extract_items = function(data) return generic_query_parser(data.node or target_data.node, data.query) end,
		} or {}

		local dedup_items = vim.fn.has "nvim-0.12" == 1 ---TODO: remove when the minimum supported version is 0.12
				and vim.iter(raw_items):unique(function(item) return item.name end):totable()
			or remove_duplicate_items_by_name(raw_items)

		local final_items = vim.iter(dedup_items)
			:map(function(item)
				if not item.name then item.name = "" end
				if not item.type then item.type = "" end
				return item
			end)
			:totable()

		items[extractor_name] = final_items
	end

	return items
end

---@param lang_name string
---@return { name: string, node: TSNode } | nil
local function get_ts_target_data(lang_name)
	vim.validate {
		lang_name = { lang_name, "string" },
	}
	local lang_ts_parser = vim.treesitter.get_parser(0, lang_name, { error = false })

	if not lang_ts_parser then
		local error_msg = "Tree-sitter parser for " .. lang_name .. " is not installed"

		vim.notify(error_msg, vim.log.levels.ERROR)
		return
	end

	lang_ts_parser:parse()
	local node_at_cursor = vim.treesitter.get_node()

	local function _extract_data(ts_node, target_identifiers)
		if not ts_node then return end

		local target_name = target_identifiers[ts_node:type()]

		if target_name then return { name = target_name, node = ts_node } end

		return _extract_data(ts_node:parent(), target_identifiers)
	end

	return _extract_data(node_at_cursor, require("codedocs.config").get_target_identifiers(lang_name))
end

function Item_extractor.get_requested_target_data(lang_name, requested_name)
	local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1

	local lang_config = require("codedocs.config").opts.languages[lang_name]

	--- Returned when no annotation targets are available, or when using
	--- Treesitter and no matching node is found under the cursor.
	local EMPTY_TARGET_RESULT = {
		items = {},
		target_name = requested_name,
		row = cursor_row,
	}

	if not lang_config.targets[requested_name] then return EMPTY_TARGET_RESULT end

	local targets_config = require("codedocs.config").opts.languages[lang_name].targets[requested_name]

	if not targets_config.node_identifiers or vim.tbl_isempty(targets_config.node_identifiers) then
		local items = _extract_items(targets_config.extractors, {}, lang_name, requested_name)

		return {
			row = vim.api.nvim_win_get_cursor(0)[1] - 1,
			items = items,
			target_name = requested_name,
		}
	end

	local ts_target_data = get_ts_target_data(lang_name)

	if not ts_target_data then return EMPTY_TARGET_RESULT end

	local items = _extract_items(targets_config.extractors, ts_target_data, lang_name, requested_name)

	return {
		-- Ignore extracted items if cursor target differs
		row = ts_target_data.node and ts_target_data.node:range() or vim.api.nvim_win_get_cursor(0)[1] - 1,
		items = (ts_target_data and ts_target_data.name == requested_name) and items or {},
		target_name = requested_name,
	}
end

function Item_extractor.get_detected_target_data(lang_name)
	local ts_target_data = get_ts_target_data(lang_name)

	local lang_config = require("codedocs.config").opts.languages[lang_name]

	if not ts_target_data then
		return Item_extractor.get_requested_target_data(
			lang_name,
			lang_config.styles[lang_config.default_style].default_annot
		)
	end

	local targets_config = lang_config.targets[ts_target_data.name]

	return {
		items = _extract_items(targets_config.extractors, ts_target_data, lang_name, ts_target_data.name),
		target_name = ts_target_data.name,
		row = ts_target_data.node and ts_target_data.node:range() or vim.api.nvim_win_get_cursor(0)[1] - 1,
	}
end

return Item_extractor
