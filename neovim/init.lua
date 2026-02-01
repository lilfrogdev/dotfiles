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
  { "nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-treesitter/nvim-treesitter", lazy = false, build = ":TSUpdate" },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
  { "nvim-telescope/telescope-ui-select.nvim" }
}
local opts = {}

require("lazy").setup(plugins, opts)

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

require("telescope").setup ({
  extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown {
        }
      }
    }
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
vim.cmd.colorscheme "catppuccin"

require"nvim-treesitter".setup {
  install_dir = vim.fn.stdpath("data") .. "/site",
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
    "yaml"
  }
}

require("lualine").setup {
  options = {
    icons_enabled = true,
  }
}

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
  }
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
