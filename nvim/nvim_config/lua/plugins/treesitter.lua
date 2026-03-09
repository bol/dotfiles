local treesitter = require('config.treesitter')

return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        config = function()
            treesitter.setup()
        end,
    },
}
