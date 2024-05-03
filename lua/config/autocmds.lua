-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- Disable autoformat for lua files
-- Codelense viewer
local function augroup(name)
    vim.api.nvim_create_augroup("crisidev_" .. name, { clear = true })
end

-- Faster yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("fast_yank"),
    pattern = "*",
    desc = "Highlight text on yank",
    callback = function()
        require("vim.highlight").on_yank({ higroup = "Search", timeout = 200 })
    end,
})

-- CursorLine management
vim.api.nvim_create_autocmd("WinLeave", {
    group = augroup("cursorline_win_leave"),
    callback = function()
        vim.opt_local.cursorline = false
    end,
})
vim.api.nvim_create_autocmd("WinEnter", {
    group = augroup("cursorline_win_enter"),
    callback = function()
        if vim.bo.filetype ~= "alpha" then
            vim.opt_local.cursorline = true
        end
    end,
})

-- Disable undo for certain files
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup("disable_undo"),
    pattern = { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak" },
    desc = "Disable undo for specific files",
    callback = function()
        vim.opt_local.undofile = false
    end,
})

-- Codelens
vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
    group = augroup("codelens_refresh"),
    pattern = { "rust", "c", "cpp", "go", "typescript", "java" },
    desc = "Refresh codelens",
    callback = vim.lsp.codelens.refresh,
})

vim.api.nvim_create_autocmd("CursorHold", {
    group = augroup("codelens_line_sign"),
    pattern = { "*" },
    desc = "Show codelens indicator",
    callback = require("utils.codelens").show_line_sign,
})

-- Python
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("python_build_tools"),
    pattern = "python",
    desc = "Set additional buffer keymaps for Python files",
    callback = require("utils.lang.python").build_tools,
})

-- Rust
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("rust_build_tools"),
    pattern = "rust",
    desc = "Set additional buffer keymaps for Rust files",
    callback = require("utils.lang.rust").build_tools,
})
vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup("cargo_toml_build_tools"),
    pattern = "Cargo.*toml",
    desc = "Set additional buffer keymaps for Cargo.toml",
    callback = require("utils.lang.rust").cargo_toml_build_tools,
})

-- Go
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("go_build_tools"),
    pattern = "go",
    desc = "Set additional buffer keymaps for Go files",
    callback = require("utils.lang.rust").build_tools,
})

-- Gitlab CI
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup("gilab_ci"),
    pattern = ".gitlab*",
    desc = "Set the proper filetype for Gitlab CI",
    callback = function()
        vim.bo.filetype = "yaml.gitlab"
    end,
})
