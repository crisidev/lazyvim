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
        {
            "zjp-CN/nvim-cmp-lsp-rs",
            ---@type cmp_lsp_rs.Opts
            opts = {
                unwanted_prefix = { "color", "ratatui::style::Styled" },
                kind = function(k)
                    return { k.Module, k.Function }
                end,
                combo = {
                    alphabetic_label_but_underscore_last = function()
                        local comparators = require("cmp_lsp_rs").comparators
                        return { comparators.sort_by_label_but_underscore_last }
                    end,
                    recentlyUsed_sortText = function()
                        local compare = require("cmp").config.compare
                        local comparators = require("cmp_lsp_rs").comparators
                        -- Mix cmp sorting function with cmp_lsp_rs.
                        return {
                            compare.recently_used,
                            compare.sort_text,
                            comparators.sort_by_label_but_underscore_last,
                        }
                    end,
                },
            },
        },
    },
    ---@param opts cmp.ConfigSchema
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
        opts.preselect = cmp.PreselectMode.None
        opts.completion = {
            completeopt = "menu,menuone,noselect",
        }
        opts.experimental.ghost_text = false
        opts.sorting.comparators = {
            compare.exact,
            compare.score,
            -- cmp_lsp_rs.comparators.inherent_import_inscope,
            cmp_lsp_rs.comparators.inscope_inherent_import,
            cmp_lsp_rs.comparators.sort_by_label_but_underscore_last,
        }

        for _, source in ipairs(opts.sources) do
            cmp_lsp_rs.filter_out.entry_filter(source)
        end

        return opts
    end,
    keys = {
        { "fCe", "<cmd>lua require('utils.codeium').enable()<cr>", desc = "Enable" },
        { "fCd", "<cmd>lua require('utils.codeium').disable()<cr>", desc = "Disable" },
    },
}
