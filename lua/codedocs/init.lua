local Logger = require "codedocs.utils.logger"
local Item_extractor = require "codedocs.item_extractor"

local Codedocs = {}

function Codedocs.build_annot_lines(blocks, opts, row, items)
	local annot = require("codedocs.annotation_builder").new(items, opts, row)
	local lines = annot:build(blocks)

	return lines
end

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

local function _determine_lang_name()
	if not Codedocs._filetypes_map then
		local langs_config = require("codedocs.config").opts.languages
		local filetypes_map = {}
		for lang_name, opts in pairs(langs_config) do
			for _, filetype_name in ipairs(opts.filetypes) do
				filetypes_map[filetype_name] = lang_name
			end
		end

		Codedocs._filetypes_map = filetypes_map
	end

	return Codedocs._filetypes_map[vim.bo.filetype]
end

function Codedocs.get_supported_langs() return vim.tbl_keys(require("codedocs.config").opts.languages) end

function Codedocs.get_annot_list()
	local lang = _determine_lang_name()
	local lang_stuff = require("codedocs.config").opts.languages[lang]
	local annot_names = vim.tbl_keys(lang_stuff.styles[lang_stuff.default_style].annots)
	return annot_names
end

---Returns an existing annotation table from the configuration table
---Equivalent to `require("codedocs.config").opts.languages[[lang_name]].styles[[style_name]].annots[[annotation_name]]
---@param lang_name string
---@param style_name string
---@param annot_name string
---@return CodedocsAnnotationStyleOpts annotation_tbl
function Codedocs.get_annot_tbl(lang_name, style_name, annot_name)
	vim.validate {
		lang_name = { lang_name, "string" },
		style_name = { style_name, "string" },
		annot_name = { annot_name, "string" },
	}

	local annot_tbl = require("codedocs.config").opts.languages[lang_name].styles[style_name].annots[annot_name]
	return annot_tbl
end

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

function Codedocs.prepare_annotation(lang_name, annot_data)
	local target_data = Codedocs.get_target_data(lang_name, annot_data)

	local lang_config = require("codedocs.config").opts.languages[lang_name]
	local style_name = annot_data and annot_data.style_name or lang_config.default_style

	local annot_tbl = Codedocs.get_annot_tbl(lang_name, style_name, target_data.target_name)

	local lines = Codedocs.build_annot_lines(
		annot_tbl.blocks,
		require("codedocs.config").opts.annot_builder,
		target_data.row,
		target_data.items
	)

	return {
		row = target_data.row,
		target_name = target_data.target_name,
		style_name = style_name,
		items = target_data.items,
		placement = annot_tbl.placement,
		lines = lines,
	}
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

	local lang_name = _determine_lang_name()
	Logger.info("Language: " .. lang_name)

	local annot = Codedocs.prepare_annotation(lang_name, annot_data)

	Logger.info("Annotation content" .. vim.inspect(annot.lines))

	if not vim.tbl_isempty(annot.lines) then
		_write_to_buffer(annot.lines, annot.row, annot.placement)
		Logger.info "Annotation inserted"
	end
end

return Codedocs
