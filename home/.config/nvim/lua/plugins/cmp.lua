return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-emoji",
        "petertriho/cmp-git",
        "chrisgrieser/cmp-nerdfont",
        "hrsh7th/cmp-nvim-lsp-document-symbol",
        "https://codeberg.org/FelipeLema/cmp-async-path",
        "SergioRibera/cmp-dotenv",
        {
            "Exafunction/codeium.nvim",
            cmd = "Codeium",
            build = ":Codeium Auth",
            opts = {},
        },
    },
    opts = function(_, opts)
        local theme = require("config.theme")
        local cmp = require("cmp")
        local cmp_lsp_rs = require("cmp_lsp_rs")
        local compare = require("cmp").config.compare
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
        for i, item in pairs(opts.sources) do
            if item.name == "path" then
                opts.sources[i] = { name = "async_path" }
            end
        end
        opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
            { name = "git" },
            { name = "emoji" },
            { name = "nerdfont" },
            { name = "dotenv" },
        }))
        opts.experimental.ghost_text = false
        return opts
    end,
    keys = {
        { "fCe", "<cmd>lua require('utils.codeium').enable()<cr>", desc = "Enable" },
        { "fCd", "<cmd>lua require('utils.codeium').disable()<cr>", desc = "Disable" },
    },
}
