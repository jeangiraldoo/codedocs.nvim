local builder = require("codedocs.docs_gen.init").builder
local parser = require("codedocs.node_parser.parser")
local extractor = require("codedocs.node_parser.struct_finder")
local node_constructor = require("codedocs.node_parser.custom_nodes.nodes").node_constructor
local spec_manager = require("codedocs.specs.manager.init")
local spec_customizer, spec_reader = spec_manager.customizer, spec_manager.reader

local M = {}

function M.setup(config)
	if config and config.default_styles then spec_customizer.set_default_lang_style(config.default_styles) end

	if config and config.styles then spec_customizer.update_style(config.styles) end
end

local function get_node_settings(style, opts, struct_name)
	local settings = {
		func = {
			params = {
				include_type = style.params and style.params[opts.item.include_type.val],
			},
			return_type = {
				include_type = style.return_type and style.return_type[opts.item.include_type.val],
			},
		},
		class = {
			attrs = {
				include_type = style.attrs and style.attrs[opts.item.include_type.val],
			},
			boolean_condition = {
				style.general[opts.class_general.include_class_body_attrs.val],
				style.general[opts.class_general.include_instance_attrs.val],
				style.general[opts.class_general.include_only_constructor_instance_attrs.val],
			},
		},
	}
	return settings[struct_name]
end

function M.insert_docs()
	local lang = vim.api.nvim_buf_get_option(0, "filetype")

	local struct_names = spec_reader.get_struct_names(lang)
	if not struct_names then return false end
	local struct_name, node = extractor.get_node_type(lang, struct_names)

	local struct_data = spec_reader.get_struct_style(lang, struct_name)
	if not struct_data then return false end
	local opts, style, identifier_pos = unpack(struct_data)

	local sections = style.general.section_order
	local parser_settings = get_node_settings(style, opts, struct_name)
	if struct_name ~= "comment" then
		parser_settings["identifier_pos"] = identifier_pos
		parser_settings["tree"] = spec_reader.get_struct_tree(lang, struct_name).get_tree(node_constructor)
	end
	local pos, data = parser.get_data(lang, node, sections, struct_name, parser_settings)
	local struct = style.general[opts.general.struct.val]

	local docs = (struct_name == "comment") and struct or builder.get_docs(opts, style, data, struct)
	local docs_data = {
		pos = pos,
		direction = style.general[opts.general.direction.val],
		title_pos = style.general[opts.general.title_pos.val],
	}
	require("codedocs.writer").start(docs, docs_data)
end

vim.api.nvim_set_keymap(
	"n",
	"<Plug>Codedocs",
	"<cmd>lua require('codedocs').insert_docs()<CR>",
	{ noremap = true, silent = true }
)
vim.api.nvim_create_user_command("Codedocs", M.insert_docs, {})

return M
