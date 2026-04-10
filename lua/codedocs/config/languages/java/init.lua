---@alias CodedocsJavaStyleNames
---| "JavaDoc"

---@alias CodedocsJavaStructNames
---| "class"
---| "func"
---| "comment"

---@class CodedocsJavaConfig: CodedocsLanguageConfig
---@field default_style CodedocsJavaStyleNames
---@field styles table<CodedocsJavaStyleNames, table<CodedocsJavaStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsJavaConfig
return {
	default_style = "JavaDoc",
	styles = {},
	targets = {},
}
