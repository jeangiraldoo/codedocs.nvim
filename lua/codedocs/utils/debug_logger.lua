local Debug_logging = {}

function Debug_logging.log(msg, tbl)
	vim.validate {
		msg = { msg, "string" },
		tbl = { tbl, { "table", "nil" } },
	}

	if not require("codedocs.config").debug then return end

	local log_msg = "[Codedocs Debug] " .. msg

	if tbl and type(tbl) == "table" then log_msg = string.format("%s %s", log_msg, vim.inspect(tbl)) end

	vim.notify(log_msg, vim.log.levels.DEBUG)
end

return Debug_logging
