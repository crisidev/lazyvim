-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- Disable autoformat for lua files
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

-- Python
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("python_build_tools"),
    pattern = "python",
    desc = "Set additional buffer keymaps for Python files",
    callback = function()
        local which_key = require("which-key")
        local icons = require("config.theme").languages
        local opts = {
            mode = "n",
            prefix = "f",
            buffer = vim.fn.bufnr(),
            silent = true,
            noremap = true,
            nowait = true,
        }
        local mappings = {
            B = {
                name = icons.python .. "Build helpers",
                i = { "<cmd>PyrightOrganizeImports<cr>", "Organize imports" },
                p = {
                    function()
                        local line = vim.api.nvim_get_current_line()
                        local nline = line .. "  # pyright: ignore"
                        vim.api.nvim_set_current_line(nline)
                    end,
                    "Insert # pyright: ignore",
                },
            },
        }
        which_key.register(mappings, opts)
    end,
})

-- Rust
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("rust_build_tools"),
    pattern = "rust",
    desc = "Set additional buffer keymaps for Rust files",
    callback = function()
        local which_key = require("which-key")
        local theme = require("config.theme")
        local opts = {
            mode = "n",
            prefix = "f",
            buffer = vim.fn.bufnr(),
            silent = true,
            noremap = true,
            nowait = true,
        }
        local mappings = {
            K = { "<cmd>RustLsp externalDocs<cr>", theme.icons.docs .. "Open docs.rs" },
            L = { "<cmd>RustLsp renderDiagnostic<cr>", theme.diagnostics_icons.Hint .. "Show cargo diagnostic" },
            B = {
                name = theme.languages.rust .. "Build helpers",
                A = {
                    name = "Rust analyzer",
                    s = { "<cmd>RustAnalyzer start<cr>", "Start" },
                    S = { "<cmd>RustAnalyzer stop<cr>", "Stop" },
                    r = { "<cmd>RustAnalyzer restart<cr>", "Restart" },
                },
                a = { "<cmd>RustLsp hover actions<cr>", "Hover actions" },
                r = { "<cmd>RustLsp runnables<cr>", "Run targes" },
                R = { "<cmd>RustLsp debuggables<cr>", "Debug targes" },
                e = { "<cmd>RustLsp expandMacro<cr>", "Expand macro" },
                p = { "<cmd>RustLsp rebuildProcMacros<cr>", "Rebuild proc macro" },
                m = { "<cmd>RustLsp parentModule<cr>", "Parent module" },
                u = { "<cmd>RustLsp moveItem up<cr>", "Move item up" },
                d = { "<cmd>RustLsp moveItem down<cr>", "Move item down" },
                H = { "<cmd>RustLsp hover range<cr>", "Hover range" },
                E = { "<cmd>RustLsp explainError<cr>", "Explain error" },
                c = { "<cmd>RustLsp openCargo<cr>", "Open Cargo.toml" },
                t = { "<cmd>RustLsp syntaxTree<cr>", "Syntax tree" },
                j = { "<cmd>RustLsp joinLines", "Join lines" },
                w = { "<cmd>RustLsp reloadWorkspace<cr>", "Reload workspace" },
                D = { "<cmd>RustLsp externalDocs<cr>", "Open docs.rs" },
            },
        }
        which_key.register(mappings, opts)
    end,
})

-- Cargo.toml
vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup("cargo_toml_build_tools"),
    pattern = "Cargo.*toml",
    desc = "Set additional buffer keymaps for Cargo.toml",
    callback = function()
        local which_key = require("which-key")
        local theme = require("config.theme")
        local opts = {
            mode = "n",
            prefix = "f",
            buffer = vim.fn.bufnr(),
            silent = true,
            noremap = true,
            nowait = true,
        }
        -- Cargo tools mappings
        local mappings = {
            B = {
                name = theme.languages.toml .. "Build helpers",
                t = { "<cmd>lua require('crates').toggle()<cr>", "Toggle crates info" },
                r = { "<cmd>lua require('crates').reload()<cr>", "Reload crates info" },
                v = { "<cmd>lua require('crates').show_versions_popup()<cr>", "Show versions popup" },
                f = { "<cmd>lua require('crates').show_features_popup()<cr>", "Show features popup" },
                u = { "<cmd>lua require('crates').update_crate()<cr>", "Update crate" },
                a = { "<cmd>lua require('crates').update_all_crates()<cr>", "Update all crates" },
                U = { "<cmd>lua require('crates').upgrade_crate()<cr>", "Upgrade crate" },
                A = { "<cmd>lua require('crates').upgrade_all_crates()<cr>", "Upgrade all crates" },
                h = { "<cmd>lua require('crates').open_homepage()<cr>", "Open crate homepage" },
                R = { "<cmd>lua require('crates').open_repository()<cr>", "Open crate repository" },
                d = { "<cmd>lua require('crates').open_documentation()<cr>", "Open crate documentation" },
                c = { "<cmd>lua require('crates').open_crates_io()<cr>", "Open crates.io" },
            },
        }
        -- Cargo tools mappings
        local vmappings = {
            B = {
                name = theme.languages.toml .. " Build helpers",
                u = { "<cmd>lua require('crates').update_crates()<cr>", "Update crates" },
                U = { "<cmd>lua require('crates').upgrade_crates()<cr>", "Upgrade crates" },
            },
        }
        which_key.register(mappings, opts)
        opts.mode = "v"
        which_key.register(vmappings, opts)
    end,
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
