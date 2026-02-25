local stylelint_path = vim.fn.stdpath 'data' .. '/mason/packages/stylelint'
local stylelint_bin = vim.fn.stdpath 'data' .. '/mason/bin/stylelint'
local stylelint_config = stylelint_path .. '/stylelint.config.mjs'

if vim.fn.filereadable(stylelint_config) == 0 then
  vim.cmd.terminal {
    args = {
      'cd',
      stylelint_path,
      '&&',
      'npm install create-stylelint',
      '&&',
      'echo y',
      '|',
      'npm create stylelint@latest',
      '&&',
      "sed -i 's/};//' ./stylelint.config.mjs",
      '&&',
      'echo \',"rules": {\n\n}\n};\' >> ./stylelint.config.mjs',
    },
  }
  vim.api.nvim_create_autocmd('BufEnter', {
    once = true,
    group = vim.api.nvim_create_augroup('css-install', { clear = true }),
    pattern = '*.css',
    command = 'e!',
  })
end

require('ale').setup.buffer {
  css_stylelint_use_global = 1,
  css_stylelint_executable = stylelint_bin,
  css_stylelint_options = '--config ' .. stylelint_config,
  fix_on_save = 1,

  linters = {
    css = { 'stylelint' },
  },
  fixers = {
    css = { 'trim_whitespace', 'remove_trailing_lines' },
  },
}
