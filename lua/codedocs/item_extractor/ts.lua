local TS_utils = {}

---@param lang_name string
---@return { name: string, node: TSNode } | nil
function TS_utils.get_ts_target_data(lang_name)
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

		if target_name then
			local context = {
				name = target_name,
				node = ts_node,
				extract_ts_nodes = function(data) return TS_utils.extract_ts_nodes(data.node or ts_node, data.query) end,
				extract_items = function(data) return TS_utils.generic_query_parser(data.node or ts_node, data.query) end,
			}
			context.load_query = function(query_name)
				local Query_loader = require "codedocs.item_extractor.query_loader"
				return Query_loader.load(lang_name, target_name, context.extractor_name, query_name)
			end
			return context
		end

		return _extract_data(ts_node:parent(), target_identifiers)
	end

	return _extract_data(node_at_cursor, require("codedocs.config").get_target_identifiers(lang_name))
end

function TS_utils.generic_query_parser(ts_node, query_obj)
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

		if vim.tbl_count(new_item) > 0 then table.insert(items, new_item) end
	end

	return items
end

function TS_utils.extract_ts_nodes(ts_node, query_obj)
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

return TS_utils
