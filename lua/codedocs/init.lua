local Debug_logger = require "codedocs.utils.debug_logger"
local docs_builder = require "codedocs.annotation_builder"

local Codedocs = {}
function Codedocs.get_supported_langs() return vim.tbl_keys(require("codedocs.config").languages) end

function Codedocs.get_default_style(lang_name) return require("codedocs.config").languages[lang_name].default_style end

---Returns an existing annotation table from the configuration table
---Equivalent to `require("codedocs.config").languages[[lang_name]].styles[[style_name]][[annotation_name]]
---@param lang_name string
---@param style_name string
---@param annotation_name string
---@return CodedocsAnnotationStyleOpts annotation_tbl
function Codedocs.get_annotation_tbl(lang_name, style_name, annotation_name)
	assert(type(lang_name) == "string", "The 'lang_name' parameter must be a string, got " .. type(lang_name))
	assert(type(style_name) == "string", "The 'style_name' parameter must be a string, got " .. type(style_name))
	assert(
		type(annotation_name) == "string",
		"The 'annotation_name' parameter must be a string, got " .. type(annotation_name)
	)

	local annotation_tbl = require("codedocs.config").languages[lang_name].styles[style_name][annotation_name]
	return annotation_tbl
end

---@return string[] supported_styles List of style names
function Codedocs.get_supported_styles(lang_name)
	return vim.tbl_keys(require("codedocs.config").languages[lang_name].styles)
end

function Codedocs.get_target_identifiers(lang_name)
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

--- Inserts an annotation relative to a target and moves the cursor to the annotation title
---@param annotation_lines string[]
---@param row number 0-based annotation-related positions
---@param relative_position "above" | "below" | "empty_target_or_above" Position relative to the target row
local function _write_to_buffer(annotation_lines, row, relative_position)
	assert(type(annotation_lines) == "table", "'annotation' must be a string, got " .. type(annotation_lines))
	assert(type(relative_position) == "string", "'relative_position' must be a string, got " .. type(relative_position))
	assert(type(row) == "number", "'row' must be a number, got " .. type(row))
	assert(row >= 0, "'annotation_row' must be 0 or higher, got " .. row)

	local should_insert_extra_line = (
		relative_position == "empty_target_or_above" and vim.api.nvim_get_current_line() ~= ""
	)
		or relative_position == "above"
		or relative_position == "below"

	local final_row_pos = relative_position == "below" and row + 1 or row

	if should_insert_extra_line then vim.api.nvim_buf_set_lines(0, final_row_pos, final_row_pos, false, { "" }) end

	--- Lines are inserted at the cursor position
	vim.api.nvim_win_set_cursor(0, {
		final_row_pos + 1, -- expects 1-based row
		0,
	})
	local lines = table.concat(annotation_lines, "\n")
	vim.snippet.expand(lines)
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

---@param user_config CodedocsConfig?
function Codedocs.setup(user_config)
	if not user_config then return end

	assert(type(user_config) == "table", "The Codedocs `setup` function expects a table, got " .. type(user_config))

	local config = require "codedocs.config"
	local merged = vim.tbl_deep_extend("force", config, user_config)

	for k in pairs(config) do
		config[k] = nil
	end
	for k, v in pairs(merged) do
		config[k] = v
	end
end

function Codedocs.extract_item_data(lang_name, target_name)
	assert(type(lang_name) == "string", "'lang_name' parameter must be a string, got " .. type(lang_name))
	if target_name then
		assert(type(target_name) == "string", "'target_name' parameter must be a string, got " .. type(target_name))
	end

	vim.treesitter.get_parser(0):parse()
	local node_at_cursor = vim.treesitter.get_node()

	local target_data = _get_supported_target_node_data(node_at_cursor, Codedocs.get_target_identifiers(lang_name))

	if not target_data or (target_name and target_name ~= target_data.name) then
		return {}, target_name or "comment", vim.api.nvim_win_get_cursor(0)[1] - 1
	end

	local targets_config = require("codedocs.config").languages[lang_name].targets[target_data.name]

	local items =
		require "codedocs.item_extractor"(lang_name, target_data.node, targets_config.extractors, targets_config.opts)

	Debug_logger.log("Item data: ", items)

	local target_pos = target_data.node:range()

	return items, target_data.name, target_pos
end

function Codedocs.orchestrate_annotation_build(lang_data)
	local items_data, target_name, annotation_row = Codedocs.extract_item_data(lang_data.name, lang_data.substyle_name)

	local annotation_tbl = Codedocs.get_annotation_tbl(
		lang_data.name,
		lang_data.style_name or Codedocs.get_default_style(lang_data.name),
		lang_data.substyle_name or target_name
	)

	Debug_logger.log("Structure name: " .. target_name)
	Debug_logger.log("Style name: " .. Codedocs.get_default_style(lang_data.name))
	Debug_logger.log("Annotation table: ", annotation_tbl)

	local target_data = {
		should_indent = annotation_tbl.indented,
		line_num = annotation_row + 1,
	}

	local annotation_lines = docs_builder(annotation_tbl, items_data, target_data)

	return annotation_lines, annotation_row, annotation_tbl.relative_position
end

function Codedocs.generate(substyle_name)
	Debug_logger.log "Plugin triggered"

	local lang_name = require("codedocs.config").aliases[vim.bo.filetype] or vim.bo.filetype
	Debug_logger.log("Language: " .. lang_name)

	if not vim.treesitter.get_parser(0, lang_name, { error = false }) then
		vim.notify("Tree-sitter parser for " .. lang_name .. " is not installed", vim.log.levels.ERROR)
		return
	end

	local annotation_lines, row, relative_position =
		Codedocs.orchestrate_annotation_build { name = lang_name, substyle_name = substyle_name }

	Debug_logger.log("Annotation:", annotation_lines)

	_write_to_buffer(annotation_lines, row, relative_position)
end

return Codedocs
