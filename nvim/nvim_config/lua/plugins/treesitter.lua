local use = require("packer").use

use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
}

require 'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "css",
        "diff",
        "dockerfile",
        "gitattributes",
        "go",
        "gomod",
        "hcl",
        "html",
        "json",
        "make",
        "markdown",
        "rst",
        "terraform",
        "toml",
        "vim",
        "yaml",
    },
    sync_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}
