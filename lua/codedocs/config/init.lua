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
---@field ignore_prev_gap boolean,
---@field items {
---        layout: string[],
---        insert_gap_between: {
---            enabled: boolean,
---            text: "" | string }}?} Section

---@class CodedocsAnnotationStyleOpts
---@field sections CodedocsSectionOpts[]
---@field indented boolean
---@field relative_position "above" | "below" | "empty_target_or_above"

---@class CodedocsLanguageConfig
---@field default_style string? Default style name
---@field styles table<string, table<string, CodedocsAnnotationStyleOpts>>

---@class CodedocsConfig
---@field debug boolean? Wether or not to enable debug mode
---@field aliases table<string, CodedocsSupportedLanguages>? Aliases for filetypes -> supported languages
---@field languages CodedocsLanguagesConfigs? Languages configuration

local source = debug.getinfo(1, "S").source:sub(2)
local base = vim.fn.fnamemodify(source, ":h") .. "/languages"
local builtin_languages = vim.fn.readdir(base, function(name) return vim.fn.isdirectory(base .. "/" .. name) == 1 end)

---@type CodedocsConfig
return {
	debug = false,
	---The `languages` table is created dynamically when the plugin first loads as there's a lot of languages;
	---a literal `require` call per language is not pretty
	languages = vim.iter(builtin_languages):fold({}, function(acc, lang_name)
		acc[lang_name] = require("codedocs.config.languages." .. lang_name)
		return acc
	end),
	aliases = {
		sh = "bash",
	},
}
