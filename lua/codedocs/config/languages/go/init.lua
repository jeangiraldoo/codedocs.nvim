---@alias CodedocsGoStyleNames
---| "Godoc"

---@alias CodedocsGoStructNames
---| "func"
---| "comment"

---@class CodedocsGoConfig: CodedocsLanguageConfig
---@field default_style CodedocsGoStyleNames
---@field styles table<CodedocsGoStyleNames, table<CodedocsGoStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsGoConfig
return {
	default_style = "Godoc",
	styles = {},
	targets = {},
}
