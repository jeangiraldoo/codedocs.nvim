local Debug_logger = require "codedocs.utils.debug_logger"

local Codedocs = {}

--- Inserts an annotation relative to a target and moves the cursor to the annotation title
---@param annotation_lines string[]
---@param row number 0-based annotation-related positions
---@param relative_position "above" | "below" | "empty_target_or_above" Position relative to the target row
local function _write_to_buffer(annotation_lines, row, relative_position)
	vim.validate {
		annotation_lines = { annotation_lines, "table" },
		row = { row, "number" },
		relative_position = { relative_position, "string" },
	}

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

local function _determine_lang_name()
	local filetype = vim.bo.filetype
	return require("codedocs.config").aliases[filetype] or filetype
end

function Codedocs.get_supported_langs() return vim.tbl_keys(require("codedocs.config").languages) end

function Codedocs.get_annotation_list()
	local lang = _determine_lang_name()
	local lang_stuff = require("codedocs.config").languages[lang]
	local annotation_names = vim.tbl_keys(lang_stuff.styles[lang_stuff.default_style])
	return annotation_names
end

---Returns an existing annotation table from the configuration table
---Equivalent to `require("codedocs.config").languages[[lang_name]].styles[[style_name]][[annotation_name]]
---@param lang_name string
---@param style_name string
---@param annotation_name string
---@return CodedocsAnnotationStyleOpts annotation_tbl
function Codedocs.get_annotation_tbl(lang_name, style_name, annotation_name)
	vim.validate {
		lang_name = { lang_name, "string" },
		style_name = { style_name, "string" },
		annotation_name = { annotation_name, "string" },
	}

	local annotation_tbl = require("codedocs.config").languages[lang_name].styles[style_name][annotation_name]
	return annotation_tbl
end

---@return string[] supported_styles List of style names
function Codedocs.get_supported_styles(lang_name)
	local supported_styles = vim.tbl_keys(require("codedocs.config").languages[lang_name].styles)
	table.sort(supported_styles)
	return supported_styles
end

Codedocs.get_target_identifiers = require("codedocs.item_extractor").get_target_identifiers

---@param user_config CodedocsConfig?
function Codedocs.setup(user_config)
	vim.validate {
		user_config = { user_config, "table" },
	}

	if not user_config then return end

	local config = require "codedocs.config"
	local merged = vim.tbl_deep_extend("force", config, user_config)

	for k in pairs(config) do
		config[k] = nil
	end
	for k, v in pairs(merged) do
		config[k] = v
	end
end

---@param lang_name string
---@param annotation_data {annotation_name: string, style_name: string?}?
---@return { lines: string[], row: number, relative_position: string} | nil
function Codedocs.build_annotation(lang_name, annotation_data)
	vim.validate {
		lang_name = { lang_name, "string" },
		annotation_data = { annotation_data, { "table", "nil" } },
	}

	local lang_config = require("codedocs.config").languages[lang_name]

	local style_name = lang_config.default_style

	local items, target_name, annotation_row
	if annotation_data and annotation_data.annotation_name then
		target_name = annotation_data.annotation_name

		--If a specific annotation is requested, the style where it is contained can be specified
		style_name = annotation_data.style_name or style_name

		local target_exists = lang_config.targets[target_name]
		if target_exists then
			local item_extractor = require "codedocs.item_extractor"
			local target_under_cursor
			items, target_under_cursor, annotation_row = item_extractor.extract(lang_name)

			--- If a specific annotation is requested but the detected target is a different,
			--- ignore target-specific items and generate the requested annotation with no items
			if target_under_cursor ~= target_name then items = {} end
		else
			items, annotation_row = {}, vim.api.nvim_win_get_cursor(0)[1] - 1
		end
	else
		local item_extractor = require "codedocs.item_extractor"
		items, target_name, annotation_row = item_extractor.extract(lang_name)
	end

	local annotation_exists = lang_config.styles[lang_config.default_style][target_name] ~= nil
	if not annotation_exists then
		vim.notify("No annotation is called " .. target_name, vim.log.levels.ERROR)
		return
	end

	local annotation_tbl = Codedocs.get_annotation_tbl(lang_name, style_name, target_name)
	local target_data = {
		should_indent = annotation_tbl.indented,
		line_num = annotation_row + 1,
	}

	local annotation_lines = require "codedocs.annotation_builder"(annotation_tbl, items, target_data)
	return { lines = annotation_lines, row = annotation_row, relative_position = annotation_tbl.relative_position }
end

---@param annotation_data { annotation_name: string, style_name: string? }?
function Codedocs.generate(annotation_data)
	vim.validate {
		annotation_data = { annotation_data, { "table", "nil" } },
	}

	-- if annotation_data then vim.validate {
	-- 	annotation_name = { annotation_data.annotation_name, "string" },
	-- } end

	local lang_name = _determine_lang_name()
	Debug_logger.log("Language: " .. lang_name)

	if not vim.treesitter.get_parser(0, lang_name, { error = false }) then
		vim.notify("Tree-sitter parser for " .. lang_name .. " is not installed", vim.log.levels.ERROR)
		return
	end

	local annotation_result = Codedocs.build_annotation(lang_name, annotation_data)
	if annotation_result and not vim.tbl_isempty(annotation_result.lines) then
		_write_to_buffer(annotation_result.lines, annotation_result.row, annotation_result.relative_position)
	end
end

return Codedocs
