local fs_utils = {}

---@return string abs_path
function fs_utils.get_module_abs_path()
	local abs_path = vim.fn.fnamemodify(debug.getinfo(2, "S").source:sub(2), ":h")
	return abs_path
end

function fs_utils.path_to_module(fs_path)
	local lua_path = fs_path:gsub("/", ".")
	return lua_path
end

function fs_utils.module_to_path(lua_path)
	local fs_path = (lua_path:gsub("%.", "/"))
	return fs_path
end

fs_utils.PATHS = (function()
	local base = {
		ABS = {
			SOURCE_CODE = vim.fs.normalize(vim.fs.joinpath(fs_utils.get_module_abs_path(), "/../..")), -- codedocs.nvim/lua/
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
function fs_utils.read_dir_names(rel_path)
	vim.validate {
		path = { rel_path, "string" },
	}

	local abs_path = vim.fs.joinpath(fs_utils.PATHS.ABS.SOURCE_CODE, rel_path)

	return vim.iter(vim.fs.dir(abs_path))
		:map(function(name, type)
			if type == "directory" then return name end
		end)
		:totable()
end

function fs_utils.readfile(rel_path)
	local abs_path = vim.fs.joinpath(fs_utils.PATHS.ABS.SOURCE_CODE, rel_path)

	return vim.fn.readfile(abs_path)
end

---@param lua_paths string[]
---@return string lua_path
function fs_utils.joinmodule(lua_paths)
	local lua_path = vim.iter(lua_paths):fold("", function(acc, path) return acc .. "." .. path end)

	return lua_path
end

function fs_utils.build_dir_tbl(lua_path)
	local path = lua_path:gsub("%.", "/")

	local tbl = vim.iter(fs_utils.read_dir_names(path)):fold({}, function(acc, item_name)
		local dir_tbl = require(("%s.%s"):format(lua_path, item_name))

		acc[item_name] = dir_tbl

		return acc
	end)

	return tbl
end

function fs_utils.for_each_dir(rel_path, callback)
	local dirs = fs_utils.read_dir_names(rel_path)

	for _, dir_name in ipairs(dirs) do
		callback(dir_name)
	end
end

return fs_utils
