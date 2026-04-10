---@alias CodedocsLuaStyleNames
---| "EmmyLua"
---| "LDoc"

---@alias CodedocsLuaStructNames
---| "func"
---| "comment"

---@class CodedocsLuaConfig: CodedocsLanguageConfig
---@field default_style CodedocsLuaStyleNames
---@field styles table<CodedocsLuaStyleNames, table<CodedocsLuaStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsLuaConfig
return {
	default_style = "EmmyLua",
	styles = {},
	targets = {},
}
