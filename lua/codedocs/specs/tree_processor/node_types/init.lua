return function(node_info)
	local new_node = vim.tbl_extend("force", {}, node_info)
	local extend_new_node = require("codedocs.specs.tree_processor.node_types." .. node_info.type)

	return extend_new_node(new_node)
end
