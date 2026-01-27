local Debug_logger = require("codedocs.utils.debug_logger")
local docs_builder = require("codedocs.annotation_builder")
local Spec = require("codedocs.specs")

local M = {}

function M.setup(config)
	if config.settings then Spec.set_settings(config.settings) end

	if config and config.default_styles then Spec.set_default_lang_style(config.default_styles) end

	if config and config.styles then Spec.update_style(config.styles) end
end

function M.insert_docs()
	Debug_logger.log("Plugin triggered")
	local lang = vim.bo.filetype
	if not vim.treesitter.get_parser(0, lang, { error = false }) then
		vim.notify("Tree-sitter parser for " .. lang .. " is not installed", vim.log.levels.ERROR)
		return
	end

	local struct_name, node = require("codedocs.struct_detector")(Spec.get_struct_identifiers(lang))

	local items_data, style, pos = require("codedocs.specs.tree_processor")(lang, struct_name, node)
	Debug_logger.log("Structure name: " .. struct_name)
	Debug_logger.log("Item data: ", items_data)
	Debug_logger.log("Style: ", style)

	local layout = style.general.layout

	local docs = (struct_name == "comment") and layout or docs_builder(style, items_data, layout)
	Debug_logger.log("Annotation:", docs)

	local cursor_pos = style.general.insert_at + (style.title.cursor_pos - 1)
	require("codedocs.buf_writer")(docs, pos, style.general.direction, cursor_pos)
end

return M
