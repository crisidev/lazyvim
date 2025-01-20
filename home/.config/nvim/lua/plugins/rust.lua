local function rust_analyzer_settings()
    local opts = {
        checkOnSave = {
            -- enable = vim.g.lazyvim_rust_diagnostics == "rust-analyzer",
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
                enable = false,
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
            enable = vim.g.lazyvim_rust_diagnostics == "rust-analyzer",
            refreshSupport = true,
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
                -- ["async-trait"] = { "async_trait" },
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

return {

    {
        "williamboman/mason.nvim",
        optional = true,
        opts = function(_, opts)
            for i, v in ipairs(opts.ensure_installed) do
                if v == "bacon" then
                    table.remove(opts.ensure_installed, i)
                    break
                end
            end
        end,
    },
    {
        "mrcjkb/rustaceanvim",
        opts = function()
            return {
                server = {
                    default_settings = {
                        ["rust-analyzer"] = rust_analyzer_settings(),
                    },
                },
            }
        end,
    },
}
