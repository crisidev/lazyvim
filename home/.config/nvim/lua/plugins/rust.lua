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
    "mrcjkb/rustaceanvim",
    opts = function()
        local package_path = require("mason-registry").get_package("codelldb"):get_install_path()
        local codelldb = package_path .. "/extension/adapter/codelldb"
        local library_path = package_path .. "/extension/lldb/lib/liblldb.dylib"
        local uname = io.popen("uname"):read("*l")
        if uname == "Linux" then
            library_path = package_path .. "/extension/lldb/lib/liblldb.so"
        end
        return {
            server = {
                default_settings = {
                    ["rust-analyzer"] = rust_analyzer_settings(),
                },
            },
            dap = {
                adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
            },
        }
    end,
}
