---@alias CodedocsPHPStyleNames
---| "PHPDoc"

---@alias CodedocsPHPStructNames
---| "func"
---| "comment"

---@class CodedocsPHPConfig: CodedocsLanguageConfig
---@field default_style CodedocsPHPStyleNames
---@field styles table<CodedocsPHPStyleNames, table<CodedocsPHPStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsPHPConfig
return {
	default_style = "PHPDoc",
	styles = {},
	targets = {},
}
