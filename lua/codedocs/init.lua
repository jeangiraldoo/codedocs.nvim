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
	local lang = Spec.get_buffer_lang_name()
	Debug_logger.log("Language: " .. lang)
	if not vim.treesitter.get_parser(0, lang, { error = false }) then
		vim.notify("Tree-sitter parser for " .. lang .. " is not installed", vim.log.levels.ERROR)
		return
	end

	local struct_name, node = require("codedocs.struct_detector")(Spec.get_struct_identifiers(lang))
	local struct_style = Spec:_get_struct_main_style(lang, struct_name)
	local layout = struct_style.general.layout
	local cursor_pos = struct_style.general.insert_at + (struct_style.title.cursor_pos - 1)

	local target_positions = {
		title_offset = cursor_pos,
	}

	Debug_logger.log("Structure name: " .. struct_name)
	Debug_logger.log("Style: ", struct_style)
	if struct_name == "comment" then
		target_positions.annotation_row = vim.api.nvim_win_get_cursor(0)[1] - 1

		require("codedocs.buf_writer")(
			layout,
			target_positions,
			-- Languages where annotations appear below the structure definition require an extra indentation level
			not struct_style.general.direction
		)
		return
	end

	local struct_tree = Spec.get_struct_tree(lang, struct_name)
	local items_data, pos = Spec.process_tree(lang, struct_style, struct_tree, node)
	Debug_logger.log("Item data: ", items_data)

	local docs = docs_builder(struct_style, items_data, layout)
	Debug_logger.log("Annotation:", docs)

	target_positions.annotation_row = struct_style.general.direction and pos or pos + 1

	require("codedocs.buf_writer")(
		docs,
		target_positions,
		-- Languages where annotations appear below the structure definition require an extra indentation level
		not struct_style.general.direction --TODO: there should be an option to indent or not the annotation
	)
end

return M
