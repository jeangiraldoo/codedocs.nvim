local Class_extractors = {}

function Class_extractors.attributes(struct_data)
	local settings = struct_data.style.settings.item_extraction.attributes
	local results = {}

	if settings.static then
		local class_attrs = struct_data.lang_query_parser [[
			(class_definition
				body: (block
					(expression_statement
						(assignment
							left: (_) @item_name))))
		]]
		vim.list_extend(results, class_attrs)
	end

	if settings.instance == "constructor" then
		local constructor_node = struct_data.lang_query_parser([[
						(function_definition
							name: (identifier) @func_name
							(#eq? @func_name "__init__")) @target
					]])[1]

		if constructor_node then
			local constructor_instance_attrs = struct_data.generic_query_parser(
				constructor_node,
				struct_data.lang_name,
				[[
						(attribute
							(identifier) @item_name (#not-eq? @item_name "self"))
					]]
			)
			vim.list_extend(results, constructor_instance_attrs)

			return results
		end
	end

	if settings.instance == "all" then
		local all_instance_attrs = struct_data.lang_query_parser [[
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

local Func_extractors = {}

function Func_extractors.parameters(struct_data)
	return struct_data.lang_query_parser [[
		(function_definition
			(parameters
				[
					(typed_parameter
						(identifier) @item_name
						(#not-eq? @item_name "self")
						(type) @item_type)
					(identifier) @item_name (#not-eq? @item_name "self")
				]))
	]]
end

function Func_extractors.returns(struct_data)
	local items = struct_data.lang_query_parser [[
		(function_definition
			return_type: (type
				(identifier) @item_type (#not-eq? @item_type "None")))
	]]

	if #items > 0 then return items end

	return struct_data.lang_query_parser [[
		(return_statement
			(_) @item_type
			(#set! parse_as_blank "true"))
	]]
end

return {
	lang_name = "python",
	default_style = "reST",
	identifier_pos = true,
	supported_styles = {
		"Google",
		"Numpy",
		"reST",
	},
	styles = {
		definitions = {
			func = require "codedocs.lang_specs.python.styles.func",
			comment = require "codedocs.lang_specs.python.styles.comment",
			class = require "codedocs.lang_specs.python.styles.class",
		},
	},
	extraction = {
		struct_identifiers = {
			function_definition = "func",
			class_definition = "class",
		},
		extractors = {
			class = Class_extractors,
			func = Func_extractors,
		},
	},
}
