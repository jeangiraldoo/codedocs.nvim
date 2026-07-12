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
			row = cursor_row,
			items = items,
			target_name = requested_name,
		}
	end

	local ts_target_data = TS_utils.get_ts_target_data(lang_name)

	if not ts_target_data then return EMPTY_TARGET_RESULT end

	local items = _extract_items(targets_config.extractors, ts_target_data, lang_name, requested_name)

	return {
		-- Ignore extracted items if cursor target differs
		row = ts_target_data.node and ts_target_data.node:range() or cursor_row,
		items = (ts_target_data and ts_target_data.name == requested_name) and items or {},
		target_name = requested_name,
	}
end

function Item_extractor.get_detected_target_data(lang_name)
	local ts_target_data = TS_utils.get_ts_target_data(lang_name)

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
