local Spec = require("codedocs.specs")

local function _item_parser(node, struct_tree, struct_style)
	local items = {}
	for _, section_name in pairs(struct_style.general.section_order) do
		local section_tree = struct_tree[section_name]

		items[section_name] = vim.iter(section_tree)
			:map(function(tree_node) return tree_node:process(node, struct_style) end)
			:find(
				function(section_items_list) return section_items_list and (not vim.tbl_isempty(section_items_list)) end
			) or {}
	end
	return items
end

return function(lang, struct_name, struct_tree, node, style_name)
	local struct_style = style_name and Spec.get_struct_style(lang, struct_name, style_name)
		or Spec:_get_struct_main_style(lang, struct_name)

	local pos, data
	if struct_name == "comment" then
		pos = vim.api.nvim_win_get_cursor(0)[1] - 1
		data = {}
	else
		pos = node:range()
		data = _item_parser(node, struct_tree, struct_style)
	end

	return data, struct_style, pos
end
