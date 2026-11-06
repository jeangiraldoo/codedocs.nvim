local fs_utils = require "codedocs.utils.fs"

local Treesitter_provider = {}
local query_cache = {}

---@param detection CodedocsDetectionResult
---@param extractor_name string
---@param query_name string
---@return userdata?
function Treesitter_provider.load_query(detection, extractor_name, query_name)
	local language = detection.lang_name
	local target_name = detection.target_name
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

---@param node TSNode
---@param query_obj userdata
---@return TSNode[]
function Treesitter_provider.extract_nodes(node, query_obj)
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

---@param node TSNode?
---@param target_identifiers table<string, string>
---@return CodedocsDetectionResult?
local function traverse_parents(node, target_identifiers)
	while node do
		local target_name = target_identifiers[node:type()]

		if target_name then
			local row = node:range()

			return {
				target_name = target_name,
				node = node,
				row = row,
			}
		end

		node = node:parent()
	end
end

---@param lang_name string
---@return TSNode | nil
local function _get_node_at_cursor(lang_name)
	local lang_ts_parser = vim.treesitter.get_parser(0, lang_name, { error = false })

	if not lang_ts_parser then
		local error_msg = "Tree-sitter parser for " .. lang_name .. " is not installed"

		vim.notify(error_msg, vim.log.levels.ERROR)
		return
	end

	lang_ts_parser:parse()
	return vim.treesitter.get_node()
end

---@param lang_name string
---@return CodedocsDetectionResult?
function Treesitter_provider.detect(lang_name)
	vim.validate {
		lang_name = { lang_name, "string" },
	}

	local node_at_cursor = _get_node_at_cursor(lang_name)
	if not node_at_cursor then return end

	local target_identifiers = require("codedocs.config").get_target_identifiers(lang_name)
	local detection = traverse_parents(node_at_cursor, target_identifiers)
	if not detection then return end

	detection.lang_name = lang_name
	return detection
end

---@param node TSNode
---@param query_obj userdata
---@return table[]
function Treesitter_provider.extract_items(node, query_obj)
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

---@param detection CodedocsDetectionResult
---@param extractor table
---@param extractor_name string
---@return table[]
function Treesitter_provider.extract(detection, extractor, extractor_name)
	if type(extractor._ts_query_name) == "string" then
		local query_obj = Treesitter_provider.load_query(detection, extractor_name, extractor._ts_query_name)

		return Treesitter_provider.extract_items(detection.node, query_obj)
	end

	if type(extractor.handler) == "function" then
		return extractor.handler(detection, extractor_name, Treesitter_provider) or {}
	end

	return {}
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
