---@alias CodedocsTSStyleNames
---| "TSDoc"

---@alias CodedocsTSStructNames
---| "class"
---| "func"
---| "comment"

---@class CodedocsTSConfig: CodedocsLanguageConfig
---@field default_style CodedocsTSStyleNames
---@field styles table<CodedocsTSStyleNames, table<CodedocsTSStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsTSConfig
return {
	default_style = "TSDoc",
	styles = {},
	targets = {},
}
