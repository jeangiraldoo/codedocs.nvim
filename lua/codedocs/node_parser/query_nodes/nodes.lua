local process_query = require("codedocs.node_parser.parser").process_query
local iterate_child_nodes = require("codedocs.node_parser.parser").iterate_child_nodes

local query_node = {}

function query_node:new(node_type, children)
    local node = {
        node_type = node_type,
        children = children or {}
    }
    setmetatable(node, self)
    self.__index = self
    return node
end

local function get_trimmed_table(tbl)
	local trimmed_tbl = {}
	for _, inner_tbl in pairs(tbl) do
		for _, val in ipairs(inner_tbl) do
			table.insert(trimmed_tbl, val)
		end
	end
	return trimmed_tbl
end

local finder_node = query_node:new()
function finder_node:process(settings)
	local node = settings.node
	local node_type = self.children[1]
	local def_val = self.children[2]
	local child_data = {}
	iterate_child_nodes(node, node_type, child_data, false)
	local final_data =  {}
	final_data["type"] = def_val
	return (#child_data > 0) and {final_data} or {}
end

local double_recursion_node = query_node:new()
function double_recursion_node:process(settings)
	local filetype = vim.bo.filetype
	local first_query, second_query = self.children.first_query, self.children.second_query
	local query_obj = vim.treesitter.query.parse(filetype, first_query)
	local nodes = {}
	for id, capture_node, _ in query_obj:iter_captures(settings.node, 0) do
		local capture_name = query_obj.captures[id]
		if capture_name == "target" then
			iterate_child_nodes(capture_node, self.children.target, nodes, true)
		end
	end
	local items = {}
	for _, node_item in ipairs (nodes) do
		settings.node = node_item
		local result = process_query(second_query, settings)
		table.insert(items, result)
	end
	return get_trimmed_table(items)
end

local boolean_node = query_node:new()
function boolean_node:process(settings)
    local condition = settings.boolean_condition[1] -- Or any logic you want
    local query_to_process = condition and self.children[1] or self.children[2]
	table.remove(settings.boolean_condition, 1)
    return process_query(query_to_process, settings)
end

local accumulator_node = query_node:new()
function accumulator_node:process(settings)
    local results = {}
    for _, query in ipairs(self.children) do
        table.insert(results, process_query(query, settings))
    end
    return get_trimmed_table(results)
end

local simple_query_node = query_node:new()
function simple_query_node:process(settings)
	local query = self.children[1]
	local final = process_query(query, settings)
	return final
end

local function node_constructor(data)
	local node_type = data.type
	local children = data.children
	local query_nodes = {
		simple = simple_query_node,
		boolean = boolean_node,
		double_recursion = double_recursion_node,
		accumulator = accumulator_node,
		finder = finder_node,
	}
	local node = query_nodes[node_type]:new(node_type, children)
	return node
end

return {
	node_constructor = node_constructor,
}
