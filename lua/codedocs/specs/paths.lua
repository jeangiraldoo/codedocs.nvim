local info = debug.getinfo(1, "S")
local current_file = info.source:sub(2)
local current_dir = current_file:match("^(.*)/")

local path_formats = {
	data = "codedocs.specs.langs.{lang_name}.init",
	dir = current_dir .. "/langs/{lang_name}/{struct_name}",
	struct_path = "langs.{lang_name}.{struct_name}",
	tree = "codedocs.specs.{struct_path}.tree",
	style = "codedocs.specs.{struct_path}.styles.{style_name}",
}

local function format_path(template, values) return (template:gsub("{(.-)}", values)) end

return {
	path_formats = path_formats,
	format_path = format_path,
}
