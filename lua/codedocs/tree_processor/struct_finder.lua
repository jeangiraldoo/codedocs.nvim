local function validate_treesitter(lang)
	if not pcall(require, "nvim-treesitter.configs") then
		vim.notify("Treesitter is not installed. Please install it.", vim.log.levels.ERROR)
		return false
	end
	local parsers = require("nvim-treesitter.parsers")

	if not parsers.has_parser(lang) then
		vim.notify("The treesitter parser for " .. lang .. " is not installed", vim.log.levels.ERROR)
		return false
	end
	return true
end

local function get_supported_node_data(node_at_cursor, structs)
	if node_at_cursor == nil then return "comment", node_at_cursor end
	while node_at_cursor do
		for struct_name, value in pairs(structs) do
			if struct_name ~= "comment" then
				local node_identifiers = value["node_identifiers"]
				for _, id in pairs(node_identifiers) do
					if node_at_cursor:type() == id then return struct_name, node_at_cursor end
				end
			end
		end
		node_at_cursor = node_at_cursor:parent()
	end
	return "comment", node_at_cursor
end

local function get_node_type(filetype, structs)
	if not validate_treesitter(filetype) then return "comment", nil end
	-- local lang_data = require("codedocs.node_parser.custom_nodes.init").get_lang_trees(filetype)
	-- local lang_trees = lang_data["trees"]
	local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()
	return get_supported_node_data(node, structs)
end

return get_node_type
