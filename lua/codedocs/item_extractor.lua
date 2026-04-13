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

local function generic_query_parser(ts_node, filetype, query)
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

---@param ts_node TSNode Treesitter node to traverse upwards from
---@param target_identifiers table<string, string> Treesitter node types to check for
---@return { name: string, node: TSNode } | nil
local function _get_supported_target_node_data(ts_node, target_identifiers)
	if not ts_node then return end

	local target_name = target_identifiers[ts_node:type()]

	if target_name then return { name = target_name, node = ts_node } end

	return _get_supported_target_node_data(ts_node:parent(), target_identifiers)
end

function Item_extractor.get_target_identifiers(lang_name)
	local targets_data = require("codedocs.config").languages[lang_name].targets

	if targets_data._identifiers then return targets_data._identifiers end

	local target_identifiers = {}
	for target_name, target_data in pairs(targets_data) do
		for _, node_identifier in ipairs(target_data.node_identifiers) do
			target_identifiers[node_identifier] = target_name
		end
	end

	targets_data._identifiers = target_identifiers
	return target_identifiers
end

function Item_extractor.extract(lang_name, target_name)
	vim.validate {
		lang_name = { lang_name, "string" },
		target_name = { target_name, { "string", "nil" } },
	}

	vim.treesitter.get_parser(0):parse()
	local node_at_cursor = vim.treesitter.get_node()

	local target_data =
		_get_supported_target_node_data(node_at_cursor, Item_extractor.get_target_identifiers(lang_name))

	if not target_data or (target_name and target_name ~= target_data.name) then
		return {}, target_name or "comment", vim.api.nvim_win_get_cursor(0)[1] - 1
	end

	local targets_config = require("codedocs.config").languages[lang_name].targets[target_data.name]

	local items = {}
	for extractor_name, item_extractor in pairs(targets_config.extractors) do
		local raw_items = item_extractor {
			node = target_data.node,
			opts = targets_config.opts,
			lang_name = lang_name,
			generic_query_parser = generic_query_parser,
			lang_query_parser =
				---@param query TSQuery
				function(query) return generic_query_parser(target_data.node, lang_name, query) end,
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

		items[extractor_name] = final_items
	end

	local target_pos = target_data.node:range()

	return items, target_data.name, target_pos
end

return Item_extractor
