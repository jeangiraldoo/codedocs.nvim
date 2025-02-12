local current_dir = "codedocs.tree_processor."
local item_data_retriever = require(current_dir .. "processor")[2]
local struct_finder = require(current_dir .. "struct_finder")
local node_constructor = require(current_dir .. "node_types")

return { item_data_retriever, struct_finder, node_constructor }
