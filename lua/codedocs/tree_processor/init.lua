local current_dir = "codedocs.tree_processor."
local item_data_retriever = require(current_dir .. "processor")
local struct_finder = require(current_dir .. "struct_finder")

return { item_data_retriever, struct_finder }
