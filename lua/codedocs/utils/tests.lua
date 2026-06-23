local Test_utils = {}

function Test_utils.parse_golden_file(lines)
	local marker = "<CURSOR>"
	local cleaned = vim.deepcopy(lines)

	for row, line in ipairs(cleaned) do
		local start_col = line:find(marker, 1, true)

		if start_col then
			cleaned[row] = line:gsub(vim.pesc(marker), "", 1)

			return { row = row, col = start_col }, cleaned
		end
	end

	return nil, cleaned
end

return Test_utils
