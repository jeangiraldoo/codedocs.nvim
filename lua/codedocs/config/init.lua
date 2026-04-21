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
local languages_base = vim.fn.fnamemodify(source, ":h") .. "/languages"
local builtin_languages = vim.fn.readdir(
	languages_base,
	function(name) return vim.fn.isdirectory(languages_base .. "/" .. name) == 1 end
)

local function read_lua_file_names(path)
	local files = vim.fn.readdir(path, function(name) return name:sub(-4) == ".lua" end)
	local res = vim.iter(files)
		:map(function(file_name)
			local name = file_name:gsub("%.lua$", "")
			return name
		end)
		:totable()
	return res
end

local function construct_table_from_files(lang_name, dir_name)
	local path = languages_base .. "/" .. lang_name .. "/" .. dir_name

	local stat = vim.loop.fs_stat(path)
	if not stat or stat.type ~= "directory" then return {} end

	return vim.iter(read_lua_file_names(path)):fold({}, function(targets_acc, file_name)
		targets_acc[file_name] = require(("codedocs.config.languages.%s.%s.%s"):format(lang_name, dir_name, file_name))
		return targets_acc
	end)
end

---@type CodedocsConfig
return {
	debug = false,
	---The `languages` table is created dynamically when the plugin first loads as there's a lot of languages;
	---a literal `require` call per language is not pretty
	languages = vim.iter(builtin_languages):fold({}, function(acc, lang_name)
		local base_lang_config = require("codedocs.config.languages." .. lang_name)

		base_lang_config.styles = construct_table_from_files(lang_name, "styles")
		base_lang_config.targets = construct_table_from_files(lang_name, "targets")

		acc[lang_name] = base_lang_config
		return acc
	end),
	aliases = {
		sh = "bash",
	},
}
