return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-emoji",
        "petertriho/cmp-git",
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
        local theme = require("config.theme")
        local cmp = require("cmp")
        require("cmp_git").setup()
        theme.cmp()
        opts.formatting = {
            format = function(entry, vim_item)
                vim_item.kind = theme.cmp_icons[vim_item.kind] or vim_item.kind

                if entry.source and entry.source.name then
                    local diag = theme.diagnostics_icons[entry.source.name]
                    if diag then
                        vim_item.menu = diag .. vim_item.menu
                    end
                end

                return vim_item
            end,
        }
        opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
            { name = "git" },
            { name = "emoji" },
            { name = "nerdfont" },
        }))
        opts.experimental.ghost_text = false
    end,
    keys = {
        { "fCe", require("utils.codeium").enable, desc = "Enable" },
        { "fCd", require("utils.codeium").disable, desc = "Disable" },
    },
}
