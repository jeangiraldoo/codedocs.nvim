local Debug_logger = require("codedocs.utils.debug_logger")
local docs_builder = require("codedocs.annotation_builder")
local Spec = require("codedocs.specs")
local Processor = require("codedocs.tree_processor")

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

	local struct_names = Spec.reader:get_struct_names(lang)

	if not struct_names then return false end

	local struct_name, node = Processor:determine_struc_under_cursor(struct_names)
	Debug_logger.log("Structure name: " .. struct_name)

	local style, opts, identifier_pos = Spec.reader:get_struct_data(lang, struct_name)
	Debug_logger.log("Style:", style)

	local pos, data = Processor:item_parser(node, style.general.section_order, struct_name, style, opts, identifier_pos)
	Debug_logger.log("Items:", data)

	local struct = style.general[opts.struct.val]

	local docs = (struct_name == "comment") and struct or docs_builder(style, data, struct)
	Debug_logger.log("Annotation:", docs)

	require("codedocs.buf_writer")(docs, pos, style.general[opts.direction.val], style.general[opts.title_pos.val])
end

return M
