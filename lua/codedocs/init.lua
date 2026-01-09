local docs_builder = require("codedocs.docs_gen")
local Spec = require("codedocs.specs")
local get_struct_items, get_struct_info = unpack(require("codedocs.tree_processor"))

local M = {}

function M.setup(config)
	if config and config.default_styles then Spec.customizer.set_default_lang_style(config.default_styles) end

	if config and config.styles then Spec.customizer.update_style(config.styles) end
end

function M.insert_docs()
	local lang = vim.bo.filetype
	if not vim.treesitter.get_parser(0, lang, { error = false }) then
		vim.notify("Tree-sitter parser for " .. lang .. " is not installed", vim.log.levels.ERROR)
		return
	end

	local struct_names = Spec.reader:get_struct_names(lang)

	if not struct_names then return false end

	local struct_name, node = get_struct_info(struct_names)
	local style, opts, identifier_pos = Spec.reader:get_struct_data(lang, struct_name)

	local sections = style.general.section_order
	local pos, data = get_struct_items(node, sections, struct_name, style, opts, identifier_pos)
	local struct = style.general[opts.struct.val]

	local docs = (struct_name == "comment") and struct or docs_builder.get_docs(opts, style, data, struct)
	local docs_data = {
		pos = pos,
		direction = style.general[opts.direction.val],
		title_pos = style.general[opts.title_pos.val],
	}
	require("codedocs.writer").start(docs, docs_data)
end

return M
