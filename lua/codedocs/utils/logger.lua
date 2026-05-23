local Logger = {}

local LEVELS_LABELS = {
	[vim.log.levels.DEBUG] = "DEBUG",
	[vim.log.levels.ERROR] = "ERROR",
	[vim.log.levels.TRACE] = "TRACE",
	[vim.log.levels.WARN] = "WARN",
	[vim.log.levels.INFO] = "INFO",
}

---@param msg string
---@param level number
local function _log(msg, level)
	vim.validate {
		msg = { msg, "string" },
		level = { level, "number" },
	}

	local config = require("codedocs.config").logging
	if level < config.level then return end

	local path = vim.fs.normalize(config.path)
	local target_dir = vim.fs.dirname(path)

	local dir_stats = vim.uv.fs_stat(target_dir)
	if not dir_stats then
		vim.notify_once("[Codedocs] " .. target_dir .. " does not exist")
		return
	end

	local fd = vim.uv.fs_open(path, "a", 420)

	local timestamp = os.date "%Y-%m-%d %H:%M:%S"
	local entry = ("[%s][%s] %s\n"):format(LEVELS_LABELS[level], timestamp, msg)

	vim.uv.fs_write(fd, entry, -1)
	vim.uv.fs_close(fd)
end

---@param msg string
function Logger.info(msg) _log(msg, vim.log.levels.INFO) end

---@param msg string
function Logger.debug(msg) _log(msg, vim.log.levels.DEBUG) end

---@param msg string
function Logger.warn(msg) _log(msg, vim.log.levels.WARN) end

---@param msg string
function Logger.trace(msg) _log(msg, vim.log.levels.TRACE) end

---@param msg string
function Logger.error(msg) _log(msg, vim.log.levels.ERROR) end

return Logger
