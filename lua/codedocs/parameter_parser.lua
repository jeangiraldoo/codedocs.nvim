local function get_args(line, func_keyword)
	if line and string.match(line, func_keyword) then
		local string_in_parenthesis = string.match(line, "%((.-)%)")
		return vim.split(string_in_parenthesis, ", ")
	else
		return nil
	end
end

local function insert_args(args, leader, before_arg)
	local total_lines_used = 0
	if leader == "" then
		total_lines_used = total_lines_used + 1
	else
		total_lines_used = total_lines_used + 2
	end
	vim.api.nvim_input("<CR><CR>" .. leader)

	for idx, value in pairs(args) do
		vim.api.nvim_input(before_arg .. value)
		if idx ~= #args then
			total_lines_used = total_lines_used + 1
			vim.api.nvim_input("<CR>")
		else
			for i = 0, total_lines_used do
				vim.api.nvim_input("<Up>")
			end
		end
	end
end

local function start_arg_insertion(line, lang_details)
	print("args")
	local func_keyword = lang_details["func"]
	local detected_line_args = get_args(line, func_keyword)
	if detected_line_args then
		insert_args(detected_line_args, lang_details["leader"], lang_details["before_arg"])
	end
end

return {
	start_arg_insertion = start_arg_insertion
}
