local function rust_analyzer_settings()
    local opts = {
        checkOnSave = {
            -- enable = vim.env.NEOVIM_RUST_DIAGNOSTICS == "rust_analyzer",
            enable = false,
            command = "clippy",
            extraArgs = { "--no-deps" },
            target = vim.env.NEOVIM_RUST_TARGET,
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
            },
            closureReturnTypeHints = {
                enable = true,
            },
            lifetimeElisionHints = {
                enable = true,
                useParameterNames = true,
            },
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
            enable = true,
        },
        diagnostics = {
            enable = vim.env.NEOVIM_RUST_DIAGNOSTICS == "rust_analyzer",
        },
        cargo = {
            autoreload = true,
            loadOutDirsFromCheck = true,
            allFeatures = true,
            buildScripts = {
                enable = true,
            },
            target = vim.env.NEOVIM_RUST_TARGET,
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
    if vim.env.NEOVIM_RUST_DEVELOP_RUSTC == "true" then
        opts["check"] = {
            invocationLocation = "root",
            invocationStrategy = "once",
            overrideCommand = {
                "python3",
                "x.py",
                "check",
                "--json-output",
            },
        }
        opts["linkedProjects"] = {
            "Cargo.toml",
            "src/tools/x/Cargo.toml",
            "src/bootstrap/Cargo.toml",
            "src/tools/rust-analyzer/Cargo.toml",
            "compiler/rustc_codegen_cranelift/Cargo.toml",
            "compiler/rustc_codegen_gcc/Cargo.toml",
        }
        opts["rustfmt"] = {
            overrideCommand = {
                "${workspaceFolder}/build/host/rustfmt/bin/rustfmt",
                "--edition=2021",
            },
        }
        opts["procMacro"]["server"] = "${workspaceFolder}/build/host/stage0/libexec/rust-analyzer-proc-macro-srv"
        opts["cargo"]["sysrootSrc"] = "./library"
        opts["cargo"]["extraEnv"] = {
            RUSTC_BOOTSTRAP = "1",
        }
        opts["rustc"] = {
            source = "./Cargo.toml",
        }
        opts["cargo"]["buildScripts"] = {
            enable = true,
            invocationLocation = "root",
            invocationStrategy = "once",
            overrideCommand = {
                "python3",
                "x.py",
                "check",
                "--json-output",
            },
        }
    end
    return opts
end

local function codelldb_adapter()
    local cfg = require("rustaceanvim.config")
    local home = vim.env.HOME
    local pkg = home .. "/.local/share/nvim/mason/packages/codelldb"
    local codelldb = pkg .. "/extension/adapter/codelldb"
    local liblldb = pkg .. "/extension/lldb/lib/liblldb.dylib"
    return cfg.get_codelldb_adapter(codelldb, liblldb)
end

return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                bacon_ls = {
                    enable = vim.env.NEOVIM_RUST_DIAGNOSTICS == "bacon-ls",
                },
            },
            setup = {
                rust_analyzer = function()
                    return true
                end,
                bacon_ls = function()
                    if vim.env.NEOVIM_RUST_DIAGNOSTICS ~= "bacon-ls" then
                        return true
                    else
                        local function bacon_term()
                            LazyVim.terminal.open(
                                { "bacon", "clippy", "--", "--all-features", "--target", vim.env.NEOVIM_RUST_TARGET },
                                {
                                    ft = "bacon",
                                    cwd = LazyVim.root.get(),
                                    env = { LAZYTERM_TYPE = "bacon" },
                                }
                            )
                        end

                        bacon_term()
                        vim.defer_fn(function()
                            bacon_term()
                        end, 2000)
                        vim.keymap.set({ "n", "i", "t" }, "<c-y>", bacon_term, { desc = "Bacon" })
                        return false
                    end
                end,
            },
        },
    },
    {
        "mrcjkb/rustaceanvim",
        opts = {
            server = {
                default_settings = {
                    ["rust-analyzer"] = rust_analyzer_settings(),
                },
            },
            dap = {
                adapter = codelldb_adapter(),
            },
        },
    },
}
