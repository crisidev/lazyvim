-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = ","
vim.g.autoformat = false
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.python3_host_prog = vim.env.HOME .. "/.nix-profile/bin/python"
vim.g.transparent = false
vim.g.ai_plugin = false

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.backup = true
vim.opt.swapfile = true
vim.opt.backupdir = { vim.fn.stdpath("cache") .. "/backups" }
vim.opt.backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim"
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.cursorline = true
vim.opt.mousescroll = { "ver:3", "hor:6" }
vim.opt.mousefocus = true
vim.opt.mousemoveevent = true

vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"
vim.g.lazyvim_picker = "telescope"
vim.g.lazyvim_rust_diagnostics = vim.fn.getenv("LAZYVIM_RUST_DIAGNOSTICS") or "rust-analyzer"

require("config.neovide")
