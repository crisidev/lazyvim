local module = {}
local theme = require("config.theme")
local mason_bin_path = vim.fn.stdpath("data") .. "/mason/bin"
local mason_packages_path = vim.fn.stdpath("data") .. "/mason/packages"

module.build_tools = function()
    local which_key = require("which-key")
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
        L = { "<cmd>RustLsp renderDiagnostic<cr>", theme.icons.hint .. "Show cargo diagnostic" },
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
end

module.dap = function()
    local cfg = require("rustaceanvim.config")
    local codelldb_path = mason_bin_path .. "/codelldb"
    local liblldb_path = mason_packages_path .. "/codelldb/extension/lldb/lib/liblldb.dylib"
    return cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
end

module.cargo_toml_build_tools = function()
    local which_key = require("which-key")
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
    local vopts = {
        mode = "v",
        prefix = "f",
        buffer = vim.fn.bufnr(),
        silent = true,
        noremap = true,
        nowait = true,
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
    which_key.register(vmappings, vopts)
end

return module
