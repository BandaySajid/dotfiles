print("Yo Sajid! Happy hacking.")

vim.g.mapleader = " "

require("packer").startup(function(use)
	use { "wbthomason/packer.nvim" }
	-- use { "ellisonleao/gruvbox.nvim" }
	use { "sainnhe/gruvbox-material" }

	-- use {'navarasu/onedark.nvim'}

	use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		 requires = { {'nvim-lua/plenary.nvim'} } }
	use({
	  "chama-chomo/grail",
	  -- Optional; default configuration will be used if setup isn't called.
	  config = function()
		require("grail").setup()
	  end,
	})
	use {
	  'nvim-lualine/lualine.nvim',
	   requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}
	use { "fatih/vim-go" }
	use {
		'VonHeikemen/lsp-zero.nvim',
  		branch = 'v1.x',
  		requires = {
		{'neovim/nvim-lspconfig'},             -- Required
		{'williamboman/mason.nvim'},           -- Optional
		{'williamboman/mason-lspconfig.nvim'}, -- Optional
		{'hrsh7th/nvim-cmp'},         -- Required
		{'hrsh7th/cmp-nvim-lsp'},     -- Required
		{'hrsh7th/cmp-buffer'},       -- Optional
		{'hrsh7th/cmp-path'},         -- Optional
		{'saadparwaiz1/cmp_luasnip'}, -- Optional
		{'hrsh7th/cmp-nvim-lua'},     -- Optional
		{'L3MON4D3/LuaSnip'},             -- Required
		{'rafamadriz/friendly-snippets'}, -- Optional
  	},
	use {"akinsho/toggleterm.nvim", tag = '*' },
	use "terrortylor/nvim-comment",
	use "CreaturePhil/vim-handmade-hero"
}
end)

-- some
vim.keymap.set("n", "<M-b>", ":Ex<CR>")

-- split screen and navigation
vim.keymap.set("n", "<leader>v", ":vsplit<CR><C-w>l", { noremap = true })
vim.keymap.set("n", "<leader>h", ":wincmd h<CR>", { noremap = true })
vim.keymap.set("n", "<leader>l", ":wincmd l<CR>", { noremap = true })

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>f', function()
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
  		previewer = false,
    })
end, {noremap = true, desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>p', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<M-p>', require('telescope.builtin').find_files, {desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- for formatting code using prettier and gofmt for golang

vim.api.nvim_set_keymap('n', '<leader>F', [[:%!prettier --stdin-filepath % --single-quote --tab-width 3<CR>]], { noremap = true, silent = true })

-- TREESITTER
require'nvim-treesitter.configs'.setup {
	ensure_installed = {"c", "lua", "vim", "go", "javascript", "typescript", "rust", "ruby", "python"},
	highlight = {
		enable = false,
	}
}

-- LUALINE
require("lualine").setup{
	options = {
		icons_enabled = false,
		theme = "onedark",
		component_separators = "|",
		section_separators = "",
	},
}

-- LSP
local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
	"tsserver",
	"gopls",
	"eslint",
	"rust_analyzer",
	"clangd",
	"solargraph"
	-- "pyright"
})

-- setting ruby lsp for things like formatting.
--[[lspconfig.ruby_ls.setup{
	cmd = { 'ruby-lsp' },
	filetypes = { 'ruby' },
   root_dir = util.root_pattern('Gemfile', '.git'),
   init_options = {
   	formatter = 'auto',
   },
   single_file_support = true,
}--]]

lsp.set_preferences({
	sign_icons = {}
})

lsp.on_attach(function(client, bufnr)
	local opts = {buffer = bufnr, remap = false}
	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
end)

lsp.setup()

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		signs = false,
		virtual_text = true,
		underline = false,

	}
)

-- COMMENT
require("nvim_comment").setup({
	operator_mapping = "<leader>/"
})

-- TERMINAL SETUP
require("toggleterm").setup{ 
	direction = "horizontal",
	size = 50,
	open_mapping = [[<M-j>]]
}

--specific for gruvbox-material.
vim.g.gruvbox_material_background = 'hard'
vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'


--[[require('onedark').setup {
    style = 'darker'
}
require('onedark').load()--]]

-- COLORSCHEME
vim.cmd("colorscheme gruvbox-material")

-- setting javscript syntax for typescript files, for better highlighting
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    pattern = "*.ts",
    callback = function()
		 vim.cmd("set syntax=javascript")
    end
})

local function define_highlight(group, color)
    vim.cmd(string.format([[
        augroup Custom%s
            autocmd!
            autocmd FileType * hi %s guifg=%s
        augroup END
    ]], group, group, color))
end

-- Adding the same comment color in each theme
define_highlight('Comment', '#2ea542')

-- Disable annoying match brackets and all the jazz
vim.cmd([[
    augroup CustomHI
        autocmd!
        autocmd VimEnter * NoMatchParen
    augroup END
]])-- Disable annoying match brackets and all the jazz
vim.cmd([[
    augroup CustomHI
        autocmd!
        autocmd VimEnter * NoMatchParen
    augroup END
]])

-- go back to previous file and cursor position.
vim.api.nvim_set_keymap('n', 'go', '<C-o>', {noremap = true, silent = true})

-- vim.api.nvim_set_hl(0, "CmpNormal", { bg = "#504945" })

require("cmp").setup({
    window = {
        completion = {
            border = "rounded",
            winhighlight = "Normal:CmpNormal",
        }
    }
})

vim.o.background = "dark"

vim.keymap.set("i", "jj", "<Esc>")

-- vim.opt.guicursor = "i:block"

vim.opt.tabstop = 3
vim.opt.shiftwidth = 3
vim.opt.number = false
vim.opt.relativenumber = true
vim.opt.swapfile = false

vim.opt.swapfile = false

vim.o.hlsearch = true
vim.o.mouse = 'a'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300
--vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true
vim.o.clipboard = "unnamedplus"
