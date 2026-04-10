---@alias CodedocsRubyStyleNames
---| "YARD"

---@alias CodedocsRubyStructNames
---| "func"
---| "comment"

---@class CodedocsRubyConfig: CodedocsLanguageConfig
---@field default_style CodedocsRubyStyleNames
---@field styles table<CodedocsRubyStyleNames, table<CodedocsRubyStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsRubyConfig
return {
	default_style = "YARD",
	styles = {},
	targets = {},
}
