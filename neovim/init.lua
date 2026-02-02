vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{ "nvim-treesitter/nvim-treesitter", lazy = false, build = ":TSUpdate" },
	{ "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "nvim-telescope/telescope-ui-select.nvim" },
	{ "nvimtools/none-ls.nvim" },
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-cmdline" },
	{ "L3MON4D3/LuaSnip", dependencies = { "saadparwaiz1/cmp_luasnip" } },
}
local opts = {}

require("lazy").setup(plugins, opts)

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

require("telescope").setup({
	defaults = {
		preview = { treesitter = false },
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
	},
})
require("telescope").load_extension("ui-select")

require("catppuccin").setup({
	flavour = "latte",
	integrations = {
		lualine = true,
		treesitter = true,
		telescope = true,
		cmp = true,
		gitsigns = true,
	},
})
vim.cmd.colorscheme("catppuccin")

require("nvim-treesitter").setup({
	auto_install = true,
	ensure_installed = {
		"bash",
		"css",
		"diff",
		"dockerfile",
		"gitcommit",
		"gitignore",
		"hcl",
		"html",
		"javascript",
		"json",
		"lua",
		"markdown",
		"markdown_inline",
		"python",
		"query",
		"regex",
		"rust",
		"terraform",
		"toml",
		"tsx",
		"typescript",
		"vim",
		"vimdoc",
		"vue",
		"yaml",
	},
	highlight = { enable = true },
	indent = { enable = true },
})

require("lualine").setup({
	options = {
		icons_enabled = true,
	},
})

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls",
		"cssls",
		"dockerls",
		"eslint",
		"html",
		"jsonls",
		"lua_ls",
		"pyright",
		"rust_analyzer",
		"terraformls",
		"ts_ls",
		"vue_ls",
		"yamlls",
	},
})

vim.lsp.enable("bashls")
vim.lsp.enable("cssls")
vim.lsp.enable("dockerls")
vim.lsp.enable("eslint")
vim.lsp.enable("html")
vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("terraformls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("vue_ls")
vim.lsp.enable("yamlls")

vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)

local null_ls = require("null-ls")

local rustfmt = {
	name = "rustfmt",
	meta = {
		url = "https://github.com/rust-lang/rustfmt",
		description = "Rust formatter from rustup",
	},
	method = null_ls.methods.FORMATTING,
	filetypes = { "rust" },
	generator = null_ls.formatter({
		command = "rustfmt",
		args = { "--emit", "stdout" },
		to_stdin = true,
	}),
}

local clippy = {
	name = "clippy",
	meta = {
		url = "https://github.com/rust-lang/rust-clippy",
		description = "Rust linter using cargo clippy",
	},
	method = null_ls.methods.DIAGNOSTICS,
	filetypes = { "rust" },
	generator = null_ls.generator({
		command = "cargo",
		args = { "clippy", "--message-format=json", "--quiet" },
		to_stdin = false,
		from_stderr = false,
		format = "json_raw",
	}),
}

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.ruff,
		null_ls.builtins.formatting.terraform_fmt,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.formatting.markdownlint,

		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.diagnostics.ruff,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.diagnostics.yamllint,
		null_ls.builtins.diagnostics.hadolint,

		rustfmt,
		clippy,
	},
})
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format)

local format_augroup = vim.api.nvim_create_augroup("LspFormat", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = format_augroup,
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
})

cmp.setup.cmdline(":", {
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})
