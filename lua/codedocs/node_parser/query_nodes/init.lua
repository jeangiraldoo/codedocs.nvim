local current_dir = "codedocs.node_parser.query_nodes."
local function get_lang_trees(lang)
	local node_constructor = require(current_dir .. "nodes").node_constructor
	local lang_data = require(current_dir .. lang .. ".init")
	local identifier_pos, supported_structs = lang_data.identifier_pos, lang_data.supported_structs

	local data = {
		identifier_pos = identifier_pos,
		trees = {}
	}
	for _, struct_name in ipairs(supported_structs) do
		local struct_module = require(current_dir .. lang .. "." .. struct_name)
		local struct_tree = struct_module.get_tree(node_constructor)
		data["trees"][struct_name] = struct_tree
	end
	return data
end

return {
	get_lang_trees = get_lang_trees,
}
