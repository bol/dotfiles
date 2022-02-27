local use = require("packer").use

use 'rktjmp/lush.nvim'
use {'olimorris/onedarkpro.nvim',
  config = function()
    require('onedarkpro').load()
  end,
}

use {
  'nvim-lualine/lualine.nvim',
  requires = {'kyazdani42/nvim-web-devicons', opt = true},
  config = function()
    require'lualine'.setup()
  end,
}