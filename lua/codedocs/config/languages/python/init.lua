local Class_extractors = {}

function Class_extractors.attributes(target_data)
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

local Func_extractors = {}

function Func_extractors.parameters(target_data)
	return target_data.lang_query_parser [[
		(parameters
			[
				(typed_parameter
					(identifier) @item_name
					(#not-eq? @item_name "self")
					(type) @item_type)
				(identifier) @item_name (#not-eq? @item_name "self")
			])
	]]
end

function Func_extractors.returns(target_data)
	local items = target_data.lang_query_parser [[
		(function_definition
			return_type: (type
				[
					(identifier)
					(generic_type (identifier))
					(binary_operator)
				] @item_type (#not-eq? @item_type "None")))
	]]

	if #items > 0 then return items end

	return target_data.lang_query_parser [[
		(return_statement
			(_) @item_type
			(#set! parse_as_blank "true"))
	]]
end

---@alias CodedocsPythonStyleNames
---| "Google"
---| "Numpy"
---| "reST"

---@alias CodedocsPythonStructNames
---| "class"
---| "func"
---| "comment"

---@class CodedocsPythonConfig: CodedocsLanguageConfig
---@field default_style CodedocsPythonStyleNames
---@field styles table<CodedocsPythonStyleNames, table<CodedocsPythonStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsPythonConfig
return {
	default_style = "reST",
	styles = {
		Google = require "codedocs.config.languages.python.Google",
		Numpy = require "codedocs.config.languages.python.Numpy",
		reST = require "codedocs.config.languages.python.reST",
	},
	targets = {
		func = {
			node_identifiers = {
				"function_definition",
			},
			extractors = Func_extractors,
		},
		class = {
			node_identifiers = {
				"class_definition",
			},
			extractors = Class_extractors,
			opts = {
				attributes = {
					static = true,
					instance = "constructor",
				},
			},
		},
	},
}
