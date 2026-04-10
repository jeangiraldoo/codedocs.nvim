---@alias CodedocsPythonStyleNames
---| "Google"
---| "Numpy"
---| "reST"

---@alias CodedocsPythonStructNames
---| "class"
---| "func"
---| "comment"

---@class CodedocsPythonConfig: CodedocsLanguageConfig
---@field default_style CodedocsPythonStyleNames
---@field styles table<CodedocsPythonStyleNames, table<CodedocsPythonStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsPythonConfig
return {
	default_style = "reST",
	styles = {},
	targets = {},
}
