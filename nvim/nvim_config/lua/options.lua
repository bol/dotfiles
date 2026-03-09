-- Global options
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

local state_root = vim.fn.stdpath('state')
local state_dirs = {
    backup = state_root .. '/backup',
    shada = state_root .. '/shada',
    swap = state_root .. '/swap',
    undo = state_root .. '/undo',
    view = state_root .. '/view',
}

for _, path in pairs(state_dirs) do
    vim.fn.mkdir(path, 'p')
end

-- Keep mutable editor artifacts out of tracked working trees.
vim.opt.backupdir = state_dirs.backup .. '//'
vim.opt.directory = state_dirs.swap .. '//'
vim.opt.shadafile = state_dirs.shada .. '/main.shada'
vim.opt.undodir = state_dirs.undo .. '//'
vim.opt.viewdir = state_dirs.view .. '//'

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
