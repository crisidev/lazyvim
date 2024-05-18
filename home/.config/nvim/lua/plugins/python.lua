return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                basedpyright = {
                    enabled = true,
                    cmd = (function()
                        local mason_install_path = vim.fn.stdpath("data") .. "/mason/bin"
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
                        local mason_install_path = vim.fn.stdpath("data") .. "/mason/bin"
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
}
