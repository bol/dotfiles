local M = {}

M.install_dir = vim.fn.stdpath('data') .. '/treesitter-parsers'

M.parsers = {
    'bash',
    'c',
    'cmake',
    'cpp',
    'css',
    'diff',
    'dockerfile',
    'gitattributes',
    'go',
    'gomod',
    'hcl',
    'html',
    'json',
    'lua',
    'make',
    'markdown',
    'markdown_inline',
    'rst',
    'terraform',
    'toml',
    'vim',
    'yaml',
}

local function ensure_runtime_path()
    if not vim.tbl_contains(vim.opt.runtimepath:get(), M.install_dir) then
        vim.opt.runtimepath:append(M.install_dir)
    end
end

function M.setup()
    ensure_runtime_path()

    require('nvim-treesitter').setup({
        install_dir = M.install_dir,
    })

    local group = vim.api.nvim_create_augroup('dotfiles-treesitter', {clear = true})

    vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = '*',
        callback = function(args)
            if vim.bo[args.buf].buftype ~= '' then
                return
            end

            pcall(vim.treesitter.start, args.buf)
        end,
    })
end

function M.install_sync()
    vim.fn.mkdir(M.install_dir, 'p')
    M.setup()

    local treesitter = require('nvim-treesitter')

    treesitter.install(M.parsers, {summary = true}):wait(300000)
    treesitter.update(M.parsers, {summary = true}):wait(300000)
end

return M
