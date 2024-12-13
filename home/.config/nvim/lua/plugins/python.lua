local function poetry_run(args)
    local mason_install_path = vim.fn.stdpath("data") .. "/mason/bin"
    local file = vim.fn.findfile("poetry.lock", ".;")
    if file == "poetry.lock" then
        args[1] = mason_install_path .. "/" .. args[1]
        table.insert(args, 1, "poetry")
        table.insert(args, 2, "run")
    end
    return args
end

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
            -- servers = {
            --     basedpyright = {
            --         enabled = true,
            --         cmd = utils.poetry_run({ "basedpyright-langserver", "--stdio" }),
            --     },
            --     ruff = {
            --         enabled = true,
            --         cmd = utils.poetry_run({ "ruff" }),
            --     },
            -- },
            setup = {
                ruff = function()
                    LazyVim.lsp.on_attach(function(client, _)
                        if client.name == "ruff" then
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
            return {}
        end,
        config = function()
            require("dap-python").setup(vim.env.HOME .. "/.bin/poetry-debugpy")
        end,
    },
}
