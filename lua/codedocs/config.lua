---@type CodedocsConfig
return {
	debug = false,
	languages = {
		bash = require "codedocs.lang_specs.bash",
		c = require "codedocs.lang_specs.c",
		cpp = require "codedocs.lang_specs.cpp",
		go = require "codedocs.lang_specs.go",
		java = require "codedocs.lang_specs.java",
		kotlin = require "codedocs.lang_specs.kotlin",
		javascript = require "codedocs.lang_specs.javascript",
		typescript = require "codedocs.lang_specs.typescript",
		python = require "codedocs.lang_specs.python",
		ruby = require "codedocs.lang_specs.ruby",
		php = require "codedocs.lang_specs.php",
		lua = require "codedocs.lang_specs.lua",
		rust = require "codedocs.lang_specs.rust",
	},
}
