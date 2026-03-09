0=${${(M)${0::=${(%):-%x}}:#/*}:-$PWD/$0}

link_conf $1/nvim_config/init.lua ~/.config/nvim/init.lua
link_conf $1/nvim_config/lua ~/.config/nvim/lua
if [[ -L ~/.config/nvim/lazy-lock.json && ! -e ~/.config/nvim/lazy-lock.json ]]; then
  rm ~/.config/nvim/lazy-lock.json
fi
ensure_package_installed nvim neovim || return 1
ensure_package_installed tree-sitter tree-sitter-cli || return 1
echo -e "\tSyncing neovim plugins"
nvim --headless "+Lazy! sync" +qa
echo -e "\tInstalling treesitter parsers"
nvim --headless "+lua require('config.treesitter').install_sync()" +qa
