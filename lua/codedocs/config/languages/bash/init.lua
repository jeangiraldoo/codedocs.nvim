---@alias CodedocsBashStyleNames
---| "Google"

---@alias CodedocsBashStructNames
---| "func"
---| "comment"

---@class CodedocsBashConfig: CodedocsLanguageConfig
---@field default_style CodedocsBashStyleNames
---@field styles table<CodedocsBashStyleNames, table<CodedocsBashStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsBashConfig
return {
	default_style = "Google",
	styles = {},
	targets = {},
}
