local Utils = require "codedocs.utils.general"

local Annot_builder = {}

Annot_builder.builder = require "codedocs.annotation_builder.builder"

function Annot_builder.build_annot_lines(blocks, opts, row, items)
	local annot = require("codedocs.annotation_builder").builder.new(items, opts, row)
	local lines = annot:build(blocks)

	return lines
end

function Annot_builder.get_annot_list()
	local lang = Utils._determine_lang_name()
	local lang_stuff = require("codedocs.config").opts.languages[lang]
	local annot_names = vim.tbl_keys(lang_stuff.styles[lang_stuff.default_style].annots)
	return annot_names
end

---Returns an existing annotation table from the configuration table
---Equivalent to `require("codedocs.config").opts.languages[[lang_name]].styles[[style_name]].annots[[annotation_name]]
---@param lang_name string
---@param style_name string
---@param annot_name string
---@return CodedocsAnnotationStyleOpts annotation_tbl
function Annot_builder.get_annot_tbl(lang_name, style_name, annot_name)
	vim.validate {
		lang_name = { lang_name, "string" },
		style_name = { style_name, "string" },
		annot_name = { annot_name, "string" },
	}

	local annot_tbl = require("codedocs.config").opts.languages[lang_name].styles[style_name].annots[annot_name]
	return annot_tbl
end

function Annot_builder.prepare_annotation(lang_name, annot_data, target_data)
	-- local target_data = Codedocs.get_target_data(lang_name, annot_data)

	local lang_config = require("codedocs.config").opts.languages[lang_name]
	local style_name = annot_data and annot_data.style_name or lang_config.default_style

	local annot_tbl = Annot_builder.get_annot_tbl(lang_name, style_name, target_data.target_name)

	local lines = Annot_builder.build_annot_lines(
		annot_tbl.blocks,
		require("codedocs.config").opts.annot_builder,
		target_data.row,
		target_data.items
	)

	return {
		row = target_data.row,
		target_name = target_data.target_name,
		style_name = style_name,
		items = target_data.items,
		placement = annot_tbl.placement,
		lines = lines,
	}
end

return Annot_builder
