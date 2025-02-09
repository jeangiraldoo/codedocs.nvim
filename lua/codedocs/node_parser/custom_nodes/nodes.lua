local process_query = require("codedocs.node_parser.parser").process_query
local iterate_child_nodes = require("codedocs.node_parser.parser").iterate_child_nodes

local query_node = {}

function query_node:new(node_type, children, data)
	local node = {
		node_type = node_type,
		data = data or {},
		children = children or {},
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
	local node_type = self.data.node_type
	local def_val = self.data.def_val
	local mode = self.data.mode
	local child_data = {}
	iterate_child_nodes(node, node_type, child_data, mode)
	local final_data = {}
	if mode then
		final_data = child_data
		return final_data
	else
		if child_data[1] then
			final_data["type"] = def_val
			return { final_data }
		end
	end
end

local chain_node = query_node:new()
function chain_node:process(settings)
	local filetype = vim.bo.filetype
	local original_node = settings.node
	local result_nodes = { original_node }
	for _, query in ipairs(self.children) do
		local new_results = {}
		if type(query) ~= "string" then
			for _, node in ipairs(result_nodes) do
				settings.node = node
				query.children.nodes = node
				local result = process_query(query, settings)
				table.insert(new_results, result)
				settings.node = original_node
			end
			new_results = get_trimmed_table(new_results)
		else
			local query_obj = vim.treesitter.query.parse(filetype, query)
			for _, node in ipairs(result_nodes) do
				settings.node = node
				for id, capture_node, _ in query_obj:iter_captures(node, 0) do
					local node_text = vim.treesitter.get_node_text(capture_node, 0)
					local capture_name = query_obj.captures[id]
					if capture_name == "item_name" then
						settings.node = capture_node
						table.insert(new_results, { name = node_text })
					elseif capture_name == "target" then
						table.insert(new_results, capture_node)
					end
				end
			end
		end
		result_nodes = new_results
	end
	settings.node = original_node
	return result_nodes
end

local regex_node = query_node:new()
function regex_node:process(settings)
	local pattern = self.data.pattern
	local node = self.children.nodes
	local nodes = {}
	local node_text = vim.treesitter.get_node_text(node, 0)
	local result = string.find(node_text, pattern)
	local expected_result = self.data.mode and true or nil
	if result == expected_result then
		settings.node = node
		local final = process_query(self.data.query, settings)
		table.insert(nodes, final)
	end
	return get_trimmed_table(nodes)
end

local boolean_node = query_node:new()
function boolean_node:process(settings)
	local condition = settings.boolean_condition[1]
	local true_child = self.children[1]
	local false_child = self.children[2] or ""
	local child_to_process = condition and true_child or false_child
	table.remove(settings.boolean_condition, 1)
	return process_query(child_to_process, settings)
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

local group_node = query_node:new()
function group_node:process(settings)
	local items = process_query(self.children[1], settings)
	local groups = {}
	local name_group = {}
	for _, item_data in pairs(items) do
		local item_name = item_data.name
		local item_type = item_data.type
		if item_type ~= nil and item_name == nil then
			for _, final_name in pairs(name_group) do
				table.insert(groups, { name = final_name, type = item_type })
			end
			name_group = {}
		elseif item_type ~= nil and item_name ~= nil then
			table.insert(groups, { name = item_name, type = item_type })
		else
			table.insert(name_group, item_name)
		end
	end
	if #groups == 0 then
		return items
	end
	return groups
end

local function node_constructor(node_info)
	local node_type = node_info.type
	local children = node_info.children
	local data = node_info.data
	local query_nodes = {
		simple = simple_query_node,
		boolean = boolean_node,
		accumulator = accumulator_node,
		finder = finder_node,
		chain = chain_node,
		regex = regex_node,
		group = group_node,
	}
	local node = query_nodes[node_type]:new(node_type, children, data)
	return node
end

return {
	node_constructor = node_constructor,
}
