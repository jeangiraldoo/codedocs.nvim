---@alias CodedocsRustStyleNames
---| "RustDoc"

---@alias CodedocsRustStructNames
---| "func"
---| "comment"

---@class CodedocsRustConfig: CodedocsLanguageConfig
---@field default_style CodedocsRustStyleNames
---@field styles table<CodedocsRustStyleNames, table<CodedocsRustStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsRustConfig
return {
	default_style = "RustDoc",
	styles = {},
	targets = {},
}
