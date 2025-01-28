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
	local original_node = settings.node
	for _, node_item in ipairs (nodes) do
		settings.node = node_item
		local result = process_query(second_query, settings)
		table.insert(items, result)
	end
	settings.node = original_node
	return get_trimmed_table(items)
end

local chain_node = query_node:new()
function chain_node:process(settings)
	local filetype = vim.bo.filetype
	local original_node = settings.node
	local result_nodes = {original_node}
	for _, query in ipairs(self.children) do
		if type(query) ~= "string" then
			query.children.nodes = result_nodes
			local result = process_query(query, settings)
			settings.node = original_node
			return result
		else
			local query_obj = vim.treesitter.query.parse(filetype, query)
			local new_results = {}
			local original_node = settings.node
			for _, node in ipairs(result_nodes) do
				settings.node = node
				for id, capture_node, _ in query_obj:iter_captures(node, 0) do
					local capture_name = query_obj.captures[id]
					if capture_name ~= "target" then
						settings.node = capture_node
						local result = process_query(query, settings)
						table.insert(new_results, result)
					else
						table.insert(new_results, capture_node)
					end
				end
			end
			result_nodes = new_results
		end
	end
	settings.node = original_node
	return get_trimmed_table(result_nodes)
end

local regex_node = query_node:new()
function regex_node:process(settings)
	local filetype = vim.bo.filetype
	local pattern = self.children.pattern
	local nodes = {}
	for _, node, _ in ipairs(self.children.nodes) do
		local node_text = vim.treesitter.get_node_text(node, 0)
		local result = string.find(node_text, pattern)
		local expected_result = (self.children.mode) and true or nil
		if result == expected_result then
			settings.node = node
			local final = process_query(self.children.query, settings)
			table.insert(nodes, final)
		end
	end
	return get_trimmed_table(nodes)
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
		local result = process_query(query, settings)
        table.insert(results, result)
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
		chain = chain_node,
		regex = regex_node
	}
	local node = query_nodes[node_type]:new(node_type, children)
	return node
end

return {
	node_constructor = node_constructor,
}
