0=${${(M)${0::=${(%):-%x}}:#/*}:-$PWD/$0}

link_conf $1/nvim_config/init.lua ~/.config/nvim/init.lua
link_conf $1/nvim_config/lazy-lock.json ~/.config/nvim/lazy-lock.json
link_conf $1/nvim_config/lua ~/.config/nvim/lua
ensure_package_installed nvim neovim || return 1
ensure_package_installed tree-sitter tree-sitter-cli || return 1
echo -e "\tRestoring neovim plugins from lockfile"
nvim --headless "+Lazy! restore" +qa
echo -e "\tInstalling treesitter parsers"
nvim --headless "+lua require('config.treesitter').install_sync()" +qa
