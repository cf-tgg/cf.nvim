vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath,
	}
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup({

	-- Harpoon Navigation
	'ThePrimeagen/harpoon',

	-- Git related plugins
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',
	'mbbill/undotree',

	-- surround mappings
	'tpope/vim-surround',
	-- path management
	'tpope/vim-pathogen',

	-- Detect tabstop and shiftwidth automatically
	'tpope/vim-sleuth',
	'ap/vim-css-color',

	{
		'turbio/bracey.vim',
		build = 'npm install --prefix server'
	},
	{
		'goolord/alpha-nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require 'alpha'.setup(require 'alpha.themes.startify'.config)
		end
	},
	{
		-- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ 'williamboman/mason.nvim', config = true },
			'williamboman/mason-lspconfig.nvim',

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ 'j-hui/fidget.nvim',       opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			'folke/neodev.nvim',
		},
	},
	-- Useful plugin to show you pending keybinds.
	{ 'folke/which-key.nvim',  opts = {} },
	{
		"folke/trouble.nvim",
		branch = "dev", -- IMPORTANT!
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
		opts = {}, -- for default options, refer to the configuration section for custom setup.
	},
	{
		-- Adds git related signs to the gutter, as well as utilities for managing changes
		'lewis6991/gitsigns.nvim',
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map({ 'n', 'v' }, ']c', function()
					if vim.wo.diff then
						return ']c'
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return '<Ignore>'
				end, { expr = true, desc = 'Jump to next hunk' })

				map({ 'n', 'v' }, '[c', function()
					if vim.wo.diff then
						return '[c'
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return '<Ignore>'
				end, { expr = true, desc = 'Jump to previous hunk' })

				-- Actions
				-- visual mode
				map('v', '<leader>hs', function()
					gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
				end, { desc = 'stage git hunk' })
				map('v', '<leader>hr', function()
					gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
				end, { desc = 'reset git hunk' })
				-- normal mode
				map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
				map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
				map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
				map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
				map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
				map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
				map('n', '<leader>hb', function()
					gs.blame_line { full = false }
				end, { desc = 'git blame line' })
				map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
				map('n', '<leader>hD', function()
					gs.diffthis '~'
				end, { desc = 'git diff against last commit' })

				-- Toggles
				map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
				map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })

				-- Text object
				map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
			end,
		},
	},

	{
		-- 'navarasu/onedark.nvim',
		'rose-pine/neovim',
		priority = 1000,
		config = function()
			vim.cmd.colorscheme 'rose-pine'
			-- vim.cmd.colorscheme 'onedark'
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalNC", { bg = "None" })
			vim.api.nvim_set_hl(0, "WinSeparator", { bg = "None" })
			vim.api.nvim_set_hl(0, "CursorLine", { bg = "#0c0d0f" })
			vim.api.nvim_set_hl(0, "StatusLine", { bg = "#0c0d0f" })
			vim.api.nvim_set_hl(0, "TabLine", { bg = "None" })
			vim.api.nvim_set_hl(0, "TabLineFill", { bg = "None" })
			vim.api.nvim_set_hl(0, "TabLineSel", { bg = "#0c0d0f" })
			vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "None" })
			vim.api.nvim_set_hl(0, "FloatBorder", { bg = "None" })
		end,
	},
	{
		-- 'tjdevries/express_line.nvim',
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = true,
				theme = 'rose-pine',
				component_separators = '',
				section_separators = '',
				opts = {},
			},
		},
	},

	{
		-- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		main = 'ibl',
		opts = {
			indent = { char = "¦" },
		},
	},

	-- "gc" to comment visual regions/lines
	{ 'numToStr/Comment.nvim', opts = {} },

	-- Fuzzy Finder (files, lsp, etc)
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			-- Fuzzy Finder Algorithm which requires local dependencies to be built.
			-- Only load if `make` is available. Make sure you have the system
			-- requirements installed.
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				-- NOTE: If you are having trouble with this installation,
				--       refer to the README for telescope-fzf-native for more instructions.
				build = 'make',
				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			},
		},
	},

	{
		-- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
	},

	{
		'nvim-treesitter/playground',
	},
	{
		'nvim-orgmode/orgmode',
		event = 'VeryLazy',
		ft = { 'org' },
		config = function()
			-- Setup orgmode
			require('orgmode').setup({
				org_agenda_files = '~/Notes/orgfiles/**/*',
				org_default_notes_file = '~/Notes/orgfiles/refile.org',
			})

			-- NOTE: If you are using nvim-treesitter with `ensure_installed = "all"` option
			-- add `org` to ignore_install
			-- require('nvim-treesitter.configs').setup({
			--   ensure_installed = 'all',
			--   ignore_install = { 'org' },
			-- })
		end,
	},
	{
		"chipsenkbeil/org-roam.nvim",
		tag = "0.1.0",
		dependencies = {
			{
				"nvim-orgmode/orgmode",
				tag = "0.3.4",
			},
		},
		config = function()
			require("org-roam").setup({
				directory = "~/Notes/orgfiles",
			})
		end
	},

	{
		'nvim-java/nvim-java',
		dependencies = {
			'nvim-java/lua-async-await',
			'nvim-java/nvim-java-refactor',
			'nvim-java/nvim-java-core',
			'nvim-java/nvim-java-test',
			'nvim-java/nvim-java-dap',
			'MunifTanjim/nui.nvim',
			'neovim/nvim-lspconfig',
			'mfussenegger/nvim-dap',
			{
				'williamboman/mason.nvim',
				opts = {
					registries = {
						'github:nvim-java/mason-registry',
						'github:mason-org/mason-registry',
					},
				},
			}
		},
	},
	require 'plugins.autoformat',
	require 'plugins.debug',
	-- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	--    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
	--    up-to-date with whatever is in the kickstart repo.
	--    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
	--
	--    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
	{ import = 'custom.plugins' },
}, {})

