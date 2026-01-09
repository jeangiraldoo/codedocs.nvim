local docs_builder = require("codedocs.docs_gen")
local Spec = require("codedocs.specs")
local get_struct_items, get_struct_info, node_constructor = unpack(require("codedocs.tree_processor"))

local M = {}

function M.setup(config)
	if config and config.default_styles then Spec.customizer.set_default_lang_style(config.default_styles) end

	if config and config.styles then Spec.customizer.update_style(config.styles) end
end

local function get_node_settings(style, opts, struct_name)
	local settings = {
		func = {
			params = {
				include_type = style.params and style.params[opts.include_type.val],
			},
			return_type = {
				include_type = style.return_type and style.return_type[opts.include_type.val],
			},
		},
		class = {
			attrs = {
				include_type = style.attrs and style.attrs[opts.include_type.val],
			},
			boolean_condition = {
				style.general[opts.include_class_body_attrs.val],
				style.general[opts.include_instance_attrs.val],
				style.general[opts.include_only_constructor_instance_attrs.val],
			},
		},
	}
	return settings[struct_name]
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
	local parser_settings = get_node_settings(style, opts, struct_name)
	if struct_name ~= "comment" then
		parser_settings["identifier_pos"] = identifier_pos
		parser_settings["tree"] = Spec.reader:get_struct_tree(lang, struct_name).get_tree(node_constructor)
	end
	local pos, data = get_struct_items(node, sections, struct_name, parser_settings)
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
