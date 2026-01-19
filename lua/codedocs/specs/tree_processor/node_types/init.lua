local current_dir = "codedocs.specs.tree_processor.node_types."

local function new_item_builder(include_type)
	return {
		current = nil,
		items = {},

		start_name = function(self, name) self.current = { name = name } end,
		start_type = function(self, type) self.current = { type = type } end,

		set_name = function(self, name)
			if self.current then self.current.name = name end
		end,
		set_type = function(self, type_)
			if self.current and include_type then self.current.type = type_ end
		end,

		emit = function(self)
			if self.current then
				table.insert(self.items, self.current)
				self.current = nil
			end
		end,
	}
end

local function handle_capture(builder, capture_name, node_text, name_first)
	if capture_name == "item_name" then
		if name_first then
			builder:emit()
			builder:start_name(node_text)
		else
			builder:set_name(node_text)
			builder:emit()
		end
		return
	end

	if capture_name == "item_type" then
		if name_first then
			if builder.current == nil then
				-- Edge case: handles items with only a type (e.g. function return type) by emitting a nameless item
				builder:start_type(node_text)
			else
				builder:set_type(node_text)
			end
			builder:emit()
		else
			builder:emit()
			builder:start_type(node_text)
		end
	end
end

local function parse_query(node, include_type, filetype, query, identifier_pos)
	if not query then return {} end

	local query_obj = vim.treesitter.query.parse(filetype, query)
	local node_captures = query_obj:iter_captures(node, 0)
	local query_capture_tags = query_obj.captures

	if vim.tbl_contains(query_capture_tags, "target") then
		local target_nodes = {}
		for id, capture_node in node_captures do
			if query_capture_tags[id] == "target" then table.insert(target_nodes, capture_node) end
		end
		return target_nodes
	end

	local builder = new_item_builder(include_type)
	local name_first = identifier_pos

	for id, capture_node in node_captures do
		local capture_name = query_capture_tags[id]
		local node_text = vim.treesitter.get_node_text(capture_node, 0)

		handle_capture(builder, capture_name, node_text, name_first)
	end

	builder:emit()
	return builder.items
end

local function node_processor(query, context)
	local filetype = vim.bo.filetype
	if type(query) == "string" then
		return parse_query(context.node, context.include_type, filetype, query, context.identifier_pos)
	elseif type(query) == "table" then
		return query:process(context)
	end
end

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
	local extend_new_node = require(current_dir .. node_type)

	if node_category == "leaf" then return extend_new_node(new_node) end

	return extend_new_node(new_node, node_processor)
end
