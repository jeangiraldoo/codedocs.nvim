local Config = {}

local fs_utils = require "codedocs.utils.fs"

---Detection providers handle finding annotation targets in a language's syntax.
---Each provider exposes `detect(lang_name)` and `build_identifiers(targets_data)`.
---Users can register extra providers via `setup { item_extractor = { detection_providers = {...} } }`.
local detection_providers = fs_utils.build_dir_tbl "codedocs.item_extractor.providers"

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

---@class CodedocsDetectionProvider
---@field detect fun(lang_name: string): string?, number?, table? Detects the target under the cursor
---@field build_identifiers fun(targets_data: table): table<string, string> Maps identifiers to target names

---@class CodedocsItemExtractorConfig
---@field detection_providers table<string, CodedocsDetectionProvider>? Detection providers registry

---@class CodedocsConfig
---@field debug boolean? Wether or not to enable debug mode
---@field aliases table<string, CodedocsSupportedLanguages>? Aliases for filetypes -> supported languages
---@field item_extractor CodedocsItemExtractorConfig? Extraction configuration
---@field languages CodedocsLanguagesConfigs? Languages configuration
---@type CodedocsConfig
Config.opts = {
	logging = {
		level = vim.log.levels.INFO,
		path = vim.fs.joinpath(vim.fn.stdpath "log", "codedocs.log"),
	},

	---The `languages` table is created dynamically when the plugin first loads as there's a lot of languages;
	---a literal `require` call per language is not pretty
	languages = vim.iter(fs_utils.read_dir_names(fs_utils.PATHS.REL.LANGUAGES)):fold({}, function(acc, name)
		local lang_path = fs_utils.joinmodule { fs_utils.path_to_module(fs_utils.PATHS.REL.LANGUAGES), name }
		local base_lang_config = require(lang_path)

		base_lang_config.styles = (function()
			local styles_path = fs_utils.joinmodule { lang_path, "styles" }
			local styles = fs_utils.build_dir_tbl(styles_path)

			for item_name, tbl in pairs(styles) do
				tbl.annots = fs_utils.build_dir_tbl(styles_path .. "." .. item_name)
			end
			return styles
		end)()

		base_lang_config.targets = (function()
			local targets_path = fs_utils.joinmodule { lang_path, "targets" }
			local targets = fs_utils.build_dir_tbl(targets_path)

			for target_name, tbl in pairs(targets) do
				local extractors_path = fs_utils.joinmodule { targets_path, target_name }
				local fs_path = fs_utils.module_to_path(extractors_path)

				tbl.extractors = vim.iter(fs_utils.read_dir_names(fs_path)):fold({}, function(extractors, item_name)
					for provider_name in pairs(detection_providers) do
						local ok, provider_extractor =
							pcall(require, fs_utils.joinmodule { extractors_path, item_name, provider_name })
						if ok then
							extractors[item_name] = extractors[item_name] or {}
							extractors[item_name][provider_name] = provider_extractor
						end
					end

					return extractors
				end)
			end

			return targets
		end)()

		acc[name] = base_lang_config
		return acc
	end),
	item_extractor = {
		detection_providers = detection_providers,
	},
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
	local lang_config = Config.opts.languages[lang_name]
	local provider = Config.opts.item_extractor.detection_providers[lang_config.detection_provider]

	if not provider then return {} end

	local targets_data = lang_config.targets
	if targets_data._identifiers then return targets_data._identifiers end

	targets_data._identifiers = provider.build_identifiers(targets_data)
	return targets_data._identifiers
end

return Config
