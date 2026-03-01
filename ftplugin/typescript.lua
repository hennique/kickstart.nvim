local linter_path = vim.fn.stdpath 'data' .. '/mason/packages/eslint_d'
local linter_bin = vim.fn.stdpath 'data' .. '/mason/bin/eslint_d'
local linter_config_preset = vim.fn.stdpath 'config' .. '/presets/linter/eslintts.txt'
local linter_config = linter_path .. '/eslint.config.mts'
local root_dir = vim.fs.root(0, { 'eslint.config.mts', 'eslint.config.cts', 'eslint.config.ts' })

if vim.fn.filereadable(linter_config) == 0 then
  vim.cmd.terminal {
    args = {
      'cd',
      linter_path,
      '&&',
      'npm install --save-dev --force eslint@latest @eslint/js@latest typescript typescript-eslint',
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
    pattern = '*.ts',
    callback = function()
      if vim.bo.buftype == '' then vim.cmd 'e!' end
    end,
  })
end

if root_dir ~= nil then linter_config = vim.fn.glob(root_dir .. '/eslint.config.*ts') end

require('ale').setup.buffer {
  javascript_eslint_use_global = 1,
  javascript_eslint_executable = linter_bin,
  javascript_eslint_options = '--flag unstable_native_nodejs_ts_config --config ' .. linter_config,
}
