0=${${(M)${0::=${(%):-%x}}:#/*}:-$PWD/$0}

link_conf $1/nvim_config/init.lua ~/.config/nvim/init.lua
link_conf $1/nvim_config/lua ~/.config/nvim/lua
git_clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
echo -e "\tSyncing neovim plugins"
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
