local Node = {}

function Node:_build_node(internal_node)
	local NodeClass = require("codedocs.lang_specs.nodes." .. internal_node.type)

	local node = NodeClass:new(internal_node)

	if internal_node.children then
		node.children = vim.tbl_map(function(child) return self:_build_node(child) end, internal_node.children)
	end

	return node
end

return Node
