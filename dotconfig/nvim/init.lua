vim.g.mapleader = "\\"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release lazypath,
  })
end

-- Some editor configrations
vim.opt.number = true
vim.opt.shiftwidth = 3
vim.opt.tabstop = 3
vim.opt.softtabstop = 3
vim.opt.smartindent = true
vim.opt.wrap = true

vim.opt.rtp:prepend(lazypath)

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

-- Configure `ruff-lsp`.
-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruff_lsp
-- For the default config, along with instructions on how to customize the settings

-- Lazy packages to install/manage
require("lazy").setup({
	"folke/tokyonight.nvim",
	"neovim/nvim-lspconfig",
	"nvim-neo-tree/neo-tree.nvim",
	"nvim-telescope/telescope.nvim",
	"nvim-lua/lsp-status.nvim",
	"nvim-lualine/lualine.nvim",
	{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-vsnip",
	"hrsh7th/vim-vsnip",
	"nvim-tree/nvim-web-devicons",
	"MunifTanjim/nui.nvim",
	"nvim-lua/plenary.nvim",
	"mfussenegger/nvim-dap",
	"mfussenegger/nvim-jdtls",
})

-- telescope bindings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- cmp ( completion ) setup
local cmp = require('cmp')
cmp.setup{
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	window = {
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['C-f>'] = cmp.mapping.scroll_docs(4),
		['C-Space'] = cmp.mapping.complete(),
		['C-e'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({select = true }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
	}, {
		{ name = 'buffer' }
	}),
}

cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'git' },
	}, {
		{ name = 'buffer' },
	})
})

cmp.setup.cmdline({'/', '?'}, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' },
	},
})

cmp.setup.cmdline({':'}, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' },
	}, {
		{ name = 'cmdline' },
	}),
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- rust-analyzer setup
require('lspconfig').rust_analyzer.setup{
	on_attach = on_attach,
	init_options = {
		settings = {
			args = {},
		}
	},
	capabilities = capabilities,
}

-- ruff ( python ) setup
require('lspconfig').ruff_lsp.setup {
	on_attach = on_attach,
	init_options = {
		settings = {
			-- Any extra CLI arguments for `ruff` go here.
			args = {},
		}
	},
	capabilities = capabilities,
}

-- kotlin setup
require('lspconfig').kotlin_language_server.setup{
	on_attach = on_attach,
	capabilities = capabilities,
}

-- treesitter setups
require('nvim-treesitter.configs').setup{
	ensure_installed = { 'lua', 'c', 'kotlin', 'java', 'cpp' },

	auto_install = true,

	ignore_install = { 'rust', 'javascript', 'python' },

	highlight = {
		enable = true,

		disable = { 'rust', 'javascript', 'python' },
	}
}

-- Neo-tree setups/configs
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1]])

require('neo-tree').setup({
	close_if_last_window = true,
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = true,
	with_markers = true,
})

vim.api.nvim_create_augroup("neotree", {})
vim.api.nvim_create_autocmd("VimEnter", {
	desc = "Open Neotree automatically",
	group = "neotree",
	callback = function()
		vim.cmd "Neotree show"
	end,
})

-- Start neotree on start
vim.api.nvim_create_augroup("neotree", {})
vim.api.nvim_create_autocmd("VimEnter", {
	desc = "Open Neotree automatically",
	group = "neotree",
	callback = function()
		vim.cmd "Neotree show"
	end,
})

-- lua line configuration
require('lualine').setup{}

-- Themes configuration
require('tokyonight').setup({
	style = "storm",
	light_style = "day",
	transparent = true,
	terminal_colors = true,
	styles = {
		comments = { italic = true },
		keywords = { italic = true },
		functions = { bold = true },
		variables = {},
		sidebars  = "dark",
		floats = "transparent",
	},
	sidebars = { "qf", "help" },
	day_brightness = 0.3,
	hide_inactive_statusline = false,
	dim_inactive = true,
	lualine_bold = true,
})

-- Set theme on start
vim.api.nvim_create_augroup("tokyonight", {})
vim.api.nvim_create_autocmd("VimEnter", {
	desc = "Set tokyonight theme",
	group = "tokyonight",
	callback = function()
		vim.cmd "colorscheme tokyonight"
	end,
})
