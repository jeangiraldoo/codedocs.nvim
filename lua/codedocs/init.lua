local Logger = require "codedocs.utils.logger"
local Item_extractor = require "codedocs.item_extractor"

local Codedocs = {}

--- Inserts an annotation relative to a target and moves the cursor to the annotation title
---@param annotation_lines string[]
---@param row number 0-based annotation-related positions
---@param placement "above" | "below" | "current" Position relative to the target row
local function _write_to_buffer(annotation_lines, row, placement)
	vim.validate {
		annotation_lines = { annotation_lines, "table" },
		row = { row, "number" },
		placement = { placement, "string" },
	}

	Logger.info("Target row: " .. row)
	Logger.info("Placement: " .. placement)

	local should_insert_extra_line = ((placement == "current") and vim.api.nvim_get_current_line() ~= "")
		or placement == "above"
		or placement == "below"

	local final_row_pos = placement == "below" and row + 1 or row

	if should_insert_extra_line then vim.api.nvim_buf_set_lines(0, final_row_pos, final_row_pos, false, { "" }) end

	--- Lines are inserted at the cursor position
	vim.api.nvim_win_set_cursor(0, {
		final_row_pos + 1, -- expects 1-based row
		0,
	})
	local lines = table.concat(annotation_lines, "\n")
	vim.snippet.expand(lines)
end

function Codedocs.get_supported_langs() return vim.tbl_keys(require("codedocs.config").opts.languages) end

---@return string[] supported_styles List of style names
function Codedocs.get_supported_styles(lang_name)
	local supported_styles = vim.tbl_keys(require("codedocs.config").opts.languages[lang_name].styles)
	table.sort(supported_styles)
	return supported_styles
end

---@param user_config CodedocsConfig?
function Codedocs.setup(user_config)
	Logger.info "Setup called"
	Logger.debug("Setup options: " .. vim.inspect(user_config))

	local Config = require "codedocs.config"
	Config.setup(user_config)

	Logger.debug("Merged config options: " .. vim.inspect(Config.opts))
end

function Codedocs.get_target_data(lang_name, annotation_data)
	vim.validate {
		lang_name = { lang_name, "string" },
		annotation_data = { annotation_data, { "table", "nil" } },
	}

	local user_requested_specific_annotation = annotation_data and annotation_data.annot_name

	if user_requested_specific_annotation then
		return Item_extractor.get_requested_target_data(lang_name, annotation_data.annot_name) or {}
	end

	return Item_extractor.get_detected_target_data(lang_name) or {}
end

---@param annot_data { annot_name: string, style_name: string? }?
function Codedocs.generate(annot_data)
	Logger.info "Annotation generation started"

	vim.validate {
		annotation_data = { annot_data, { "table", "nil" } },
	}

	if annot_data then
		vim.validate {
			annot_name = { annot_data.annot_name, "string" },
			style_name = { annot_data.style_name, { "string", "nil" } },
		}

		Logger.info("Passed data: " .. vim.inspect(annot_data))
	end

	local lang_name = require("codedocs.utils.general")._determine_lang_name()
	Logger.info("Language: " .. lang_name)

	local target_data = Codedocs.get_target_data(lang_name, annot_data)
	local annot = require("codedocs.annotation_builder").prepare_annotation(lang_name, annot_data, target_data)

	Logger.info("Annotation content" .. vim.inspect(annot.lines))

	if not vim.tbl_isempty(annot.lines) then
		_write_to_buffer(annot.lines, annot.row, annot.placement)
		Logger.info "Annotation inserted"
	end
end

return Codedocs
