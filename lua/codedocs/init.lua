local Debug_logger = require("codedocs.utils.debug_logger")
local docs_builder = require("codedocs.annotation_builder")
local LangSpecs = require("codedocs.lang_specs.init")

local Codedocs = {}

local function _apply_plugin_settings(settings)
	if settings.debug == true then require("codedocs.utils.debug_logger").enable() end
end

function Codedocs.setup(config)
	if config.settings then _apply_plugin_settings(config.settings) end

	if config and config.default_styles then LangSpecs.set_default_lang_style(config.default_styles) end

	if config and config.styles then LangSpecs.update_style(config.styles) end
end

function Codedocs.extract_item_data(lang_name)
	local lang_spec = LangSpecs.new(lang_name)
	local struct_name, node = require("codedocs.struct_detector")(lang_spec:get_struct_identifiers())

	Debug_logger.log("Structure name: " .. struct_name)

	local items_data, pos
	if struct_name == "comment" then
		items_data, pos = {}, vim.api.nvim_win_get_cursor(0)[1] - 1
	else
		items_data, pos = lang_spec:get_struct_items(struct_name, node), node:range()
	end

	Debug_logger.log("Item data: ", items_data)
	return items_data, struct_name, pos
end

function Codedocs.orchestrate_annotation_build(lang_data)
	local lang_spec = LangSpecs.new(lang_data.name)

	local items_data, struct_name, pos = Codedocs.extract_item_data(lang_data.name)
	local struct_style = lang_spec:get_struct_style(struct_name, lang_data.style_name or lang_spec:get_default_style())

	Debug_logger.log("Structure name: " .. struct_name)
	Debug_logger.log("Style: ", struct_style)
	return docs_builder(struct_style, items_data, struct_style.settings.layout), pos, struct_style
end

function Codedocs.insert_docs()
	Debug_logger.log("Plugin triggered")

	local lang = LangSpecs.get_buffer_lang_name()
	Debug_logger.log("Language: " .. lang)

	if not vim.treesitter.get_parser(0, lang, { error = false }) then
		vim.notify("Tree-sitter parser for " .. lang .. " is not installed", vim.log.levels.ERROR)
		return
	end

	local docs, pos, struct_style = Codedocs.orchestrate_annotation_build({ name = lang })
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

return Codedocs
