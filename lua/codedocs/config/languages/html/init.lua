---@alias CodedocsHTMLStyleNames
---| "Codedocs"

---@alias CodedocsHTMLStructNames
---| "comment"

---@class CodedocsHTMLConfig: CodedocsLanguageConfig
---@field default_style CodedocsHTMLStyleNames
---@field styles table<CodedocsHTMLStyleNames, table<CodedocsHTMLStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsHTMLConfig
return {
	default_style = "Codedocs",
	styles = {},
	targets = {},
}
