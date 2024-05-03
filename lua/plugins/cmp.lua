local codeium = require("utils.codeium")

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-emoji",
        "petertriho/cmp-git",
        "vrslev/cmp-pypi",
        "chrisgrieser/cmp-nerdfont",
        {
            "Exafunction/codeium.nvim",
            cmd = "Codeium",
            build = ":Codeium Auth",
            opts = {},
        },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
        require("cmp_git").setup()
        table.insert(opts.sources, { name = "git" })
        table.insert(opts.sources, { name = "emoji" })
        table.insert(opts.sources, { name = "nerdfont" })
        table.insert(opts.sources, { name = "pypi", keyword_length = 4 })
        -- opts.experimental.ghost_text = false
    end,
    keys = {
        { "fCe", codeium.enable, desc = "Enable" },
        { "fCd", codeium.disable, desc = "Disable" },
    },
}
