local PLUGIN_PATH = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h") .. "/../.."

local Utils = {}

function Utils.build_dir_tbl(lua_path)
	local path = lua_path:gsub("%.", "/")

	local fs_path = vim.fs.joinpath(PLUGIN_PATH, path)

	local dirs = vim.fs.dir(fs_path)

	local tbl = vim.iter(dirs):fold({}, function(acc, item_name, item_type)
		if item_type ~= "directory" then return acc end

		local dir_tbl = require(("%s.%s"):format(lua_path, item_name))

		acc[item_name] = dir_tbl

		return acc
	end)

	return tbl
end

return Utils
