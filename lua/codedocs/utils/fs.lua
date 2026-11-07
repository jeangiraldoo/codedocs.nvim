local M = {}

---@return string abs_path
function M.get_module_abs_path()
	local abs_path = vim.fn.fnamemodify(debug.getinfo(2, "S").source:sub(2), ":h")
	return abs_path
end

function M.path_to_module(fs_path)
	local lua_path = fs_path:gsub("/", ".")
	return lua_path
end

function M.module_to_path(lua_path)
	local fs_path = (lua_path:gsub("%.", "/"))
	return fs_path
end

M.PATHS = (function()
	local base = {
		ABS = {
			SOURCE_CODE = vim.fs.normalize(vim.fs.joinpath(M.get_module_abs_path(), "/../..")), -- codedocs.nvim/lua/
		},
		REL = {
			CONFIG = "codedocs/config",
		},
	}
	base.REL.LANGUAGES = vim.fs.joinpath(base.REL.CONFIG, "languages")

	for key, value in pairs(base.REL) do
		base.ABS[key] = vim.fs.joinpath(base.ABS.SOURCE_CODE, value)
	end

	return base
end)()

---@param rel_path string
---@return string[]
function M.read_dir_names(rel_path)
	vim.validate {
		path = { rel_path, "string" },
	}

	local abs_path = vim.fs.joinpath(M.PATHS.ABS.SOURCE_CODE, rel_path)

	return vim.iter(vim.fs.dir(abs_path))
		:map(function(name, type)
			if type == "directory" then return name end
		end)
		:totable()
end

function M.readfile(rel_path)
	local abs_path = vim.fs.joinpath(M.PATHS.ABS.SOURCE_CODE, rel_path)

	return vim.fn.readfile(abs_path)
end

---@param lua_paths string[]
---@return string lua_path
function M.joinmodule(lua_paths)
	local lua_path = vim.iter(lua_paths):fold("", function(acc, path) return acc .. "." .. path end)

	return lua_path
end

function M.build_dir_tbl(lua_path)
	local path = lua_path:gsub("%.", "/")

	local tbl = vim.iter(M.read_dir_names(path)):fold({}, function(acc, item_name)
		local dir_tbl = require(("%s.%s"):format(lua_path, item_name))

		acc[item_name] = dir_tbl

		return acc
	end)

	return tbl
end

function M.for_each_dir(rel_path, callback)
	local dirs = M.read_dir_names(rel_path)

	for _, dir_name in ipairs(dirs) do
		callback(dir_name)
	end
end

return M
