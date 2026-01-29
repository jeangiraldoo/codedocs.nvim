local Health = {}

local NEOVIM_VERSION = {
	MINIMUM = "0.10",
	ACTUAL = vim.version(),
}

local function _check_neovim_version()
	vim.health.start("Neovim version")

	local version_str = string.format(
		"%d.%d.%d (Minimum: %s)",
		NEOVIM_VERSION.ACTUAL.major,
		NEOVIM_VERSION.ACTUAL.minor,
		NEOVIM_VERSION.ACTUAL.patch,
		NEOVIM_VERSION.MINIMUM
	)

	if vim.fn.has("nvim-" .. NEOVIM_VERSION.MINIMUM) == 0 then
		vim.health.error(version_str)
		return
	end

	vim.health.ok(version_str)
end

local function _show_annotable_languages()
	vim.health.start("Annotable languages (Treesitter parser detected)")

	local Specs = require("codedocs.specs")
	local PLUGIN_SUPPORTED_LANGS = Specs.get_supported_langs()

	for _, lang_name in ipairs(PLUGIN_SUPPORTED_LANGS) do
		local result, _ = pcall(vim.treesitter.get_parser, 0, lang_name)

		if result then vim.health.info(lang_name) end
	end
end

function Health.check()
	_check_neovim_version()
	_show_annotable_languages()
end

return Health
