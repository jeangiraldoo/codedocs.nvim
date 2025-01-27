local current_dir = "codedocs.docs_gen.styles.langs.kotlin.kdoc."
return {
	generic = require(current_dir .. "generic"),
	func = require(current_dir .. "func"),
	class = require(current_dir .. "class")
}
