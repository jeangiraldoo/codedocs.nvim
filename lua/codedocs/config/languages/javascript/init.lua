---@alias CodedocsJSStyleNames
---| "JSDoc"

---@alias CodedocsJSStructNames
---| "class"
---| "func"
---| "comment"

---@class CodedocsJSConfig: CodedocsLanguageConfig
---@field default_style CodedocsJSStyleNames
---@field styles table<CodedocsJSStyleNames, table<CodedocsJSStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsJSConfig
return {
	default_style = "JSDoc",
	styles = {},
	targets = {},
}
