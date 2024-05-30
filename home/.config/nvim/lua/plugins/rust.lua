local ONCE = true

return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                bacon_ls = { enabled = true },
            },
            setup = {
                rust_analyzer = function()
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

            opts.server.default_settings["rust-analyzer"] = {
                checkOnSave = {
                    enable = false,
                    command = "clippy",
                    extraArgs = { "--no-deps" },
                    -- target = "aarch64-unknown-linux-musl",
                },
                callInfo = {
                    full = true,
                },
                lens = {
                    enable = true,
                    references = true,
                    implementations = true,
                    enumVariantReferences = true,
                    methodReferences = true,
                },
                inlayHints = {
                    enable = true,
                    bindingModeHints = {
                        enable = false,
                    },
                    chainingHints = {
                        enable = true,
                    },
                    closingBraceHints = {
                        enable = true,
                        minLines = 25,
                    },
                    closureReturnTypeHints = {
                        enable = "never",
                    },
                    lifetimeElisionHints = {
                        enable = "never",
                        useParameterNames = false,
                    },
                    maxLength = 25,
                    parameterHints = {
                        enable = true,
                    },
                    reborrowHints = {
                        enable = "never",
                    },
                    renderColons = true,
                    typeHints = {
                        enable = true,
                        hideClosureInitialization = false,
                        hideNamedConstructor = false,
                    },
                },
                cachePriming = {
                    enable = false,
                },
                diagnostics = {
                    enable = false,
                },
                cargo = {
                    autoreload = true,
                    loadOutDirsFromCheck = true,
                    allFeatures = true,
                    buildScripts = {
                        enable = true,
                    },
                    -- target = "aarch64-unknown-linux-musl",
                },
                hoverActions = {
                    enable = true,
                    references = true,
                },
                procMacro = {
                    enable = true,
                    ignored = {
                        ["async-trait"] = { "async_trait" },
                        ["napi-derive"] = { "napi" },
                        ["async-recursion"] = { "async_recursion" },
                    },
                },
            }
            opts.dap = {
                adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
            }
        end,
    },
}
