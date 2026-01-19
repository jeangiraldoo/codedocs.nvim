return function(node_info)
	local node_type = node_info.type

	local type_index = {
		simple = "branch",
		boolean = "branch",
		accumulator = "branch",
		finder = "leaf",
		chain = "branch",
		regex = "branch",
		group = "branch",
	}
	local node_category = type_index[node_type]

	local new_node = vim.tbl_extend("force", {}, node_info)
	local extend_new_node = require("codedocs.specs.tree_processor.node_types." .. node_type)

	if node_category == "leaf" then return extend_new_node(new_node) end

	return extend_new_node(new_node)
end
