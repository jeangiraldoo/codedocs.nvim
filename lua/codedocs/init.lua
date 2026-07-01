local Logger = require "codedocs.utils.logger"
local Item_extractor = require "codedocs.item_extractor"

local Codedocs = {}

local function _get_line_indent(row)
	local cols = vim.fn.indent(row + 1)
	if cols == -1 then return "" end

	if vim.bo.expandtab then return string.rep(" ", cols) end

	local tabstop = vim.bo.tabstop
	local tabs = math.floor(cols / tabstop)
	local spaces = cols % tabstop

	return string.rep("\t", tabs) .. string.rep(" ", spaces)
end

function Codedocs.build_annot_lines(blocks, opts, row, items)
	local state = {
		placeholders = {
			general = {},
			items = {},
		},
		lines = {},
	}

	local new_state = vim.tbl_deep_extend("force", state, vim.deepcopy(opts))

	new_state.placeholders.items =
		vim.tbl_deep_extend("force", new_state.placeholders.items, vim.deepcopy(new_state.placeholders.general))

	local line_indent = _get_line_indent(row)

	local function insert(line, item)
		if line == "" then
			table.insert(new_state.lines, line)
			return
		end

		line = line_indent .. line

		local placeholders = item and new_state.placeholders.items or new_state.placeholders.general

		for placeholder, handler in pairs(placeholders) do
			line = line:gsub(placeholder, function() return handler(new_state.state, item) end)
		end

		table.insert(new_state.lines, line)
	end

	local function new_block(block_opts, block_items)
		for _, layout_line in ipairs(block_opts.layout) do
			insert(layout_line)
		end

		if not block_items then return end

		for item_idx, item in ipairs(block_items) do
			for _, line in ipairs(block_opts.items.layout) do
				insert(line, item)

				local is_last_item = block_items[item_idx + 1] == nil
				if block_opts.items.insert_gap_between.enabled and not is_last_item then
					insert(block_opts.items.insert_gap_between.text, item)
				end
			end
		end
	end

	local gap_data

	for _, block in ipairs(blocks) do
		local is_item_based_block = type(block.items) == "table"

		local block_items = {}
		for _, items_name_to_use in ipairs(block.item_names) do
			if items[items_name_to_use] then vim.list_extend(block_items, items[items_name_to_use]) end
		end

		local at_least_one_block_item = block_items and #block_items > 0 and #block.items.layout > 0

		if not is_item_based_block or at_least_one_block_item then
			if gap_data and gap_data[block.name] and gap_data[block.name].enabled then
				insert(gap_data[block.name].text)
			end

			new_block(block, block_items)
			gap_data = block.gap_before
		end
	end

	return new_state.lines
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

Codedocs.get_target_identifiers = Item_extractor.get_target_identifiers

---@param user_config CodedocsConfig?
function Codedocs.setup(user_config)
	Logger.info "Setup called"
	Logger.debug("Setup options: " .. vim.inspect(user_config))

	local Config = require "codedocs.config"
	Config.setup(user_config)

	Logger.debug("Merged config options: " .. vim.inspect(Config.opts))
end

Codedocs.get_requested_target_data = Item_extractor.get_requested_target_data
Codedocs.get_detected_target_data = Item_extractor.get_detected_target_data

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
