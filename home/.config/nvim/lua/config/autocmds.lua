-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- Disable autoformat for lua files
local function augroup(name)
    vim.api.nvim_create_augroup("crisidev_" .. name, { clear = true })
end

local timestamps = {
    rust_fly_check = 0,
}

local function maybe_run_callback_after_wait_time(name, wait, callback)
    local recorded_ts = timestamps[name]
    if recorded_ts ~= nil then
        local ts = os.time(os.date("!*t"))
        if ts - recorded_ts > wait then
            callback()
            timestamps[name] = os.time(os.date("!*t"))
        end
    end
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
        local theme = require("config.theme")
        local mappings = {
            mode = "n",
            buffer = vim.fn.bufnr(),
            { "gB", group = "Build Helpers", icon = theme.languages.python },
            { "gBi", "<cmd>PyrightOrganizeImports<cr>", desc = "Organize imports" },
            {
                "gBp",
                function()
                    local line = vim.api.nvim_get_current_line()
                    local nline = line .. "  # pyright: ignore"
                    vim.api.nvim_set_current_line(nline)
                end,
                desc = "Insert # pyright: ignore",
            },
        }
        which_key.add(mappings)
    end,
})

-- Rust
vim.api.nvim_create_autocmd("BufWritePost", {
    group = augroup("rust_diagnostics_on_save"),
    pattern = "*.rs",
    desc = "Request diagnostics after save",
    callback = function()
        vim.cmd.RustLsp({ "flyCheck", "run" })
    end,
})

-- vim.api.nvim_create_autocmd("CursorHold", {
--     group = augroup("rust_diagnostics_on_hold"),
--     pattern = "*.rs",
--     desc = "Request diagnostics on cursor hold",
--     callback = function()
--         if vim.env.NEOVIM_RUST_DEVELOP_RUSTC == "true" then
--             maybe_run_callback_after_wait_time("rust_fly_check", 30, function()
--                 vim.cmd.write()
--                 vim.cmd.RustLsp({ "flyCheck", "run" })
--             end)
--         else
--             maybe_run_callback_after_wait_time("rust_fly_check", 30, function()
--                 vim.cmd.write()
--                 vim.cmd.RustLsp({ "flyCheck", "run" })
--             end)
--         end
--     end,
-- })

vim.api.nvim_create_autocmd("FileType", {
    group = augroup("rust_build_tools"),
    pattern = "rust",
    desc = "Set additional buffer keymaps for Rust files",
    callback = function()
        local which_key = require("which-key")
        local theme = require("config.theme")
        local mappings = {
            mode = "n",
            buffer = vim.fn.bufnr(),
            { "gK", "<cmd>RustLsp externalDocs<cr>", desc = "Open docs.rs", icon = theme.icons.docs },
            {
                "gL",
                "<cmd>RustLsp renderDiagnostic<cr>",
                desc = "Show cargo diagnostic",
                icon = theme.diagnostics_icons.Hint,
            },
            { "gB", group = "Build Helpers", icon = theme.languages.rust },
            { "gBA", group = "Rust Analyzer" },
            { "gBAs", "<cmd>RustAnalyzer start<cr>", desc = "Start" },
            { "gBAS", "<cmd>RustAnalyzer stop<cr>", desc = "Stop" },
            { "gBAr", "<cmd>RustAnalyzer restart<cr>", desc = "Restart" },
            { "gBa", "<cmd>RustLsp hover actions<cr>", desc = "Hover actions" },
            { "gBr", "<cmd>RustLsp runnables<cr>", desc = "Run targes" },
            { "gBR", "<cmd>RustLsp debuggables<cr>", desc = "Debug targes" },
            { "gBe", "<cmd>RustLsp expandMacro<cr>", desc = "Expand macro" },
            { "gBp", "<cmd>RustLsp rebuildProcMacros<cr>", desc = "Rebuild proc macro" },
            { "gBm", "<cmd>RustLsp parentModule<cr>", desc = "Parent module" },
            { "gBu", "<cmd>RustLsp moveItem up<cr>", desc = "Move item up" },
            { "gBd", "<cmd>RustLsp moveItem down<cr>", desc = "Move item down" },
            { "gBH", "<cmd>RustLsp hover range<cr>", desc = "Hover range" },
            { "gBE", "<cmd>RustLsp explainError<cr>", desc = "Explain error" },
            { "gBc", "<cmd>RustLsp openCargo<cr>", desc = "Open Cargo.toml" },
            { "gBt", "<cmd>RustLsp syntaxTree<cr>", desc = "Syntax tree" },
            { "gBj", "<cmd>RustLsp joinLines", desc = "Join lines" },
            { "gBw", "<cmd>RustLsp reloadWorkspace<cr>", desc = "Reload workspace" },
            { "gBD", "<cmd>RustLsp externalDocs<cr>", desc = "Open docs.rs" },
        }
        which_key.add(mappings)
    end,
})

-- Go
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("go_build_tools"),
    pattern = "go",
    desc = "Set additional buffer keymaps for Go files",
    callback = function()
        vim.keymap.set(
            { "n" },
            "<leader>dT",
            "lua require('dap-go').debug_test()<cr>",
            { desc = "Debug test", buffer = vim.fn.bufnr() }
        )
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
        local mappings = {
            mode = "n",
            buffer = vim.fn.bufnr(),
            { "gB", group = "Build Helpers", icon = theme.languages.toml },
            { "gBt", "<cmd>lua require('crates').toggle()<cr>", desc = "Toggle crates info" },
            { "gBr", "<cmd>lua require('crates').reload()<cr>", desc = "Reload crates info" },
            { "gBv", "<cmd>lua require('crates').show_versions_popup()<cr>", desc = "Show versions popup" },
            { "gBf", "<cmd>lua require('crates').show_features_popup()<cr>", desc = "Show features popup" },
            { "gBu", "<cmd>lua require('crates').update_crate()<cr>", desc = "Update crate" },
            { "gBa", "<cmd>lua require('crates').update_all_crates()<cr>", desc = "Update all crates" },
            { "gBU", "<cmd>lua require('crates').upgrade_crate()<cr>", desc = "Upgrade crate" },
            { "gBA", "<cmd>lua require('crates').upgrade_all_crates()<cr>", desc = "Upgrade all crates" },
            { "gBh", "<cmd>lua require('crates').open_homepage()<cr>", desc = "Open crate homepage" },
            { "gBR", "<cmd>lua require('crates').open_repository()<cr>", desc = "Open crate repository" },
            { "gBd", "<cmd>lua require('crates').open_documentation()<cr>", desc = "Open crate documentation" },
            { "gBc", "<cmd>lua require('crates').open_crates_io()<cr>", desc = "Open crates.io" },
        }
        which_key.add(mappings)

        local vmappings = {
            mode = "v",
            buffer = vim.fn.bufnr(),
            { "gB", group = "Build Helpers", icon = theme.languages.toml },
            { "gBu", "<cmd>lua require('crates').update_crates()<cr>", desc = "Update crates" },
            { "gBU", "<cmd>lua require('crates').upgrade_crates()<cr>", desc = "Upgrade crates" },
        }
        which_key.add(vmappings)
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
