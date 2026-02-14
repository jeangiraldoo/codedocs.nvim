local Debug_logger = require("codedocs.utils.debug_logger")
local docs_builder = require("codedocs.annotation_builder")
local LangSpecs = require("codedocs.lang_specs.init")

local M = {}

function M.setup(config)
	if config.settings then LangSpecs.set_settings(config.settings) end

	if config and config.default_styles then LangSpecs.set_default_lang_style(config.default_styles) end

	if config and config.styles then LangSpecs.update_style(config.styles) end
end

function M.insert_docs()
	Debug_logger.log("Plugin triggered")
	local lang = LangSpecs.get_buffer_lang_name()
	Debug_logger.log("Language: " .. lang)
	if not vim.treesitter.get_parser(0, lang, { error = false }) then
		vim.notify("Tree-sitter parser for " .. lang .. " is not installed", vim.log.levels.ERROR)
		return
	end

	local lang_spec = LangSpecs.new(lang)
	local struct_name, node = require("codedocs.struct_detector")(lang_spec:get_struct_identifiers())
	local struct_style = lang_spec:_get_struct_main_style(struct_name)

	Debug_logger.log("Structure name: " .. struct_name)
	Debug_logger.log("Style: ", struct_style)

	local items_data, pos
	if struct_name == "comment" then
		items_data, pos = {}, vim.api.nvim_win_get_cursor(0)[1] - 1
	else
		items_data, pos = lang_spec:get_struct_items(struct_name, node), node:range()
	end

	Debug_logger.log("Item data: ", items_data)

	local docs = docs_builder(struct_style, items_data, struct_style.settings.layout)
	Debug_logger.log("Annotation:", docs)

	require("codedocs.buf_writer")(
		docs,
		{ title_offset = struct_style.settings.insert_at, target = pos },
		struct_style.settings.relative_position,
		-- Languages where annotations appear below the structure definition require an extra indentation level
		struct_style.settings.relative_position
			== "below" --TODO: there should be an option to indent or not the annotation
	)
end

return M
