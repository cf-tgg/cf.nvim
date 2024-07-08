-- local lspconfig = require('lspconfig')
--
require('java').setup()
--
-- lspconfig.jdtls.setup({
-- 	cmd = { 'jdtls' },
-- 	capabilities = {
-- 		hover = true,
-- 	},
-- })
--
-- Ensure the lua file for lsp is loaded correctly
local M = {}

function M.setup()
	-- Ensure the lua file for lsp is loaded correctly
	local lspconfig = require('lspconfig')
	local mason = require('mason')
	local mason_lspconfig = require('mason-lspconfig')

	-- Setup mason
	mason.setup()
	mason_lspconfig.setup {
		ensure_installed = { 'jdtls' }
	}

	-- Configure jdtls
	local home = os.getenv('HOME')
	local workspace_path = home .. "/workspace/"
	local config = {
		cmd = {
			'java', -- Or the path to the java executable if it is not in your PATH.
			'-Declipse.application=org.eclipse.jdt.ls.core.id1',
			'-Dosgi.bundles.defaultStartLevel=4',
			'-Declipse.product=org.eclipse.jdt.ls.core.product',
			'-Dlog.protocol=true',
			'-Dlog.level=ALL',
			'-Xms1g',
			'--add-modules=ALL-SYSTEM',
			'--add-opens', 'java.base/java.util=ALL-UNNAMED',
			'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
			'-jar', home ..
		'/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
			'-configuration', home .. '/.local/share/nvim/mason/packages/jdtls/config_linux',
			'-data', workspace_path
		},
		root_dir = function(fname)
			return lspconfig.util.root_pattern('pom.xml', 'build.gradle', '.git')(fname) or
				lspconfig.util.path.dirname(fname)
		end,
		settings = {
			java = {
				eclipse = {
					downloadSources = true
				},
				configuration = {
					updateBuildConfiguration = "interactive"
				},
				maven = {
					downloadSources = true
				},
				implementationsCodeLens = {
					enabled = true
				},
				referencesCodeLens = {
					enabled = true
				},
				references = {
					includeDecompiledSources = true
				},
				format = {
					enabled = true
				}
			}
		},
		flags = {
			debounce_text_changes = 80
		},
		init_options = {
			bundles = {}
		},
		on_attach = function(_, bufnr) -- Remove `client` since it's not used
			local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
			local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

			buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

			-- Mappings.
			local opts = { noremap = true, silent = true }

			-- See `:help vim.lsp.*` for documentation on any of the below functions
			buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
			buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
			buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
			buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
			buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
			buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
			buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
			buf_set_keymap('n', '<leader>wl', '<cmd>lua vim.lsp.buf.list_workspace_folders()<CR>', opts)
			buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
			buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
			buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
			buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
			buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
			buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
			buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
			buf_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
			buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.format{ async = true }<CR>', opts)
		end
	}

	-- Finally, start the server
	lspconfig.jdtls.setup(config)
end

return M
