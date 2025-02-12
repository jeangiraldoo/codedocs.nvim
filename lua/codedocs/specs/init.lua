local current_dir = "codedocs.specs."

local spec_reader = require(current_dir .. "manager.reader")
local spec_customizer = require(current_dir .. "manager.customizer")

return { spec_reader, spec_customizer}
