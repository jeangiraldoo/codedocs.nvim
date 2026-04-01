local Debug_logger = require "codedocs.utils.debug_logger"
local docs_builder = require "codedocs.annotation_builder"
local LangSpecs = require "codedocs.lang_specs.init"

local Codedocs = {}
function Codedocs.get_supported_langs() return vim.tbl_keys(require("codedocs.config").languages) end

function Codedocs.get_struct_identifiers(lang_name)
	return require("codedocs.config").languages[lang_name].extraction.struct_identifiers
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

	if struct_name then return { name = struct_name, node = ts_node, pos = ts_node:range() } end

	return _get_supported_struct_node_data(ts_node:parent(), struct_identifiers)
end

---@class CodedocsLayoutOpt string[]

---@class CodedocsItemExtractionAttributesOpts
---@field static boolean
---@field instance "none" | "constructor" | "all"

---@class CodedocsItemExtractionOpts
---@field attributes CodedocsItemExtractionAttributesOpts

---@class CodedocsAnnotationSettings
---@field layout string[]
---@field section_order string[]
---@field indented boolean
---@field insert_at number
---@field relative_position "above" | "below" | "empty_target_or_above"
---@field item_extraction CodedocsItemExtractionOpts

---@class CodedocsItemBasedSectionOpts
---@field layout CodedocsLayoutOpt

---@class CodedocsAnnotationFuncSections
---@field parameters CodedocsItemExtractionOpts

---@class CodedocsAnnotationSectionOpts

---@class CodedocsFuncStyle
---@field settings? CodedocsAnnotationSettings
---@field sections? CodedocsAnnotationFuncSections

---@class StyleDefinition
---@field settings? CodedocsAnnotationSettings

---@class CodedocsLangStructures
---@field func? table<string, CodedocsFuncStyle>
---@field class? table<string, StyleDefinition>
---@field comment? table<string, StyleDefinition>

---@class CodedocsLangSpec
---@field default_style? string
---@field styles? CodedocsLangStructures

---@class CodedocsLangs
---@field lua CodedocsLuaSpec

---@class CodedocsConfig
---@field debug? boolean
---@field languages? CodedocsLangs

---@param user_config CodedocsConfig
function Codedocs.setup(user_config)
	local config = require "codedocs.config"
	local merged = vim.tbl_deep_extend("force", config, user_config)

	for k in pairs(config) do
		config[k] = nil
	end
	for k, v in pairs(merged) do
		config[k] = v
	end
end

function Codedocs.extract_item_data(lang_name)
	local lang_spec = LangSpecs.new(lang_name)

	vim.treesitter.get_parser(0):parse()
	local node_at_cursor = vim.treesitter.get_node()

	local struct_data = _get_supported_struct_node_data(node_at_cursor, Codedocs.get_struct_identifiers(lang_name))
		or { name = "comment" }

	if struct_data.name == "comment" then return {}, struct_data.name, vim.api.nvim_win_get_cursor(0)[1] - 1 end

	local struct_style = lang_spec:get_struct_style(struct_data.name, lang_spec:get_default_style())
	local item_extractor = require("codedocs.config").languages[lang_name].extraction.extractors[struct_data.name]
	local items_data = require "codedocs.item_extractor"(lang_name, struct_style, struct_data.node, item_extractor)

	Debug_logger.log("Item data: ", items_data)
	return items_data, struct_data.name, struct_data.pos
end

function Codedocs.orchestrate_annotation_build(lang_data)
	local lang_spec = LangSpecs.new(lang_data.name)

	local items_data, struct_name, row = Codedocs.extract_item_data(lang_data.name)
	local struct_style = lang_spec:get_struct_style(struct_name, lang_data.style_name or lang_spec:get_default_style())

	Debug_logger.log("Structure name: " .. struct_name)
	Debug_logger.log("Style name: " .. lang_spec:get_default_style())
	Debug_logger.log("Style: ", struct_style)

	local struct_data = {
		should_indent = struct_style.settings.indented,
		line_num = row + 1,
	}

	local annotation_lines = docs_builder(struct_style, items_data, struct_style.settings.layout, struct_data)

	return annotation_lines, row, struct_style.settings.relative_position
end

function Codedocs.insert_docs()
	Debug_logger.log "Plugin triggered"

	local lang_name = require("codedocs.config").aliases[vim.bo.filetype] or vim.bo.filetype
	Debug_logger.log("Language: " .. lang_name)

	if not vim.treesitter.get_parser(0, lang_name, { error = false }) then
		vim.notify("Tree-sitter parser for " .. lang_name .. " is not installed", vim.log.levels.ERROR)
		return
	end

	local annotation_lines, row, relative_position = Codedocs.orchestrate_annotation_build { name = lang_name }
	Debug_logger.log("Annotation:", annotation_lines)

	_write_to_buffer(annotation_lines, row, relative_position)
end

return Codedocs
