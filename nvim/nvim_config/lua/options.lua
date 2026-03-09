-- Global options
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Default buffer options
vim.opt.autoindent = true
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 4 -- Size of an indent
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.softtabstop = 4 -- Number of spaces tabs count for
vim.opt.tabstop = 4 -- Number of spaces in a tab

-- Options
vim.opt.termguicolors = true
vim.opt.laststatus = 3 -- Use a single global statusline
vim.opt.mouse = "" -- Disable mouse
vim.opt.showmode = false -- Lualine shows the current mode
