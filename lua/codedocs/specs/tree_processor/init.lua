return function(struct_style, struct_tree, node)
	local pos = node:range()

	local items = {}
	for _, section_name in pairs(struct_style.general.section_order) do
		local section_tree = struct_tree[section_name]

		items[section_name] = vim.iter(section_tree)
			:map(function(tree_node) return tree_node:process(node, struct_style) end)
			:find(
				function(section_items_list) return section_items_list and (not vim.tbl_isempty(section_items_list)) end
			) or {}
	end

	return items, pos
end
