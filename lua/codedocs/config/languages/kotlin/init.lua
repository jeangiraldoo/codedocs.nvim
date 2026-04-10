---@alias CodedocsKotlinStyleNames
---| "KDoc"

---@alias CodedocsKotlinStructNames
---| "class"
---| "func"
---| "comment"

---@class CodedocsKotlinConfig: CodedocsLanguageConfig
---@field default_style CodedocsKotlinStyleNames
---@field styles table<CodedocsKotlinStyleNames, table<CodedocsKotlinStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsKotlinConfig
return {
	default_style = "KDoc",
	styles = {},
	targets = {},
}
