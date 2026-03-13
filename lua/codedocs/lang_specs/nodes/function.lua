local base_class = require "codedocs.lang_specs.nodes._base"

local Function = {}
Function.__index = Function
setmetatable(Function, { __index = base_class })

function Function:new(data)
	local new_node = vim.tbl_extend("force", {}, data)

	local obj = setmetatable(new_node, self)
	return obj
end

function Function:process(original_ts_node, lang_name, struct_style)
	local result_nodes = self.callback(original_ts_node, self.children, lang_name, struct_style)
	return result_nodes
end
return Function
