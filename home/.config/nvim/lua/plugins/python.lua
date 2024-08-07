local mason_install_path = vim.fn.stdpath("data") .. "/mason/bin"

return {
    {
        "wookayin/semshi", -- use a maintained fork
        ft = "python",
        build = ":UpdateRemotePlugins",
        init = function()
            -- Disabled these features better provided by LSP or other more general plugins
            vim.g["semshi#error_sign"] = false
            vim.g["semshi#simplify_markup"] = false
            vim.g["semshi#mark_selected_nodes"] = false
            vim.g["semshi#update_delay_factor"] = 0.001

            -- This autocmd must be defined in init to take effect
            vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
                group = vim.api.nvim_create_augroup("SemanticHighlight", {}),
                callback = function()
                    -- Only add style, inherit or link to the LSP's colors
                    vim.cmd([[
            highlight! link semshiGlobal  @none
            highlight! link semshiImported @none
            highlight! link semshiParameter @lsp.type.parameter
            highlight! link semshiBuiltin @function.builtin
            highlight! link semshiAttribute @field
            highlight! link semshiSelf @lsp.type.selfKeyword
            highlight! link semshiUnresolved @none
            highlight! link semshiFree @none
            highlight! link semshiAttribute @none
            highlight! link semshiParameterUnused @none
            ]])
                end,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                basedpyright = {
                    enabled = true,
                    cmd = (function()
                        local cmd_path = mason_install_path .. "/basedpyright-langserver"
                        local cmd = { cmd_path, "--stdio" }
                        local match = vim.fn.glob(vim.fn.getcwd() .. "/poetry.lock")
                        if match ~= "" then
                            cmd = { "poetry", "run", cmd_path, "--stdio" }
                        end
                        return cmd
                    end)(),
                },
                ruff_lsp = {
                    enabled = true,
                    cmd = (function()
                        local cmd_path = mason_install_path .. "/ruff-lsp"
                        local cmd = { cmd_path }
                        local match = vim.fn.glob(vim.fn.getcwd() .. "/poetry.lock")
                        if match ~= "" then
                            cmd = { "poetry", "run", cmd_path }
                        end
                        return cmd
                    end)(),
                },
            },
            setup = {
                ruff_lsp = function()
                    LazyVim.lsp.on_attach(function(client, _)
                        if client.name == "ruff_lsp" then
                            client.server_capabilities.documentFormattingProvider = false
                        end
                    end)
                end,
            },
        },
    },
    {
        "mfussenegger/nvim-dap-python",
        keys = function()
            return {
                {
                    "<leader>dm",
                    function()
                        require("dap-python").test_method()
                    end,
                    desc = "Debug Method (python)",
                    ft = "python",
                },
                {
                    "<leader>dM",
                    function()
                        require("dap-python").test_class()
                    end,
                    desc = "Debug Class (python)",
                    ft = "python",
                },
            }
        end,
        config = function()
            require("dap-python").setup(vim.env.HOME .. "/.bin/poetry-debugpy")
        end,
    },
}
