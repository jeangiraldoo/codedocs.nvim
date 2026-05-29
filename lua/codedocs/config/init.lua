local dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")

---@alias CodedocsSupportedLanguages
---| "lua"
---| "python"
---| "javascript"
---| "typescript"
---| "go"
---| "rust"
---| "c"
---| "cpp"
---| "java"
---| "kotlin"
---| "php"
---| "ruby"
---| "bash"

---@class CodedocsLanguagesConfigs
---@field bash CodedocsBashConfig
---@field c CodedocsCConfig
---@field cpp CodedocsCPPConfig
---@field go CodedocsGoConfig
---@field java CodedocsJavaConfig
---@field kotlin CodedocsKotlinConfig
---@field javascript CodedocsJSConfig
---@field lua CodedocsLuaConfig
---@field php CodedocsPHPConfig
---@field python CodedocsPythonConfig
---@field ruby CodedocsRubyConfig
---@field rust CodedocsRustConfig
---@field typescript CodedocsTSConfig

---@class CodedocsSectionOpts {
---@field name "" | string,
---@field layout string[],
---@field insert_gap_between {
---        enabled: boolean,
---        text: "" | string },
---@field items {
---        layout: string[],
---        insert_gap_between: {
---            enabled: boolean,
---            text: "" | string }}?} Section

---@class CodedocsAnnotationStyleOpts
---@field sections CodedocsSectionOpts[]
---@field placement "above" | "below" | "current"

---@class CodedocsLanguageConfig
---@field default_style string? Default style name
---@field styles table<string, table<string, CodedocsAnnotationStyleOpts>>

---@class CodedocsConfig
---@field debug boolean? Wether or not to enable debug mode
---@field aliases table<string, CodedocsSupportedLanguages>? Aliases for filetypes -> supported languages
---@field languages CodedocsLanguagesConfigs? Languages configuration

---@param lang_name string
---@param subdir_name string
---@return table<string, table>
local function _build_dir_tbl(lang_name, subdir_name)
	vim.validate {
		lang_name = { lang_name, "string" },
		subdir_name = { subdir_name, "string" },
	}

	local lang_path = vim.fs.joinpath(dir, "languages", lang_name, subdir_name)

	return vim.iter(vim.fs.dir(lang_path)):fold({}, function(acc, item_name, item_type)
		if item_type == "file" then
			local file_name = item_name:gsub("%.lua$", "")

			acc[file_name] = require(("codedocs.config.languages.%s.%s.%s"):format(lang_name, subdir_name, file_name))
		end

		return acc
	end)
end

---@type CodedocsConfig
return {
	logging = {
		level = vim.log.levels.INFO,
		path = (vim.fn.stdpath "log") .. "/codedocs.log",
	},
	---The `languages` table is created dynamically when the plugin first loads as there's a lot of languages;
	---a literal `require` call per language is not pretty
	languages = vim.iter(vim.fs.dir(vim.fs.joinpath(dir, "languages"))):fold({}, function(acc, name, type)
		if type ~= "directory" then return acc end

		local lang_utils = require "codedocs.config.languages.utils"
		local base_lang_config = require("codedocs.config.languages." .. name)

		base_lang_config.styles = _build_dir_tbl(name, "styles")

		for _, style_opts in pairs(base_lang_config.styles) do
			for _, annotation_opts in pairs(style_opts.annots) do
				annotation_opts.blocks = lang_utils.new_blocks_list(annotation_opts.blocks)
			end
		end

		base_lang_config.targets = _build_dir_tbl(name, "targets")

		acc[name] = base_lang_config
		return acc
	end),
	annot_builder = {
		state = {
			lines = {},
			snip_idx_counter = 1,
		},
		placeholders = {
			general = {
				["%%>"] = function(_)
					if not vim.bo.expandtab then return "\t" end

					local shiftwidth = vim.bo.shiftwidth
					if shiftwidth == 0 then shiftwidth = vim.bo.tabstop end

					return string.rep(" ", shiftwidth)
				end,
				["%%snip_idx"] = function(state)
					local snip_idx_label = tostring(state.snip_idx_counter)

					state.snip_idx_counter = state.snip_idx_counter + 1

					return snip_idx_label
				end,
			},
			items = {
				["%%item_name"] = function(_, item) return item.name end,
				["%%item_type"] = function(_, item) return item.type end,
			},
		},
	},
}