require('java').setup()
require('lspconfig').jdtls.setup({
	cmd = { 'jdtls' },
	capabilities = {
		hover = true,
	},
})


-- [[ Setting options ]]

vim.g.have_nerd_font = true

-- Splits transparency beauty
-- vim.cmd('highlight NormalNC guibg=None')
-- vim.cmd('highlight WinSeparator guibg=None')
-- vim.cmd('highlight CursorLine guibg=#0c0d0f')
-- vim.cmd('highlight StatusLine guibg=#0c0d0f')
-- vim.cmd('highlight TabLine guibg=None')
-- vim.cmd('highlight TabLineSel guibg=#0c0d0f')
-- vim.cmd('highlight TabLineFill guibg=None')
-- vim.cmd('highlight TelescopeBorder guibg=None')


vim.o.laststatus = 3
vim.opt.showmode = false


-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.opt.inccommand = "split"
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.o.incsearch = true

-- vim.o.cmdheight = 0
vim.o.number = true
vim.o.relativenumber = true

vim.o.cursorline = true
vim.o.breakindent = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = false
vim.o.wrap = false

-- vim.o.swapfile = false
-- vim.o.backup = false
-- vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true

vim.o.scrolloff = 8

vim.o.mouse = 'a'

vim.o.clipboard = 'unnamedplus'

vim.o.ignorecase = true
vim.o.smartcase = true

vim.wo.signcolumn = 'yes'

vim.o.updatetime = 50
vim.o.timeoutlen = 300

vim.o.completeopt = 'menuone,noselect'

vim.o.termguicolors = true
-- vim.o.colorcolumn = 80

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '۰', nbsp = '˽', eol = '↵' }

-- [[ Keymaps ]]
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set({ 'n', 'v' }, 'Space', 'Nop', { silent = true })

-- Tab Navigation
vim.keymap.set('n', '<C-t>', ":tabnew<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<C-i>', ":tabnext<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<s-tab>', ":tabprev<CR>", { noremap = true, silent = true })
vim.keymap.set('n', ',t', ":tabnew<CR>:terminal<CR>A", { noremap = true, silent = true })

-- vim.keymap.set('n', '<C-h>', ":tabnew % <CR>", { noremap = true, silent = true })


-- Move selection up and down
vim.keymap.set('v', '<C-k>', ":move \'<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', '<C-j>', ":move \'>+1<CR>gv=gv", { noremap = true, silent = true })

-- Increment / Decrement
vim.keymap.set('n', '+', '<C-a>')
vim.keymap.set('n', '-', '<C-x>')

-- Select all
vim.keymap.set('n', '<C-a>', "gg<S-v>G")

-- Split windows
vim.keymap.set('n', ',s', ":split<CR>")
vim.keymap.set('n', ',v', ":vsplit<CR>")

-- Move splits
vim.keymap.set('n', '<c-l>', "<c-w><c-l>", { desc = "Move focus to the right window" })
vim.keymap.set('n', '<c-k>', "<c-w>k", { desc = "Move focus to the top window" })
vim.keymap.set('n', '<c-j>', "<c-w>j", { desc = "Move focus to the bottom window" })
vim.keymap.set('n', '<c-h>', "<c-w><c-h>", { desc = "Move focus to the left window" })

-- Resize splits
vim.keymap.set("n", "<M-,>", "<C-w>5<")
vim.keymap.set("n", "<M-.>", "<C-w>5>")
vim.keymap.set("n", "<M-t>", "<C-w>2+")
vim.keymap.set("n", "<M-f>", "<C-w>2-")

vim.keymap.set('n', ',w', 'viWy:!qutebrowser <C-R>"<CR><CR>')
vim.keymap.set('v', ',w', 'y:!qutebrowser <C-R>"<CR><CR>')

-- Centered page Up / Down
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

-- `Help` to open help manual in a new tab
local function open_help_in_tab(args)
	vim.cmd('tab help ' .. args)
end

-- Override the default :help command
vim.api.nvim_create_user_command(
	'Help',
	function(opts)
		open_help_in_tab(table.concat(opts.fargs, ' '))
	end,
	{ nargs = '+', complete = 'help' }
)

-- -- Remap :h to :Help and :help to :Help
-- vim.cmd([[
--   cabbrev h Help
--   cabbrev help Help
-- ]])
--
-- -- Remap :h to :Help
-- vim.cmd('cabbrev h Help')

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Terminal buffers settings ]]
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", {}),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.scrolloff = 0
	end,
})

vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

vim.keymap.set("n", ",st", function()
	vim.cmd.new()
	vim.cmd.wincmd "J"
	vim.api.nvim_win_set_height(0, 12)
	vim.wo.winfixheight = true
	vim.cmd.term()
end)
--
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
	defaults = {
		layout_config = {
			horizontal = {
				width = 0.9,
				height = 0.9,
				preview_cutoff = 120,
				preview_width = 0.7,
			},
			vertical = {
				width = 0.9,
				height = 0.9,
				preview_height = 0.7,
			},
		},
		mappings = {
			i = {
				['<C-u>'] = false,
				['<C-d>'] = false,
			},
		},
	},
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
	-- Use the current buffer's path as the starting point for the git search
	local current_file = vim.api.nvim_buf_get_name(0)
	local current_dir
	local cwd = vim.fn.getcwd()
	-- If the buffer is not associated with a file, return nil
	if current_file == '' then
		current_dir = cwd
	else
		-- Extract the directory from the current file's path
		current_dir = vim.fn.fnamemodify(current_file, ':h')
	end

	-- Find the Git root directory from the current file's path
	local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
	if vim.v.shell_error ~= 0 then
		print 'Not a git repository. Searching on current working directory'
		return cwd
	end
	return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
	local git_root = find_git_root()
	if git_root then
		require('telescope.builtin').live_grep {
			search_dirs = { git_root },
		}
	end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
		previewer = false,
	})
end, { desc = '[/] Fuzzily search in current buffer' })

local function telescope_live_grep_open_files()
	require('telescope.builtin').live_grep {
		grep_open_files = true,
		prompt_title = 'Live Grep in Open Files',
	}
end
vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = '[P]roject [V]iew' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
	require('nvim-treesitter.configs').setup {
		-- TSConfig: sync_install, ignore_install
		-- Add languages to be installed here that you want installed for treesitter
		ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'org', 'java' },

		-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
		auto_install = false,

		highlight = { enable = true },
		indent = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = '<c-space>',
				node_incremental = '<c-space>',
				scope_incremental = '<c-s>',
				node_decremental = '<M-space>',
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					['aa'] = '@parameter.outer',
					['ia'] = '@parameter.inner',
					['af'] = '@function.outer',
					['if'] = '@function.inner',
					['ac'] = '@class.outer',
					['ic'] = '@class.inner',
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					[']m'] = '@function.outer',
					[']]'] = '@class.outer',
				},
				goto_next_end = {
					[']M'] = '@function.outer',
					[']['] = '@class.outer',
				},
				goto_previous_start = {
					['[m'] = '@function.outer',
					['[['] = '@class.outer',
				},
				goto_previous_end = {
					['[M'] = '@function.outer',
					['[]'] = '@class.outer',
				},
			},
			swap = {
				enable = true,
				swap_next = {
					['<leader>a'] = '@parameter.inner',
				},
				swap_previous = {
					['<leader>A'] = '@parameter.inner',
				},
			},
		},
	}
end, 0)

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- helper function for remaps that sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end

		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end

	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

	nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
	nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
	nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
	nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
	nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

	-- See `:help K` for why this keymap
	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

	-- Lesser used LSP functionality
	nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
	nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	nmap('<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, '[W]orkspace [L]ist Folders')

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, { desc = 'Format current buffer with LSP' })
end

-- document existing key chains
require('which-key').register {
	['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
	['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
	['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
	['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
	['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
	['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
	['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
	['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
}
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require('which-key').register({
	['<leader>'] = { name = 'VISUAL <leader>' },
	['<leader>h'] = { 'Git [H]unk' },
}, { mode = 'v' })

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
	-- clangd = {},
	-- gopls = {},
	-- pyright = {},
	-- rust_analyzer = {},
	-- tsserver = {},
	html = { filetypes = { 'html', 'twig', 'hbs' } },
	omnisharp = { filetypes = { 'cs', 'vb' } },
	jdtls = {
		filetypes = { 'java' },
		settings = {
			java = {
				signatureHelp = { enabled = true },
				contentProvider = { preferred = 'fernflower' },
				completion = { favoriteStaticMembers = { 'java.util.Objects.requireNonNull', ... } },
				codeGeneration = { hashCodeEquals = { useInstanceof = true } },
			}
		}
	},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			-- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
			diagnostics = { disable = { 'missing-fields' } },
		},
	},
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
	function(server_name)
		require('lspconfig')[server_name].setup {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
			filetypes = (servers[server_name] or {}).filetypes,
		}
	end,
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	completion = {
		completeopt = 'menu,menuone,noinsert',
	},
	mapping = cmp.mapping.preset.insert {
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete {},
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'path' },
		{ name = 'omnisharp_bin' },
	},
}

vim.g.python3_host_prog = '/usr/bin/python3'

-- New filetypes
vim.filetype.add {
	extension = {
		man = "man",
	},
}
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
