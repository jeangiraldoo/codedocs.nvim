(return_statement
	(expression_list) @item_type
	(#set! parse_as_blank "true")) @return_statement (#has-ancestor? @return_statement function_declaration)
