---@type CodedocsConfig
return {
	debug = false,
	languages = {
		bash = require "codedocs.config.languages.bash",
		c = require "codedocs.config.languages.c",
		cpp = require "codedocs.config.languages.cpp",
		go = require "codedocs.config.languages.go",
		java = require "codedocs.config.languages.java",
		kotlin = require "codedocs.config.languages.kotlin",
		javascript = require "codedocs.config.languages.javascript",
		typescript = require "codedocs.config.languages.typescript",
		python = require "codedocs.config.languages.python",
		ruby = require "codedocs.config.languages.ruby",
		php = require "codedocs.config.languages.php",
		lua = require "codedocs.config.languages.lua",
		rust = require "codedocs.config.languages.rust",
	},
	aliases = {
		sh = "bash",
	},
}
