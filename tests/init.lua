local root = vim.fn.getcwd()

vim.opt.runtimepath:prepend(root) -- Necessary so that the language queries are available when tests run
