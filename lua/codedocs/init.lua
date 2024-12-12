local default_templates = require("codedocs.lua.codedocs.languages")
local insert_docs = require("codedocs.lua.codedocs.insert_docs")

local M = {}

function M.setup()
    print("Codedocs has been set up!")
end

function M.insert_docs()
	insert_docs.insert_docs(default_templates)
end

return M
