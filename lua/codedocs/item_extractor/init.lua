local TS_utils = require "codedocs.item_extractor.ts"

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

local function _get_detection_context(lang_name, detect_type)
	if detect_type == "treesitter" then
		local target_data = TS_utils.get_ts_target_data(lang_name)
		if not target_data then return end

		return target_data
	end
end

local function _extract_items(extractors, target_data, detect_type)
	local items = {}

	for extractor_name, extractor_versions in pairs(extractors) do
		local raw_items

		if type(extractor_versions) == "table" then
			local extractor = extractor_versions[detect_type]
			if not extractor then
				vim.notify("No extractor for detection type: " .. tostring(detect_type), vim.log.levels.WARN)
				raw_items = {}
			elseif type(extractor) == "function" then
				target_data.extractor_name = extractor_name
				raw_items = extractor(target_data) or {}
			elseif type(extractor) == "table" and type(extractor._ts_query_name) == "string" then
				target_data.extractor_name = extractor_name
				local query = target_data.load_query(extractor._ts_query_name)
				target_data.query = query
				raw_items = target_data.extract_items(target_data)
			else
				raw_items = {}
			end
		else
			raw_items = {}
		end

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

	local targets_config = lang_config.targets[requested_name]

	if not targets_config.detection then
		return {
			row = cursor_row,
			items = {},
			target_name = requested_name,
		}
	end

	local target_data = _get_detection_context(lang_name, targets_config.detection.type)

	if not target_data then return EMPTY_TARGET_RESULT end

	local items = _extract_items(targets_config.extractors, target_data, targets_config.detection.type)

	return {
		row = target_data.node and target_data.node:range() or cursor_row,
		items = (target_data.name == requested_name) and items or {},
		target_name = requested_name,
	}
end

function Item_extractor.get_detected_target_data(lang_name)
	local target_data = _get_detection_context(lang_name, "treesitter")
	local lang_config = require("codedocs.config").opts.languages[lang_name]

	if not target_data then
		return Item_extractor.get_requested_target_data(
			lang_name,
			lang_config.styles[lang_config.default_style].default_annot
		)
	end

	local targets_config = lang_config.targets[target_data.name]
	if not targets_config or not targets_config.detection then
		return Item_extractor.get_requested_target_data(
			lang_name,
			lang_config.styles[lang_config.default_style].default_annot
		)
	end

	return {
		items = _extract_items(targets_config.extractors, target_data, targets_config.detection.type),
		target_name = target_data.name,
		row = target_data.node and target_data.node:range() or vim.api.nvim_win_get_cursor(0)[1] - 1,
	}
end

return Item_extractor
