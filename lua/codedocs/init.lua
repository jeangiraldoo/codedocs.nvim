local Logger = require "codedocs.utils.logger"

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

local function _determine_lang_name()
	if not Codedocs._filetypes_map then
		local langs_config = require("codedocs.config").languages
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

function Codedocs.get_supported_langs() return vim.tbl_keys(require("codedocs.config").languages) end

function Codedocs.get_annotation_list()
	local lang = _determine_lang_name()
	local lang_stuff = require("codedocs.config").languages[lang]
	local annotation_names = vim.tbl_keys(lang_stuff.styles[lang_stuff.default_style].annots)
	return annotation_names
end

---Returns an existing annotation table from the configuration table
---Equivalent to `require("codedocs.config").languages[[lang_name]].styles[[style_name]].annots[[annotation_name]]
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

	local annotation_tbl = require("codedocs.config").languages[lang_name].styles[style_name].annots[annotation_name]
	return annotation_tbl
end

---@return string[] supported_styles List of style names
function Codedocs.get_supported_styles(lang_name)
	local supported_styles = vim.tbl_keys(require("codedocs.config").languages[lang_name].styles)
	table.sort(supported_styles)
	return supported_styles
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

local function validate_config(config)
	vim.validate {
		["config.logging"] = { config.logging, "table" },
	}
	vim.validate {
		["config.logging.path"] = { config.logging.path, "string" },
	}
	vim.validate {
		["config.logging.level"] = { config.logging.level, "number" },
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

		for style_name, style_opts in pairs(opts.styles) do
			for annotation_name, annotation_opts in pairs(style_opts.annots) do
				local annotation_path = lang_path .. (".styles.%s.%s"):format(style_name, annotation_name)

				vim.validate {
					[annotation_path] = {
						annotation_opts,
						"table",
					},
				}
				vim.validate {
					[annotation_path .. ".placement"] = {
						annotation_opts.placement or annotation_opts.relative_position,
						"string",
					},
				}

				for idx, block in ipairs(annotation_opts.blocks) do
					local block_idx_path = annotation_path .. ".blocks(" .. idx .. ")"
					vim.validate {
						[block_idx_path] = { block, "table" },
					}

					vim.validate {
						[block_idx_path .. ".name"] = { block.name, "string" },
					}

					vim.validate {
						[block_idx_path .. ".layout"] = { block.layout, "table" },
					}
					vim.validate {
						[block_idx_path .. ".insert_gap_between"] = { block.insert_gap_between, "table" },
					}
					vim.validate {
						[block_idx_path .. ".insert_gap_between.before"] = {
							block.insert_gap_between.before,
							"table",
						},
					}
					vim.validate {
						[block_idx_path .. ".insert_gap_between.text"] = { block.insert_gap_between.text, "string" },
					}

					if block.items then
						vim.validate {
							[block_idx_path .. " .items"] = { block.items, "table" },
						}

						vim.validate {
							[block_idx_path .. ".items.layout"] = { block.items.layout, "table" },
						}
						vim.validate {
							[block_idx_path .. ".items.insert_gap_between"] = {
								block.items.insert_gap_between,
								"table",
							},
						}
						vim.validate {
							[block_idx_path .. ".items.insert_gap_between.enabled"] = {
								block.items.insert_gap_between.enabled,
								"boolean",
							},
						}
						vim.validate {
							[block_idx_path .. ".items.insert_gap_between.text"] = {
								block.items.insert_gap_between.text,
								"string",
							},
						}
					end
				end
			end
		end
	end
end

---@param user_config CodedocsConfig?
function Codedocs.setup(user_config)
	Logger.info "Setup called"
	Logger.debug("Setup options: " .. vim.inspect(user_config))

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
	Logger.debug("Merged config options: " .. vim.inspect(merged))
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

function Codedocs.get_requested_annotation_data(lang_name, requested_name)
	local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1

	local lang_config = require("codedocs.config").languages[lang_name]

	--- Returned when no annotation targets are available, or when using
	--- Treesitter and no matching node is found under the cursor.
	local EMPTY_TARGET_RESULT = {
		items = {},
		target_name = requested_name,
		row = cursor_row,
	}

	if not lang_config.targets[requested_name] then return EMPTY_TARGET_RESULT end

	local extractor = require "codedocs.item_extractor"

	local targets_config = require("codedocs.config").languages[lang_name].targets[requested_name]

	if not targets_config.node_identifiers or vim.tbl_isempty(targets_config.node_identifiers) then
		local data = extractor.finish({}, targets_config)

		return {
			row = data.row,
			items = data.items,
			target_name = requested_name,
		}
	end

	if not vim.treesitter.get_parser(0, lang_name, { error = false }) then
		local error_msg = "Tree-sitter parser for " .. lang_name .. " is not installed"

		vim.notify(error_msg, vim.log.levels.ERROR)
		Logger.error(error_msg)
		return
	end

	vim.treesitter.get_parser(0):parse()
	local node_at_cursor = vim.treesitter.get_node()

	local ttarget_data = _get_supported_target_node_data(node_at_cursor, Codedocs.get_target_identifiers(lang_name))

	if not ttarget_data then return EMPTY_TARGET_RESULT end

	local target_data = extractor.finish(ttarget_data, targets_config)

	return {
		-- Ignore extracted items if cursor target differs
		items = (target_data and target_data.target_name == requested_name) and target_data.items or {},
		target_name = requested_name,
		row = target_data.row,
	}
end

function Codedocs.get_detected_annotation_data(lang_name)
	local extractor = require "codedocs.item_extractor"

	if not vim.treesitter.get_parser(0, lang_name, { error = false }) then
		local error_msg = "Tree-sitter parser for " .. lang_name .. " is not installed"

		vim.notify(error_msg, vim.log.levels.ERROR)
		Logger.error(error_msg)
		return
	end

	vim.treesitter.get_parser(0):parse()
	local node_at_cursor = vim.treesitter.get_node()

	local ttarget_data = _get_supported_target_node_data(node_at_cursor, Codedocs.get_target_identifiers(lang_name))

	local lang_config = require("codedocs.config").languages[lang_name]

	if not ttarget_data then
		return Codedocs.get_requested_annotation_data(
			lang_name,
			lang_config.styles[lang_config.default_style].default_annot
		)
	end

	local targets_config = lang_config.targets[ttarget_data.name]
	local target_data = extractor.finish(ttarget_data, targets_config)

	if not target_data then return end

	return {
		items = target_data.items,
		target_name = target_data.target_name,
		row = target_data.row,
	}
end

---@param lang_name string
---@param data { target_name: string, style_name: string, row: number, items: table }?
---@return { lines: string[], placement: string }?
function Codedocs.build_annotation(lang_name, data)
	vim.validate {
		lang_name = { lang_name, "string" },
		data = { data, "table" },
	}

	local annotation_tbl = Codedocs.get_annotation_tbl(lang_name, data.style_name, data.target_name)
	local opts = require("codedocs.config").annotation_builder

	local Annotation = require "codedocs.annotation_builder"
	local annotation = Annotation.new(data.row + 1, opts)

	annotation:insert_blocks(annotation_tbl.blocks, data.items)

	local lines = annotation:get_lines()

	Logger.info("Annotation content" .. vim.inspect(lines))

	return {
		lines = lines,
		placement = annotation_tbl.placement or annotation_tbl.relative_position,
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
		annot_data = Codedocs.get_requested_annotation_data(lang_name, annotation_data.annotation_name) or {}
		annot_data.style_name = annotation_data.style_name or lang_config.default_style
	else
		annot_data = Codedocs.get_detected_annotation_data(lang_name) or {}
		annot_data.style_name = lang_config.default_style
	end

	return annot_data
end

---@param annotation_data { annotation_name: string, style_name: string? }?
function Codedocs.generate(annotation_data)
	Logger.info "Annotation generation started"

	vim.validate {
		annotation_data = { annotation_data, { "table", "nil" } },
	}

	if annotation_data then
		vim.validate {
			annotation_name = { annotation_data.annotation_name, "string" },
			style_name = { annotation_data.style_name, { "string", "nil" } },
		}

		Logger.info("Passed data: " .. vim.inspect(annotation_data))
	end

	local lang_name = _determine_lang_name()
	Logger.info("Language: " .. lang_name)

	local annot_data = Codedocs.get_annotation_data(lang_name, annotation_data)

	Logger.info("Annotation used: " .. annot_data.target_name)
	Logger.info("Detected items: " .. vim.inspect(annot_data.items))

	local annotation_result = Codedocs.build_annotation(lang_name, annot_data)

	if annotation_result and not vim.tbl_isempty(annotation_result.lines) then
		_write_to_buffer(annotation_result.lines, annot_data.row, annotation_result.placement)
		Logger.info "Annotation inserted"
	end
end

return Codedocs
