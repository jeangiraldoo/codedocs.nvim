local Utils = {}

local _filetypes_map

function Utils._determine_lang_name()
	if not _filetypes_map then
		local langs_config = require("codedocs.config").opts.languages
		local filetypes_map = {}
		for lang_name, opts in pairs(langs_config) do
			for _, filetype_name in ipairs(opts.filetypes) do
				filetypes_map[filetype_name] = lang_name
			end
		end

		_filetypes_map = filetypes_map
	end

	return _filetypes_map[vim.bo.filetype]
end

return Utils
