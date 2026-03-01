local linter_path = vim.fn.stdpath 'data' .. '/mason/packages/eslint_d'
local linter_bin = vim.fn.stdpath 'data' .. '/mason/bin/eslint_d'
local linter_config_preset = vim.fn.stdpath 'config' .. '/presets/linter/eslintjs.txt'
local linter_config = linter_path .. '/eslint.config.mjs'
local root_dir = vim.fs.root(0, { 'eslint.config.mjs', 'eslint.config.cjs', 'eslint.config.js' })

if vim.fn.filereadable(linter_config) == 0 then
  vim.cmd.terminal {
    args = {
      'cd',
      linter_path,
      '&&',
      'npm install --save-dev --force eslint@latest @eslint/js@latest',
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
    pattern = '*.js',
    callback = function()
      if vim.bo.buftype == '' then vim.cmd 'e!' end
    end,
  })
end

-- If you want to temporarily use another linter supported by ALE that is in your project folder,
-- just change "eslint.config.*js" to the configuration file of that linter
if root_dir ~= nil then linter_config = vim.fn.glob(root_dir .. '/eslint.config.*js') end

require('ale').setup.buffer {
  -- You'll also need to replace these three variables according to your linter
  -- See :help ale-javascript-options
  -- and your linter's documentation
  javascript_eslint_use_global = 1,
  javascript_eslint_executable = linter_bin,
  javascript_eslint_options = '--config ' .. linter_config,
}
