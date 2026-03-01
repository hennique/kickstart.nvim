local linter_path = vim.fn.stdpath 'data' .. '/mason/packages/stylelint'
local linter_bin = vim.fn.stdpath 'data' .. '/mason/bin/stylelint'
local linter_config_preset = vim.fn.stdpath 'config' .. '/presets/linter/stylelint.txt'
local linter_config = linter_path .. '/stylelint.config.mjs'
local root_dir = vim.fs.root(0, { 'stylelint.config.mjs', 'stylelint.config.cjs', 'stylelint.config.js' })

if vim.fn.filereadable(linter_config) == 0 then
  vim.cmd.terminal {
    args = {
      'cd',
      linter_path,
      '&&',
      'npm add -D stylelint stylelint-config-standard',
      '&&',
      'touch',
      linter_config,
      '&&',
      'cat',
      linter_config_preset,
      '>',
      linter_config,
    },
  }
  vim.api.nvim_create_autocmd('BufEnter', {
    once = true,
    group = vim.api.nvim_create_augroup('linter-install', { clear = true }),
    pattern = '*.css',
    callback = function()
      if vim.bo.buftype == '' then vim.cmd 'e!' end
    end,
  })
end

if root_dir ~= nil then linter_config = vim.fn.glob(root_dir .. '/stylelint.config.*js') end

require('ale').setup {
  css_stylelint_use_global = 1,
  css_stylelint_executable = linter_bin,
  css_stylelint_options = '--config ' .. linter_config,
}
