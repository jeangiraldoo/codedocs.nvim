local function require_module(val)
	return require("codedocs.docs_gen.styles" .. val)
end

-- local opts = require("codedocs.builder.styles.opts")
local opts = require_module(".opts")
local style_manager = require_module(".manager")

local lang_styles = {
	-- python = require("codedocs.builder.styles.langs.python"),
	-- javascript = require("codedocs.builder.styles.langs.javascript"),
	-- lua = require("codedocs.builder.styles.langs.lua"),
	-- java = require("codedocs.builder.styles.langs.java"),
	-- typescript = require("codedocs.builder.styles.langs.typescript"),
	-- ruby = require("codedocs.builder.styles.langs.ruby"),
	-- php = require("codedocs.builder.styles.langs.php"),
	-- kotlin = require("codedocs.builder.styles.langs.kotlin"),
	-- rust = require("codedocs.builder.styles.langs.rust")

	python = require_module(".langs.python"),
	javascript = require_module(".langs.javascript"),
	lua = require_module(".langs.lua"),
	java = require_module(".langs.java"),
	typescript = require_module(".langs.typescript"),
	ruby = require_module(".langs.ruby"),
	php = require_module(".langs.php"),
	kotlin = require_module(".langs.kotlin"),
	rust = require_module(".langs.rust")
}

local default_styles = {
			python = "Google",
			javascript = "JSDoc",
			typescript = "TSDoc",
			lua = "LDoc",
			ruby = "YARD",
			php = "PHPDoc",
			java = "JavaDoc",
			kotlin = "KDoc",
			rust = "RustDoc"
			}

return {
	opts = opts,
	default_styles = default_styles,
	lang_styles = lang_styles,
	style_manager = style_manager
}
