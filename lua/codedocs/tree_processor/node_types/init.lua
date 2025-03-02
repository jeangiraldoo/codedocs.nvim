local current_dir = "codedocs.tree_processor.node_types."
local node_processor = require("codedocs.tree_processor.processor")[1]

local node_template = {}
function node_template:new(node_type, children, data)
	local node = {
		node_type = node_type,
		data = data or {},
		children = children or {},
	}
	setmetatable(node, self)
	self.__index = self
	return node
end

local function get_node(name)
	local type_index = {
		simple = "branch",
		boolean = "branch",
		accumulator = "branch",
		finder = "leaf",
		chain = "branch",
		regex = "branch",
		group = "branch",
	}
	local node_type = type_index[name]
	local getter_data = { node_template }

	if node_type == "branch" then table.insert(getter_data, node_processor) end
	return require(current_dir .. name).get_node(getter_data)
end

local function node_constructor(node_info)
	local node_type = node_info.type
	local children = node_info.children
	local data = node_info.data
	local query_nodes = {
		simple = get_node("simple"),
		boolean = get_node("boolean"),
		accumulator = get_node("accumulator"),
		finder = get_node("finder"),
		chain = get_node("chain"),
		regex = get_node("regex"),
		group = get_node("group"),
	}
	local node = query_nodes[node_type]:new(node_type, children, data)
	return node
end

return node_constructor
