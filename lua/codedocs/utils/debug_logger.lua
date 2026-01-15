local is_debug_mode_on = false

local Debug_logging = {}

function Debug_logging.log(msg, tbl)
	local log_msg = "[Codedocs Debug] " .. msg

	if tbl and type(tbl) == "table" then log_msg = string.format("%s %s", log_msg, vim.inspect(tbl)) end

	if is_debug_mode_on then vim.notify(log_msg, vim.log.levels.DEBUG) end
end

function Debug_logging.enable() is_debug_mode_on = true end

return Debug_logging
