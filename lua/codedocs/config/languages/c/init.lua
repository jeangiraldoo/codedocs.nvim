---@alias CodedocsCStyleNames
---| "Doxygen"

---@alias CodedocsCStructNames
---| "func"
---| "comment"

---@class CodedocsCConfig: CodedocsLanguageConfig
---@field default_style CodedocsCStyleNames
---@field styles table<CodedocsCStyleNames, table<CodedocsCStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsCConfig
return {
	default_style = "Doxygen",
	styles = {},
	targets = {},
}
