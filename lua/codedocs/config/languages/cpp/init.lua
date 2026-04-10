---@alias CodedocsCPPStyleNames
---| "Doxygen"

---@alias CodedocsCPPStructNames
---| "func"
---| "comment"

---@class CodedocsCPPConfig: CodedocsLanguageConfig
---@field default_style CodedocsCPPStyleNames
---@field styles table<CodedocsCPPStyleNames, table<CodedocsCPPStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsCPPConfig
return {
	default_style = "Doxygen",
	styles = {},
	targets = {},
}
