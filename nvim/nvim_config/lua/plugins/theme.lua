local use = require("packer").use

use {'jan-warchol/selenized',
     rtp = 'editors/vim',
     config = function()
         vim.o.background = 'dark'
         vim.cmd('colorscheme selenized')
     end,
}

use {
    'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
        require'lualine'.setup()
    end,
}
