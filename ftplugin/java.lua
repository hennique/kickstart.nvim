-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

-- This is the location where eclipse.jdt.ls stores index data for each project it loads
local workspace_dir = os.getenv 'HOME' .. '/.cache/jdtls/workspace/' .. project_name

local configuration_dir = vim.fn.stdpath 'data' .. '/mason/packages/jdtls/config_linux/'
local root_dir = vim.fs.root(0, { 'gradlew', 'gradle.properties' })

local jar_file = vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar')
local lombok_jar = vim.fn.stdpath 'data' .. '/mason/packages/jdtls/lombok.jar'
local jdtls_bin = vim.fn.stdpath 'data' .. '/mason/packages/jdtls/bin/jdtls'

local status, jdtls = pcall(require, 'jdtls')
if not status then return end
local extendedClientCapabilities = jdtls.extendedClientCapabilities

-- See `:help vim.lsp.start` for an overview of the supported `config` options.
local config = {
  name = 'jdtls',

  -- `cmd` defines the executable to launch eclipse.jdt.ls.
  cmd = {
    jdtls_bin,
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1G',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:' .. lombok_jar,
    '-jar',
    jar_file,
    '-configuration',
    configuration_dir,
    '-data',
    workspace_dir,
  },

  setting = {
    java = {
      signatureHelp = { enabled = true },
      extendedClientCapabilities = extendedClientCapabilities,
    },
  },

  -- `root_dir` must point to the root of your project.
  -- See `:help vim.fs.root`
  root_dir = root_dir,
}
require('jdtls').start_or_attach(config)
