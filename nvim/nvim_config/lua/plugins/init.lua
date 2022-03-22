local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  local plugins = {
    'plugins.filetype',
    'plugins.theme',
    'plugins.treesitter',
  }

  for _,plugin in ipairs(plugins) do
      local ok,err = pcall(require, plugin)
      if not ok then
          error("Error loading " .. plugin .. ":\n"  .. err)
      end
  end

  if packer_bootstrap then
    require('packer').sync()
  end
end)