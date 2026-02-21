local current_filepath = vim.api.nvim_buf_get_name(0)
local current_path = vim.fn.fnamemodify(current_filepath, ':p:h')
local stylelint_config_file = string.format('%s/stylelint.config.mjs', current_path)

if vim.fn.filereadable(stylelint_config_file) == 0 then
  vim.cmd.terminal { args = { 'touch', stylelint_config_file } }
  vim.cmd.terminal {
    args = {
      'echo',
      "\"/** @type {import('stylelint').Config} */\nexport default {\nextends: ['stylelint-config-standard']\n};\"",
      '>',
      stylelint_config_file,
    },
  }
  vim.cmd.terminal { args = { 'npm', 'add', '--prefix', current_path, '-D', 'stylelint', 'stylelint-config-standard' } }
  vim.cmd.e { args = { current_filepath } }
end

local stylelint_group = vim.api.nvim_create_augroup('stylelint-fix-on-save', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = stylelint_group,
  callback = function()
    local stylelint_bin = vim.fn.stdpath 'data' .. '/mason/packages/stylelint/node_modules/stylelint/bin/stylelint.mjs'

    vim.system { stylelint_bin, '--fix', current_path }
    vim.cmd 'e!'
  end,
})
