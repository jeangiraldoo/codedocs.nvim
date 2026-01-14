local Reader = require("codedocs.specs.reader")
local Customizer = require("codedocs.specs.customizer")

return {
	reader = Reader,
	customizer = Customizer.new(Reader),
}
