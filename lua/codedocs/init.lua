local Debug_logger = require("codedocs.utils.debug_logger")
local docs_builder = require("codedocs.annotation_builder")
local Spec = require("codedocs.specs")

local M = {}

function M.setup(config)
	if config.settings then Spec.customizer.set_settings(config.settings) end

	if config and config.default_styles then Spec.customizer:set_default_lang_style(config.default_styles) end

	if config and config.styles then Spec.customizer:update_style(config.styles) end
end

function M.insert_docs()
	Debug_logger.log("Plugin triggered")
	local lang = vim.bo.filetype
	if not vim.treesitter.get_parser(0, lang, { error = false }) then
		vim.notify("Tree-sitter parser for " .. lang .. " is not installed", vim.log.levels.ERROR)
		return
	end

	local struct_name, items_data, style, pos, opts = require("codedocs.specs.tree_processor")(lang)
	Debug_logger.log("Structure name: " .. struct_name)
	Debug_logger.log("Item data: ", items_data)
	Debug_logger.log("Style: ", style)

	local struct = style.general[opts.struct.val]

	local docs = (struct_name == "comment") and struct or docs_builder(style, items_data, struct)
	Debug_logger.log("Annotation:", docs)

	require("codedocs.buf_writer")(docs, pos, style.general[opts.direction.val], style.general[opts.title_pos.val])
end

return M
