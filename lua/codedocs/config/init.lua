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

---@type CodedocsConfig
return {
	debug = false,
	languages = {
		bash = require "codedocs.config.languages.bash",
		c = require "codedocs.config.languages.c",
		cpp = require "codedocs.config.languages.cpp",
		go = require "codedocs.config.languages.go",
		java = require "codedocs.config.languages.java",
		kotlin = require "codedocs.config.languages.kotlin",
		javascript = require "codedocs.config.languages.javascript",
		typescript = require "codedocs.config.languages.typescript",
		python = require "codedocs.config.languages.python",
		ruby = require "codedocs.config.languages.ruby",
		php = require "codedocs.config.languages.php",
		lua = require "codedocs.config.languages.lua",
		rust = require "codedocs.config.languages.rust",
		markdown = require "codedocs.config.languages.markdown",
	},
	aliases = {
		sh = "bash",
	},
}
