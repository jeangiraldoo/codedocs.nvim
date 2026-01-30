local function _new_item_builder()
	return {
		current = nil,
		items = {},

		start_name = function(self, name) self.current = { name = name } end,
		start_type = function(self, type) self.current = { type = type } end,

		set_name = function(self, name)
			if self.current then self.current.name = name end
		end,
		set_type = function(self, type_)
			if self.current then self.current.type = type_ end
		end,

		emit = function(self)
			if self.current then
				table.insert(self.items, self.current)
				self.current = nil
			end
		end,
	}
end

local function _handle_capture(builder, capture_name, node_text, name_first)
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
				builder:start_name("")
			end
			builder:set_type(node_text)
			builder:emit()
		else
			builder:emit()
			builder:start_type(node_text)
		end
	end
end

return function(base_node)
	function base_node:process(ts_node)
		local filetype = vim.bo.filetype
		local identifier_pos = require("codedocs.specs").get_lang_identifier_pos(filetype)
		local query = self.query

		if not query then return {} end

		local query_obj = vim.treesitter.query.parse(filetype, query)
		local node_captures = query_obj:iter_captures(ts_node, 0)
		local query_capture_tags = query_obj.captures

		if vim.tbl_contains(query_capture_tags, "target") then
			local target_nodes = {}
			for id, capture_node in node_captures do
				if query_capture_tags[id] == "target" then table.insert(target_nodes, capture_node) end
			end
			return target_nodes
		end

		local builder = _new_item_builder()
		local name_first = identifier_pos

		for id, capture_node in node_captures do
			local capture_name = query_capture_tags[id]
			local node_text = vim.treesitter.get_node_text(capture_node, 0)

			_handle_capture(builder, capture_name, node_text, name_first)
		end

		builder:emit()
		return vim.tbl_map(function(item)
			if not item.name then
				item.name = ""
			elseif not item.type then
				item.type = ""
			end
			return item
		end, builder.items)
	end
	return base_node
end
