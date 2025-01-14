local function get_class_attrs(node, ts_utils, include_type)
	--- Used to check the node types for every language in order to build their queries
	-- for _, val in pairs (ts_utils.get_named_children(node)) do
	-- 	print("block type " .. val:type())
	-- 	if val:type() == "block" or val:type() == "class_body" or val:type() == "declaration_list" then
	-- 		print("FIRST")
	-- 		for _, valt in pairs (ts_utils.get_named_children(val)) do
	-- 			print("type " .. valt:type())
	-- 			if valt:type() == "expression_statement" then
	-- 				print("THIRD")
	-- 				for _, ha in pairs(ts_utils.get_named_children(valt)) do
	-- 					print(ha:type())
	-- 					if ha:type() == "assignment" then
	-- 						print("found")
	-- 						for _, tu in pairs (ts_utils.get_named_children(ha)) do
	-- 							print(tu:type())
	-- 							print(vim.treesitter.get_node_text(tu, 0))
	-- 						end
	-- 					end
	-- 				end
	-- 			elseif valt:type() == "field_definition" or valt:type() == "field_declaration" or valt:type() == "property_declaration" or valt:type() == "field" or valt:type() == "public_field_definition" then
	-- 				print("field")
	-- 				local name, d_type
	-- 				for _, st in pairs(ts_utils.get_named_children(valt)) do
	-- 					print(st:type())
	-- 					if st:type() == "variable_declarator" or st:type() == "variable_declaration" then
	-- 						print("var")
	-- 						for _, nam in pairs(ts_utils.get_named_children(st)) do
	-- 							print(nam:type())
	-- 							if nam:type() == "identifier" or nam:type() == "simple_identifier" then
	-- 								name = vim.treesitter.get_node_text(nam, 0)
	-- 								print(name)
	-- 							elseif nam:type() == "user_type" then
	-- 								d_type = vim.treesitter.get_node_text(nam, 0)
	-- 								print("USER TYPE")
	-- 							end
	-- 						end
	-- 					elseif st:type() == "property_identifier" or st:type() == "property_element" then
	-- 						name = vim.treesitter.get_node_text(st, 0)
	-- 					elseif st:type() == "type_identifier" or st:type() == "type_annotation" then
	-- 						print("TYPE IDENTIFIER")
	-- 						d_type = vim.treesitter.get_node_text(st, 0)
	-- 					end
	-- 				end
	-- 				print("FINAL DATA")
	-- 				print(name)
	-- 				print(d_type)
	-- 			end
	-- 		end
	-- 	end
	-- end
	--
	local filetype = vim.bo.filetype
	local query = require("codedocs.struct_parser.queries.init")[filetype]["class"]
	if query == nil then
		return nil
	end

	local query_obj = vim.treesitter.query.parse(filetype, query)
	local attrs = {}
	for _, captures, _ in query_obj:iter_matches(node, 0) do
		local attr_name, attr_type
		for _, attr in pairs(captures) do
			local node_text = vim.treesitter.get_node_text(attr, 0)
			if attr:type() == "identifier" or attr:type() == "simple_identifier" or attr:type() == "property_identifier" then
				attr_name = node_text
			elseif (attr:type() == "type_identifier" or attr:type() == "user_type" or attr:type() == "type_annotation") and include_type then
				attr_type = node_text
			end
		end
		local attr = {name = attr_name, type = attr_type}
		table.insert(attrs, attr)
	end
	return attrs
end

local function get_attrs(class_attrs)
	local attrs = {}
	for _, attr in pairs(class_attrs) do
		table.insert(attrs, attr)
	end
	return attrs
end

local function get_data(node, ts_utils, style, opts)
	local include_type = style[opts.include_attr_type.val]
	local class_attrs = get_class_attrs(node, ts_utils, include_type)
	local attrs = {}
	if class_attrs ~= nil then
		attrs = get_attrs(class_attrs)
	end
	return attrs
end

return {
	get_data = get_data
}
