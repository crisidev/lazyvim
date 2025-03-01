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
        "neovim/nvim-lspconfig",
        opts = {
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
}
