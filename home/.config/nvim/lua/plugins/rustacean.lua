return {
    "mrcjkb/rustaceanvim",
    opts = {
        server = {
            on_attach = function(client, bufnr)
                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(true)
                end
            end,
            default_settings = {
                ["rust-analyzer"] = {
                    checkOnSave = {
                        enable = true,
                        -- command = "check",
                        command = "clippy",
                        extraArgs = { "--no-deps" },
                        allFeatures = true,
                        -- target = "aarch64-unknown-linux-musl",
                        -- allTargets = false,
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
                        typeHints = true,
                        parameterHints = true,
                    },
                    cachePriming = {
                        enable = false,
                    },
                    diagnostics = {
                        experimental = true,
                    },
                    cargo = {
                        autoreload = true,
                        allFeatures = true,
                        loadOutDirsFromCheck = true,
                        -- target = "aarch64-unknown-linux-musl",
                        buildScripts = {
                            enable = true,
                        },
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
                },
            },
        },
        dap = {
            adapter = require("utils.lang.rust").dap(),
        },
    },
}
