local function get_query(lang)
	return require("codedocs.struct_parser.queries." .. lang)
end

return {
	javascript = get_query("javascript"),
	typescript = get_query("typescript"),
	python = get_query("python"),
	java = get_query("java"),
	kotlin = get_query("kotlin"),
	php = get_query("php"),
	ruby = get_query("ruby"),
	lua = get_query("lua")
}
