local current_filepath = vim.api.nvim_buf_get_name(0)
local current_path = vim.fn.fnamemodify(current_filepath, ':p:h')
local stylelint_config_file = string.format('%s/stylelint.config.mjs', current_path)

if vim.fn.filereadable(stylelint_config_file) == 0 then
  local response = vim.fn.input "Stylelint's configuration not detected, install it? (y/N): "
  vim.cmd 'stopinsert'
  if response == 'n' or response == 'N' or response == '' then
    vim.api.nvim_buf_set_var(0, 'enable_linter', false)
    return
  end
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
  vim.cmd 'e!'
end
