local Debug_logger = require "codedocs.utils.debug_logger"
local docs_builder = require "codedocs.annotation_builder"

local Codedocs = {}
function Codedocs.get_supported_langs() return vim.tbl_keys(require("codedocs.config").languages) end

function Codedocs.get_default_style(lang_name) return require("codedocs.config").languages[lang_name].styles.default end

function Codedocs.get_struct_style(lang_name, struct_name, style_name)
	local style = require("codedocs.config").languages[lang_name].styles.definitions[style_name][struct_name]
	return style
end

---@return string[] supported_styles List of style names
function Codedocs.get_supported_styles(lang_name)
	return vim.tbl_keys(require("codedocs.config").languages[lang_name].styles.definitions)
end

function Codedocs.get_struct_identifiers(lang_name)
	local structures_data = require("codedocs.config").languages[lang_name].structures

	if structures_data._identifiers then return structures_data._identifiers end

	local struct_identifiers = {}
	for struct_name, structure_data in pairs(structures_data) do
		for _, node_identifier in ipairs(structure_data.node_identifiers) do
			struct_identifiers[node_identifier] = struct_name
		end
	end

	structures_data._identifiers = struct_identifiers
	return struct_identifiers
end

--- Inserts an annotation relative to a structure and moves the cursor to the annotation title
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
---@param struct_identifiers table<string, string> Treesitter node types to check for
---@return { name: string, node: TSNode } | nil
local function _get_supported_struct_node_data(ts_node, struct_identifiers)
	if not ts_node then return end

	local struct_name = struct_identifiers[ts_node:type()]

	if struct_name then return { name = struct_name, node = ts_node } end

	return _get_supported_struct_node_data(ts_node:parent(), struct_identifiers)
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

function Codedocs.extract_item_data(lang_name, struct_name)
	vim.treesitter.get_parser(0):parse()
	local node_at_cursor = vim.treesitter.get_node()

	local struct_data = _get_supported_struct_node_data(node_at_cursor, Codedocs.get_struct_identifiers(lang_name))

	local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1

	if not struct_data then return {}, struct_name or "comment", cursor_row end

	if struct_name and struct_data.name ~= struct_name then return {}, struct_name, cursor_row end

	local lang_config = require("codedocs.config").languages[lang_name]

	local struct_pos = struct_data.node:range()

	local item_extractors = lang_config.structures[struct_data.name].extractors
	local items_data = require "codedocs.item_extractor"(
		lang_name,
		struct_data.node,
		item_extractors,
		lang_config.structures[struct_data.name].opts
	)

	Debug_logger.log("Item data: ", items_data)
	return items_data, struct_data.name, struct_pos
end

function Codedocs.orchestrate_annotation_build(lang_data)
	local items_data, struct_name, annotation_row = Codedocs.extract_item_data(lang_data.name, lang_data.substyle_name)

	local struct_style = Codedocs.get_struct_style(
		lang_data.name,
		lang_data.substyle_name or struct_name,
		lang_data.style_name or Codedocs.get_default_style(lang_data.name)
	)

	Debug_logger.log("Structure name: " .. struct_name)
	Debug_logger.log("Style name: " .. Codedocs.get_default_style(lang_data.name))
	Debug_logger.log("Style: ", struct_style)

	local struct_data = {
		should_indent = struct_style.indented,
		line_num = annotation_row + 1,
	}

	local annotation_lines = docs_builder(struct_style, items_data, struct_data)

	return annotation_lines, annotation_row, struct_style.relative_position
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
