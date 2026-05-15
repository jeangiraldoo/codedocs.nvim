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

local function validate_config(config)
	vim.validate {
		["config.debug"] = { config.debug, "boolean" },
	}
	vim.validate {
		["config.aliases"] = { config.aliases, "table" },
	}
	vim.validate {
		["config.languages"] = { config.languages, "table" },
	}

	for lang_name, opts in pairs(config.languages) do
		local lang_path = ("config.languages.%s"):format(lang_name)
		vim.validate {
			[lang_path] = { opts, "table" },
		}

		vim.validate {
			[lang_path .. ".default_style"] = { opts.default_style, "string" },
		}
		vim.validate {
			[lang_path .. ".styles"] = { opts.styles, "table" },
		}
		vim.validate {
			[lang_path .. ".targets"] = { opts.targets, "table" },
		}

		for style_name, annotations in pairs(opts.styles) do
			for annotation_name, annotation_opts in pairs(annotations) do
				local annotation_path = lang_path .. (".styles.%s.%s"):format(style_name, annotation_name)

				vim.validate {
					[annotation_path] = {
						annotation_opts,
						"table",
					},
				}
				vim.validate {
					[annotation_path .. ".relative_position"] = {
						annotation_opts.relative_position,
						"string",
					},
				}
				local function validate_block(block, block_idx_path)
					vim.validate {
						[block_idx_path .. ".layout"] = { block.layout, "table" },
					}
					vim.validate {
						[block_idx_path .. ".insert_gap_between"] = { block.insert_gap_between, "table" },
					}
					vim.validate {
						[block_idx_path .. ".insert_gap_between.enabled"] = {
							block.insert_gap_between.enabled,
							"boolean",
						},
					}
					vim.validate {
						[block_idx_path .. ".insert_gap_between.text"] = { block.insert_gap_between.text, "string" },
					}
				end

				for idx, block in ipairs(annotation_opts.blocks) do
					local block_idx_path = annotation_path .. ".blocks(" .. idx .. ")"
					vim.validate {
						[block_idx_path] = { block, "table" },
					}

					vim.validate {
						[block_idx_path .. ".name"] = { block.name, "string" },
					}

					validate_block(block, block_idx_path)

					if block.items then
						vim.validate {
							[block_idx_path .. " .items"] = { block.items, "table" },
						}
						validate_block(block.items, block_idx_path .. " .items")
					end
				end
			end
		end
	end
end

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

	validate_config(merged)
end

local function get_requested_annotation_data(lang_name, requested_name)
	local items = {}
	local row = vim.api.nvim_win_get_cursor(0)[1] - 1

	local lang_config = require("codedocs.config").languages[lang_name]
	local extractor = require "codedocs.item_extractor"

	-- Existing target: attempt extraction
	if lang_config.targets[requested_name] then
		local target_data = extractor.extract(lang_name)

		if target_data then
			row = target_data.row

			-- Ignore extracted items if cursor target differs
			if target_data.target_name == requested_name then items = target_data.items end
		end
	end

	return {
		items = items,
		target_name = requested_name,
		row = row,
	}
end

local function get_detected_annotation_data(lang_name)
	local extractor = require "codedocs.item_extractor"

	-- Auto-detect annotation from cursor
	local target_data = extractor.extract(lang_name)
	if not target_data then return end

	return {
		items = target_data.items,
		target_name = target_data.target_name,
		row = target_data.row,
	}
end

---@param lang_name string
---@param data { target_name: string, style_name: string, row: number, items: table }?
---@return { lines: string[], relative_position: string }?
function Codedocs.build_annotation(lang_name, data)
	vim.validate {
		lang_name = { lang_name, "string" },
		data = { data, "table" },
	}

	local annotation_tbl = Codedocs.get_annotation_tbl(lang_name, data.style_name, data.target_name)

	local Annotation = require "codedocs.annotation_builder"
	local annotation = Annotation.new(data.row + 1)

	annotation:insert_blocks(annotation_tbl.blocks, data.items)

	local lines = annotation:get_lines()

	Debug_logger.log("Annotation content", lines)

	return {
		lines = lines,
		relative_position = annotation_tbl.relative_position,
	}
end

function Codedocs.get_annotation_data(lang_name, annotation_data)
	vim.validate {
		lang_name = { lang_name, "string" },
		annotation_data = { annotation_data, { "table", "nil" } },
	}

	local lang_config = require("codedocs.config").languages[lang_name]
	local user_requested_specific_annotation = annotation_data and annotation_data.annotation_name

	local annot_data
	if user_requested_specific_annotation then
		annot_data = get_requested_annotation_data(lang_name, annotation_data.annotation_name)
		annot_data.style_name = annotation_data.style_name or lang_config.default_style
	else
		annot_data = get_detected_annotation_data(lang_name)
		annot_data.style_name = lang_config.default_style
	end

	return annot_data
end

---@param annotation_data { annotation_name: string, style_name: string? }?
function Codedocs.generate(annotation_data)
	vim.validate {
		annotation_data = { annotation_data, { "table", "nil" } },
	}

	if annotation_data then
		vim.validate {
			annotation_name = { annotation_data.annotation_name, "string" },
			style_name = { annotation_data.style_name, { "string", "nil" } },
		}
	end

	local lang_name = _determine_lang_name()
	Debug_logger.log("Language: " .. lang_name)

	local annot_data = Codedocs.get_annotation_data(lang_name, annotation_data)

	local annotation_result = Codedocs.build_annotation(lang_name, annot_data)

	if annotation_result and not vim.tbl_isempty(annotation_result.lines) then
		_write_to_buffer(annotation_result.lines, annot_data.row, annotation_result.relative_position)
	end
end

return Codedocs
