local ONCE = true

return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                rust_analyzer = { enable = false },
                bacon_ls = { enable = true },
            },
            setup = {
                bacon_ls = function()
                    local lspconfig = require("lspconfig")
                    local configs = require("lspconfig.configs")
                    if not configs.bacon_ls then
                        configs.bacon_ls = {
                            default_config = {
                                cmd = { "/users/matteobigoi/github/bacon-ls/target/debug/bacon-ls" },
                                root_dir = lspconfig.util.root_pattern(".git"),
                                filetypes = { "rust" },
                            },
                        }
                    end
                    lspconfig.bacon_ls.setup({})
                    return true
                end,
            },
        },
    },
    {
        "mrcjkb/rustaceanvim",
        opts = function(_, opts)
            local cfg = require("rustaceanvim.config")
            local package_path = require("mason-registry").get_package("codelldb"):get_install_path()
            local codelldb_path = package_path .. "/codelldb"
            local liblldb_path = package_path .. "/extension/lldb/lib/liblldb.dylib"
            local function bacon_term()
                LazyVim.terminal.open({ "bacon", "clippy" }, {
                    ft = "bacon",
                    cwd = LazyVim.root.get(),
                    env = { LAZYTERM_TYPE = "bacon" },
                })
            end

            bacon_term()
            vim.defer_fn(function()
                bacon_term()
            end, 2000)
            vim.keymap.set({ "n", "i", "t" }, "<c-y>", bacon_term, { desc = "Bacon" })

            opts.server.on_attach = function(client, bufnr)
                local _, _ = pcall(vim.lsp.codelens.refresh)
            end
            opts.server.default_settings["rust-analyzer"].diagnostics = { enable = false }
            opts.server.default_settings["rust-analyzer"].checkOnSave["enable"] = false
            opts.dap = {
                adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
            }
        end,
        -- enabled = false,
    },
}
