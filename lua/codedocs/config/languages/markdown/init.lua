---@alias CodedocsMarkdownStyleNames
---| "Codedocs"

---@alias CodedocsMarkdownStructNames
---| "comment"

---@class CodedocsMarkdownConfig: CodedocsLanguageConfig
---@field default_style CodedocsMarkdownStyleNames
---@field styles table<CodedocsMarkdownStyleNames, table<CodedocsMarkdownStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsMarkdownConfig
return {
	default_style = "Codedocs",
	styles = {
		Codedocs = require "codedocs.config.languages.markdown.Codedocs",
	},
	targets = {},
}
