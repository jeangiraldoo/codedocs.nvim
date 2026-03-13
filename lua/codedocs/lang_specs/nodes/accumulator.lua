local base_class = require "codedocs.lang_specs.nodes._base"

local Accumulator = {}
Accumulator.__index = Accumulator
setmetatable(Accumulator, { __index = base_class })

function Accumulator:new(data)
	local obj = setmetatable(data, self)
	return obj
end

function Accumulator:process(ts_node, lang_name, struct_style)
	if self.condition then
		if self.condition(struct_style) == false then return {} end
	end

	local results = vim.iter(self.children)
		:map(function(child) return child:process(ts_node, lang_name, struct_style) end)
		:flatten()
		:totable()
	return results
end
return Accumulator
