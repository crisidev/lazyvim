local theme = require("config.theme")

return {
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        enabled = false,
        config = function()
            require("go").setup({
                diagnostic = {
                    hdlr = false,
                    underline = true,
                    virtual_text = false,
                    signs = {
                        theme.diagnostics_icons.Error,
                        theme.diagnostics_icons.Warn,
                        theme.diagnostics_icons.Info,
                        theme.diagnostics_icons.Hint,
                    },
                    update_in_insert = true,
                },
                lsp_cfg = true,
                lsp_keymaps = false,
                lsp_inlay_hints = {},
            })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", "gomod" },
        build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    },
}
