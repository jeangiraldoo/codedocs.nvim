local current_dir = "codedocs.docs_gen.styles.langs.java.javadoc."
return {
	comment = require(current_dir .. "comment"),
	func = require(current_dir .. "func"),
	class = require(current_dir .. "class")
}
