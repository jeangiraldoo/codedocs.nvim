local M = {}
local docs_gen = require("codedocs.docs_gen.init")
local Styles_manager = docs_gen.style_manager

function M.setup(config)
	if config and config.default_styles then
		Styles_manager.set_default_lang_style(config.default_styles)
	end

	if config and config.styles then
		Styles_manager.update_style(config.styles)
	end
end

local function get_node_settings(style, opts, struct_name)
	local settings = {
		func = {
			params = {
				include_type = (style.params) and style.params[opts.item.include_type.val]
			},
			return_type = {
				include_type = (style.return_type) and style.return_type[opts.item.include_type.val]
			}
		},
		class = {
			attrs = {
				include_type = (style.attrs) and style.attrs[opts.item.include_type.val]
			},
			boolean_condition = {
				style.general[opts.class_general.include_class_body_attrs.val],
				style.general[opts.class_general.include_instance_attrs.val],
				style.general[opts.class_general.include_only_constructor_instance_attrs.val]
			}
		}
	}
	return settings[struct_name]
end

function M.insert_docs()
	local lang = vim.api.nvim_buf_get_option(0, "filetype")

	local builder = docs_gen.builder
	local parser = require("codedocs.node_parser.parser")
	local extractor = require("codedocs.node_parser.struct_finder")

	local struct_name, node = extractor.get_node_type(lang)
	local opts, style = Styles_manager.get_lang_data(lang, struct_name)
	require("codedocs.docs_gen.styles.validations").validate_style(opts, style, struct_name)
	local sections = style.general.section_order
	local parser_settings = get_node_settings(style, opts, struct_name)
	local pos, data = parser.get_data(lang, node, sections, struct_name, parser_settings)
	local struct = style.general[opts.general.struct.val]

	local docs = (struct_name == "comment") and struct or builder.get_docs(opts, style, data, struct)
	local docs_data = {
		pos = pos,
		direction = style.general[opts.general.direction.val],
		title_pos = style.general[opts.general.title_pos.val]
	}
	require("codedocs.writer").start(docs, docs_data)
end

vim.api.nvim_set_keymap('n', "<Plug>Codedocs", "<cmd>lua require('codedocs').insert_docs()<CR>", { noremap = true, silent = true })
vim.api.nvim_create_user_command("Codedocs", M.insert_docs, {})

return M
