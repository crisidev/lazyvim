-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = ","
vim.g.autoformat = false
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"
vim.g.transparent = true

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

require("config.neovide")
