local extractors = {}

function extractors.attributes(target_data)
	local results = {}

	if target_data.opts.attributes.static then
		local class_attrs = target_data.lang_query_parser [[
			(class_definition
				body: (block
					(expression_statement
						(assignment
							left: (_) @item_name))))
		]]
		vim.list_extend(results, class_attrs)
	end

	if target_data.opts.attributes.instance == "constructor" then
		local constructor_node = target_data.lang_query_parser([[
						(function_definition
							name: (identifier) @func_name
							(#eq? @func_name "__init__")) @target
					]])[1]

		if constructor_node then
			local constructor_instance_attrs = target_data.generic_query_parser(
				constructor_node,
				target_data.lang_name,
				[[
						(attribute
							(identifier) @item_name (#not-eq? @item_name "self"))
					]]
			)
			vim.list_extend(results, constructor_instance_attrs)

			return results
		end
	end

	if target_data.opts.attributes.instance == "all" then
		local all_instance_attrs = target_data.lang_query_parser [[
			(assignment
				left: (attribute
					object: (identifier) @obj
					attribute: (identifier) @item_name
				)
				(#eq? @obj "self")
				(#has-ancestor? @item_name function_definition))
		]]

		vim.list_extend(results, all_instance_attrs)
	end

	return results
end

return {
	node_identifiers = {
		"class_definition",
	},
	extractors = extractors,
	opts = {
		attributes = {
			static = true,
			instance = "constructor",
		},
	},
}
