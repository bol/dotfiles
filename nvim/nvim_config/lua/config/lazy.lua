local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        '--branch=stable',
        lazyrepo,
        lazypath,
    })

    if vim.v.shell_error ~= 0 then
        error('Failed to clone lazy.nvim:\n' .. out)
    end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins', {
    local_spec = false,
    lockfile = vim.fn.stdpath('state') .. '/lazy/lazy-lock.json',
    install = {
        colorscheme = {'selenized'},
    },
    pkg = {
        sources = {'lazy'},
    },
    rocks = {
        enabled = false,
    },
    checker = {
        enabled = false,
    },
    change_detection = {
        notify = false,
    },
})
