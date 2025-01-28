local current_dir = "codedocs.docs_gen.styles.langs.typescript.tsdoc."

return {
	comment = require(current_dir .. "comment"),
	func = require(current_dir .. "func"),
	class = require(current_dir .. "class")
}
