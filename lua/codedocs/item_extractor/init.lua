local TS_utils = require "codedocs.item_extractor.ts"

local Item_extractor = {}

local function _dedup_items(items)
	local dedup_items
	if vim.fn.has "nvim-0.12" == 1 then
		dedup_items = vim.iter(items):unique(function(item) return item.name end):totable()
	else ---TODO: remove when the minimum supported version is 0.12
		local seen = {}
		dedup_items = {}

		for _, item in ipairs(items) do
			local key = item.name or ""
			if not seen[key] then
				seen[key] = true
				table.insert(dedup_items, item)
			end
		end
	end

	local final_items = vim.iter(dedup_items)
		:map(function(item)
			if not item.name then item.name = "" end
			if not item.type then item.type = "" end
			return item
		end)
		:totable()

	return final_items
end

local function _get_detection_context(lang_name, detect_type)
	if detect_type == "treesitter" then
		local target_data = TS_utils.get_ts_target_data(lang_name)
		if not target_data then return end

		return target_data
	end
end

local function _extract_items(extractors, target_data, detect_type)
	local items = vim.iter(extractors):fold({}, function(acc, extractor_name, extractor_versions)
		local extractor = extractor_versions[detect_type]
		if not extractor then
			vim.notify("No extractor for detection type: " .. tostring(detect_type), vim.log.levels.WARN)
			acc[extractor_name] = {}
		else
			target_data.extractor_name = extractor_name
			if type(extractor) == "function" then
				acc[extractor_name] = _dedup_items(extractor(target_data) or {})
			elseif type(extractor) == "table" and type(extractor._ts_query_name) == "string" then
				acc[extractor_name] = _dedup_items(target_data.extract_items {
					node = target_data.node,
					query = target_data.load_query(extractor._ts_query_name),
				})
			else
				acc[extractor_name] = {}
			end
		end

		return acc
	end)

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

	local targets_config = lang_config.targets[requested_name]
	if not targets_config or not targets_config.detection then return EMPTY_TARGET_RESULT end

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
	local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1
	local lang_config = require("codedocs.config").opts.languages[lang_name]
	local target_data = _get_detection_context(lang_name, "treesitter")

	local has_detection = target_data
		and lang_config.targets[target_data.name]
		and lang_config.targets[target_data.name].detection

	if not has_detection then
		return Item_extractor.get_requested_target_data(
			lang_name,
			lang_config.styles[lang_config.default_style].default_annot
		)
	end

	local targets_config = lang_config.targets[target_data.name]

	return {
		items = _extract_items(targets_config.extractors, target_data, targets_config.detection.type),
		target_name = target_data.name,
		row = target_data.node and target_data.node:range() or cursor_row,
	}
end

return Item_extractor
