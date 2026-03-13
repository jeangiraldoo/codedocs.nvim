local base_class = require "codedocs.lang_specs.nodes._base"

local Chain = {}
Chain.__index = Chain
setmetatable(Chain, { __index = base_class })

function Chain:new(data)
	local obj = setmetatable(data, self)
	return obj
end

function Chain:process(original_ts_node, lang_name, struct_style)
	local result_nodes = { original_ts_node }
	for _, child in ipairs(self.children) do
		result_nodes = vim.iter(result_nodes)
			:map(function(node) return child:process(node, lang_name, struct_style) end)
			:flatten()
			:totable()
	end
	return result_nodes
end

return Chain
