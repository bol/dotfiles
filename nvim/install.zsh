0=${${(M)${0::=${(%):-%x}}:#/*}:-$PWD/$0}

link_conf $1/nvim_config ~/.config/nvim
git_clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
echo -e "\tSyncing neovim plugins"
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' 2> /dev/null
