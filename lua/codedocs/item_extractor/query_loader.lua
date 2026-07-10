local dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")

local Query_loader = {}

local query_cache = {}

function Query_loader.load(language, target_name, extractor_name, query_name)
	local cache_key = language .. ":" .. target_name .. ":" .. extractor_name .. ":" .. query_name

	if query_cache[cache_key] then return query_cache[cache_key] end

	local query_path = dir
		.. "/../config/languages/"
		.. language
		.. "/targets/"
		.. target_name
		.. "/"
		.. extractor_name
		.. "/queries/"
		.. query_name
		.. ".scm"

	if vim.fn.filereadable(query_path) ~= 1 then
		vim.notify("Could not find query file: " .. query_path, vim.log.levels.ERROR)
		return nil
	end

	local content = vim.fn.readfile(query_path)
	local query_string = table.concat(content, "\n")

	local ok, query = pcall(vim.treesitter.query.parse, language, query_string)

	if not ok then
		vim.notify("Failed to parse query from " .. query_path .. ": " .. tostring(query), vim.log.levels.ERROR)
		return nil
	end

	query_cache[cache_key] = query
	return query
end

return Query_loader
