local function standard_rust_analyzer_settings()
    return {
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
end

local function compiler_rust_analyzer_settings()
    local opts = standard_rust_analyzer_settings()
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
    return opts
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
                    end
                end,
            },
        },
    },
    {
        "mrcjkb/rustaceanvim",
        dependencies = {
            "adaszko/tree_climber_rust.nvim",
        },
        opts = function(_, opts)
            local cfg = require("rustaceanvim.config")
            local package_path = require("mason-registry").get_package("codelldb"):get_install_path()
            local codelldb_path = package_path .. "/codelldb"
            local liblldb_path = package_path .. "/extension/lldb/lib/liblldb.dylib"

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

            if vim.env.NEOVIM_RUST_DIAGNOSTICS == "bacon-ls" then
                bacon_term()
                vim.defer_fn(function()
                    bacon_term()
                end, 2000)
                vim.keymap.set({ "n", "i", "t" }, "<c-y>", bacon_term, { desc = "Bacon" })
            end

            if vim.env.NEOVIM_RUST_DEVELOP_RUSTC == "true" then
                opts.server.default_settings["rust-analyzer"] = compiler_rust_analyzer_settings()
            else
                opts.server.default_settings["rust-analyzer"] = standard_rust_analyzer_settings()
            end

            opts.server.on_attach = function(client, bufnr)
                local opts = { noremap = true, silent = true }
                vim.api.nvim_buf_set_keymap(
                    bufnr,
                    "n",
                    "s",
                    '<cmd>lua require("tree_climber_rust").init_selection()<CR>',
                    opts
                )
                vim.api.nvim_buf_set_keymap(
                    bufnr,
                    "x",
                    "s",
                    '<cmd>lua require("tree_climber_rust").select_incremental()<CR>',
                    opts
                )
                vim.api.nvim_buf_set_keymap(
                    bufnr,
                    "x",
                    "S",
                    '<cmd>lua require("tree_climber_rust").select_previous()<CR>',
                    opts
                )
            end

            opts.dap = {
                adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
            }
        end,
    },
}
