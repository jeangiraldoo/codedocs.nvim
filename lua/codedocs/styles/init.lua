local opts = require("codedocs.styles.opts")

local lang_styles = {
	python = require("codedocs.styles.langs.python"),
	javascript = require("codedocs.styles.langs.javascript"),
	lua = require("codedocs.styles.langs.lua"),
	java = require("codedocs.styles.langs.java"),
	typescript = require("codedocs.styles.langs.typescript"),
	ruby = require("codedocs.styles.langs.ruby"),
	php = require("codedocs.styles.langs.php"),
	kotlin = require("codedocs.styles.langs.kotlin"),
	rust = require("codedocs.styles.langs.rust")
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
	opts,
	default_styles,
	lang_styles
}
