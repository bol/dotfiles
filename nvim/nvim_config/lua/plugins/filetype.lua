local use = require("packer").use

use {
  'nathom/filetype.nvim',
  config = function()
    require('filetype').setup({})
  end
}
