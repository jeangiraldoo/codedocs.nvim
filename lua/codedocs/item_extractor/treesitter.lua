local fs_utils = require "codedocs.utils.fs"

local Treesitter_provider = {}
local query_cache = {}

local function _load_query(language, target_name, extractor_name, query_name)
	local cache_key = language .. ":" .. target_name .. ":" .. extractor_name .. ":" .. query_name

	if query_cache[cache_key] then return query_cache[cache_key] end

	local query_path = vim.fs.joinpath(
		fs_utils.PATHS.ABS.LANGUAGES,
		language,
		"targets",
		target_name,
		extractor_name,
		"treesitter/queries",
		query_name .. ".scm"
	)

	if vim.fn.filereadable(query_path) ~= 1 then
		vim.notify("Could not find query file: " .. query_path, vim.log.levels.ERROR)
		return nil
	end

	local content = vim.fn.readfile(query_path)
	local query_string = table.concat(content, "\n")

	local ok, query = pcall(vim.treesitter.query.parse, language, query_string)

	if not ok then
		vim.notify("Failed to parse query from " .. query_path .. ": " .. tostring(query), vim.log.levels.ERROR)
		return nil
	end

	query_cache[cache_key] = query
	return query
end

local function _extract_ts_nodes(node, query_obj)
	local node_matches = query_obj:iter_matches(node, 0)

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

local function _generic_query_parser(node, query_obj)
	if not query_obj then return {} end

	local query_capture_tags = query_obj.captures

	local items = {}

	for _, match, _ in query_obj:iter_matches(node, 0) do
		local new_item = {}

		for id, capture_node in pairs(match) do
			local nodes = type(capture_node) == "table" and capture_node or { capture_node }

			for _, match_capture_node in ipairs(nodes) do
				local capture_name = query_capture_tags[id]

				local node_text = vim.treesitter.get_node_text(match_capture_node, 0)

				if capture_name == "item_name" then new_item.name = node_text end

				if capture_name == "item_type" then new_item.type = node_text end
			end
		end

		if vim.tbl_count(new_item) > 0 then table.insert(items, new_item) end
	end

	return items
end

local function _extract_data(ts_node, lang_name, target_identifiers)
	if not ts_node then return end

	local target_name = target_identifiers[ts_node:type()]

	if target_name then
		local opts = {
			node = ts_node,
			extract_ts_nodes = _extract_ts_nodes,
			extract_items = _generic_query_parser,
		}

		opts.load_query = function(query_name)
			return _load_query(lang_name, target_name, opts.extractor_name, query_name)
		end

		return target_name, ts_node:range(), opts
	end

	return _extract_data(ts_node:parent(), lang_name, target_identifiers)
end

---@param lang_name string
---@return string? target_name
---@return number? row
---@return table? target_opts
function Treesitter_provider.detect(lang_name)
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

	return _extract_data(node_at_cursor, lang_name, require("codedocs.config").get_target_identifiers(lang_name))
end

---Builds a map of tree-sitter node type -> target name for a set of targets
---@param targets_data table<string, table>
---@return table<string, string>
function Treesitter_provider.build_identifiers(targets_data)
	local target_identifiers = {}
	for target_name, target_data in pairs(targets_data) do
		if target_data.detection_opts then
			for _, node_identifier in ipairs(target_data.detection_opts.node_identifiers or {}) do
				target_identifiers[node_identifier] = target_name
			end
		end
	end
	return target_identifiers
end

return Treesitter_provider
