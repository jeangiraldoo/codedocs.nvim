local extractors = {}

function extractors.attributes(target_data)
	local results = {}
	if target_data.opts.attributes.static then
		local class_attrs = target_data.lang_query_parser [[
			(class_body
				(field_declaration
					(modifiers) @name (#match? @name "static")
					(type_identifier) @item_type
					(variable_declarator
						(identifier) @item_name)))
		]]
		vim.list_extend(results, class_attrs)
	end

	if target_data.opts.attributes.instance == "all" then
		local instance_attrs = target_data.lang_query_parser [[
			(class_body
				(field_declaration
					(modifiers) @name
					(#not-match? @name "static")
					(type_identifier) @item_type
					(variable_declarator
						(identifier) @item_name)))
		]]
		vim.list_extend(results, instance_attrs)
	end

	return results
end

return {
	node_identifiers = {
		"class_declaration",
	},
	extractors = extractors,
	opts = {
		attributes = {
			static = false,
			instance = "none", -- Java attrs can only be declared in the class body
		},
	},
}
