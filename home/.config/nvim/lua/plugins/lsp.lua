local theme = require("config.theme")

local function symbol_usage_configure()
    local text_format = function(symbol)
        local res = {}
        local ins = table.insert

        local round_start = { theme.symbol_usage.circle_left, "SymbolUsageRounding" }
        local round_end = { theme.symbol_usage.circle_right, "SymbolUsageRounding" }

        if symbol.references and symbol.references > 0 then
            local usage = symbol.references <= 1 and "usage" or "usages"
            local num = symbol.references == 0 and "no" or symbol.references
            ins(res, round_start)
            ins(res, { theme.symbol_usage.ref, "SymbolUsageRef" })
            ins(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
            ins(res, round_end)
        end

        if symbol.definition and symbol.definition > 0 then
            if #res > 0 then
                table.insert(res, { " ", "NonText" })
            end
            ins(res, round_start)
            ins(res, { theme.symbol_usage.def, "SymbolUsageDef" })
            ins(res, { symbol.definition .. " defs", "SymbolUsageContent" })
            ins(res, round_end)
        end

        if symbol.implementation and symbol.implementation > 0 then
            if #res > 0 then
                table.insert(res, { " ", "NonText" })
            end
            ins(res, round_start)
            ins(res, { theme.symbol_usage.impl, "SymbolUsageImpl" })
            ins(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
            ins(res, round_end)
        end

        return res
    end

    local function h(name)
        return vim.api.nvim_get_hl(0, { name = name })
    end

    vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("CursorLine").bg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageContent", { bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true })
    ---@diagnostic disable-next-line: missing-fields
    require("symbol-usage").setup({
        vt_position = "end_of_line",
        text_format = text_format,
        references = { enabled = true, include_declaration = false },
        definition = { enabled = true },
        implementation = { enabled = true },
        disable = { filetypes = { "sh" } },
    })
end

return {
    {
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
                keys = {
                    { "gCe", "<cmd>lua require('config.codeium').enable()<cr>", desc = "Enable" },
                    { "gCd", "<cmd>lua require('config.codeium').disable()<cr>", desc = "Disable" },
                },
            },
            {
                "ravibrock/spellwarn.nvim",
                event = "VeryLazy",
                config = true,
            },
        },
        opts = function(_, opts)
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
            for i, item in pairs(opts.sources) do
                if item.name == "path" then
                    opts.sources[i] = { name = "async_path" }
                end
                if item.name == "nvim_lsp" then
                    opts.sources[i] = {
                        name = "nvim_lsp",
                        env_filter = function(entry, ctx)
                            return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
                        end,
                    }
                end
            end
            opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
                { name = "git" },
                { name = "emoji" },
                { name = "nerdfont" },
                { name = "dotenv" },
            }))
            opts.experimental.ghost_text = false
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "crisidev/nvim-lightbulb",
                config = function()
                    local lightbulb = require("nvim-lightbulb")
                    lightbulb.setup({
                        autocmd = {
                            enabled = true,
                            -- updatetime = 500,
                        },
                        code_lenses = true,
                        sign = {
                            enabled = true,
                            text = theme.icons.code_action,
                            lens_text = theme.icons.codelens,
                            hl = "MoreMsg",
                        },
                        ignore = {
                            clients = { "bacon-ls", "lua_ls", "typos_lsp" },
                        },
                    })
                end,
            },
            {
                "Wansmer/symbol-usage.nvim",
                event = "LspAttach",
                lazy = true,
                config = symbol_usage_configure,
            },
            {
                "aznhe21/actions-preview.nvim",
                event = "LspAttach",
                lazy = true,
                config = function()
                    require("actions-preview").setup({
                        telescope = {
                            sorting_strategy = "descending",
                            layout_strategy = "bottom_pane",
                        },
                    })
                end,
            },
            {
                "icholy/lsplinks.nvim",
                event = "LspAttach",
                lazy = true,
                config = function()
                    require("lsplinks").setup()
                end,
            },
        },
        opts = {
            diagnostics = {
                virtual_text = false,
                update_in_insert = true,
                float = {
                    spacing = 4,
                    border = "rounded",
                    focusable = true,
                    source = "if_many",
                },
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = theme.diagnostics_icons.Error,
                        [vim.diagnostic.severity.WARN] = theme.diagnostics_icons.Warn,
                        [vim.diagnostic.severity.HINT] = theme.diagnostics_icons.Hint,
                        [vim.diagnostic.severity.INFO] = theme.diagnostics_icons.Info,
                    },
                },
            },
            codelens = { enabled = true },
            servers = {
                typos_lsp = { enabled = true },
                gitlab_ci_ls = { enabled = true },
                snyk_ls = { enabled = true, autostart = false },
            },
            setup = {
                typos_lsp = function()
                    require("lspconfig").typos_lsp.setup({
                        init_options = {
                            diagnosticSeverity = "Hint",
                        },
                    })
                    return true
                end,
            },
        },
        init = function()
            local function diagnostics(direction, level)
                if direction == "next" then
                    vim.diagnostic.jump({ count = 1, severity = { min = level } })
                else
                    vim.diagnostic.jump({ count = -1, severity = { min = level } })
                end
            end

            local function toggle_inlay_hints(buf, value)
                local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
                if type(ih) == "function" then
                    ih(buf, value)
                elseif type(ih) == "table" and ih.enable then
                    if value == nil then
                        value = not ih.is_enabled(buf)
                    end
                    ih.enable(value)
                end
            end

            local keys = {
                {
                    "gF",
                    "<cmd>lua vim.lsp.buf.format({ async = true })<cr>",
                    mode = { "n", "x" },
                    icon = theme.icons.magic,
                    desc = "Format File",
                },
                {
                    "gA",
                    "<cmd>lua vim.lsp.codelens.run()<cr>",
                    desc = "Code Lens",
                    icon = theme.icons.codelens,
                    mode = { "n", "x" },
                },
                {
                    "gL",
                    "<cmd>lua vim.lsp.codelens.refresh()<cr>",
                    desc = "Refresh Lenses",
                    icon = theme.icons.codelens,
                    mode = { "n", "x" },
                },
                {
                    "ga",
                    "<cmd>lua require('actions-preview').code_actions()<cr>",
                    desc = "Code Actions",
                    icon = theme.icons.codelens,
                    mode = { "n", "x" },
                },
                {
                    "<c-k>",
                    "<cmd>lua vim.lsp.buf.signature_help()<cr>",
                    desc = "Signature Help",
                    icon = theme.icons.Function,
                    mode = "i",
                },
                {
                    "gz",
                    "<cmd>lua vim.lsp.buf.signature_help()<cr>",
                    desc = "Signature Help",
                    icon = theme.icons.Function,
                },
                {
                    "gg",
                    "<cmd>Telescope lsp_definitions<cr>",
                    desc = "Goto Definition",
                    icon = theme.icons.go,
                },
                {
                    "gt",
                    "<cmd>Telescope lsp_type_definitions<cr>",
                    desc = "Goto Type Definition",
                    icon = theme.icons.go,
                },
                {
                    "gd",
                    "<cmd>lua vim.lsp.buf.declaration()<cr>",
                    desc = "Goto Declaration",
                    icon = theme.icons.go,
                },
                {
                    "gr",
                    "<cmd>Telescope lsp_references jump_type=never<cr>",
                    desc = "Goto References",
                    icon = theme.icons.go,
                },
                {
                    "gi",
                    "<cmd>Telescope lsp_implementations jump_type=never reuse_win=true<cr>",
                    desc = "Goto Implementations",
                    icon = theme.icons.go,
                },
                {
                    "gl",
                    "<cmd>lua vim.diagnostic.open_float({ border = 'rounded', focusable = true })<cr>",
                    desc = "Line Diagnostics",
                    icon = theme.diagnostics_icons.Hint,
                },
                {
                    "gR",
                    "<cmd>lua vim.lsp.buf.rename()<cr>",
                    desc = "Rename Symbol",
                    icon = theme.icons.rename,
                },
                {
                    "gx",
                    require("lsplinks").gx,
                    desc = "Open Link",
                    icon = theme.icons.world,
                },
                {
                    "gN",
                    function()
                        diagnostics("next", vim.diagnostic.severity.ERROR)
                    end,
                    desc = "Next ERROR",
                    icon = theme.diagnostics_icons.Error,
                },
                {
                    "gP",
                    function()
                        diagnostics("prev", vim.diagnostic.severity.ERROR)
                    end,
                    desc = "Previous ERROR",
                    icon = theme.diagnostics_icons.Error,
                },
                {
                    "gn",
                    function()
                        diagnostics("next", vim.diagnostic.severity.WARN)
                    end,
                    desc = "Next WARN",
                    icon = theme.diagnostics_icons.Warn,
                },
                {
                    "gp",
                    function()
                        diagnostics("prev", vim.diagnostic.severity.WARN)
                    end,
                    desc = "Previous WARN",
                    icon = theme.diagnostics_icons.Warn,
                },
                {
                    "gT",
                    function()
                        diagnostics("next", vim.diagnostic.severity.HINT)
                    end,
                    desc = "Next HINT",
                    icon = theme.diagnostics_icons.Hint,
                },
                {
                    "ge",
                    "<cmd>Telescope diagnostics<cr>",
                    desc = "Diagnostics",
                    icon = theme.diagnostics_icons.Hint,
                },
                {
                    "gw",
                    function(buf, value)
                        local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
                        if type(ih) == "function" then
                            ih(buf, value)
                        elseif type(ih) == "table" and ih.enable then
                            if value == nil then
                                value = not ih.is_enabled(buf)
                            end
                            ih.enable(value)
                        end
                    end,
                    desc = "Toggle Inlay Hints",
                    icon = theme.icons.inlay,
                },
                {
                    "gk",
                    "<cmd>LspStart snyk_ls<cr>",
                    desc = "Enable Snyk",
                    icon = theme.icons.codelens,
                },
                {
                    "gW",
                    function()
                        local save_cursor = vim.fn.getpos(".")
                        vim.cmd([[%s/\s\+$//e]])
                        vim.fn.setpos(".", save_cursor)
                    end,
                    desc = "Trim Whitespaces",
                    icon = theme.icons.project,
                },
                { "gD", "", hidden = true },
                { "gI", "", hidden = true },
                { "gy", "", hidden = true },
                { "gh", "", hidden = true },
                { "gH", "", hidden = true },
                { "g[", "", hidden = true },
                { "g]", "", hidden = true },
                { "g]", "", hidden = true },
            }
            require("which-key").add(keys)
        end,
    },
}
