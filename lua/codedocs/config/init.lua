local Config = {}

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

local dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")
local DETECTED_LANGS = vim.fs.dir(vim.fs.joinpath(dir, "languages"))

---@type CodedocsConfig
Config.opts = {
	logging = {
		level = vim.log.levels.INFO,
		path = (vim.fn.stdpath "log") .. "/codedocs.log",
	},
	---The `languages` table is created dynamically when the plugin first loads as there's a lot of languages;
	---a literal `require` call per language is not pretty
	languages = vim.iter(DETECTED_LANGS):fold({}, function(acc, name, type)
		if type ~= "directory" then return acc end

		local lang_path = "codedocs.config.languages." .. name
		local styles_path = lang_path .. ".styles"
		local targets_path = lang_path .. ".targets"

		local base_lang_config = require(lang_path)
		local build_dir_tbl = require("codedocs.utils.general").build_dir_tbl

		base_lang_config.styles = (function()
			local styles = build_dir_tbl(styles_path)

			for item_name, tbl in pairs(styles) do
				tbl.annots = build_dir_tbl(styles_path .. "." .. item_name)
			end
			return styles
		end)()

		base_lang_config.targets = (function()
			local targets = build_dir_tbl(targets_path)

			for target_name, tbl in pairs(targets) do
				tbl.extractors = build_dir_tbl(targets_path .. "." .. target_name)
			end

			return targets
		end)()

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

function Config.setup(user_config)
	vim.validate {
		user_config = { user_config, "table" },
	}

	if not user_config then return end

	local opts = Config.opts
	local merged = vim.tbl_deep_extend("force", opts, user_config)

	for k in pairs(opts) do
		opts[k] = nil
	end
	for k, v in pairs(merged) do
		opts[k] = v
	end

	require("codedocs.config.validations").all(merged)
end

function Config.get_supported_langs() return vim.tbl_keys(Config.opts.languages) end

---@return string[] supported_styles List of style names
function Config.get_supported_styles(lang_name)
	local supported_styles = vim.tbl_keys(Config.opts.languages[lang_name].styles)
	table.sort(supported_styles)
	return supported_styles
end

function Config.get_target_identifiers(lang_name)
	local targets_data = require("codedocs.config").opts.languages[lang_name].targets

	if targets_data._identifiers then return targets_data._identifiers end

	local target_identifiers = {}
	for target_name, target_data in pairs(targets_data) do
		for _, node_identifier in ipairs(target_data.detection.node_identifiers) do
			target_identifiers[node_identifier] = target_name
		end
	end

	targets_data._identifiers = target_identifiers
	return target_identifiers
end

return Config
