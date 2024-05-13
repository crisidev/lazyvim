return {
    "L3MON4D3/LuaSnip",
    opts = function(_, opts)
        local home = vim.env.HOME
        require("luasnip.loaders.from_vscode").lazy_load({ paths = home .. "/.config/nvim/snippets" })
    end,
}
