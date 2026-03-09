
vim.go.packpath = vim.env.VIMRUNTIME

local modules = {
  'options',
  'config.lazy',
}

for _,module in ipairs(modules) do
    local ok,err = pcall(require, module)
    if not ok then
        error("Error loading " .. module .. ":\n"  .. err)
    end
end
