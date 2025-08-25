---@diagnostic disable: deprecated
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

local function diagnostics(direction, level)
    if direction == "next" then
        if vim.fn.has("0.10") then
            vim.diagnostic.goto_next({
                count = 1,
                severity = { min = level },
                float = true,
                focusable = true,
            })
        else
            vim.diagnostic.jump({ count = 1, severity = { min = level }, float = true, focusable = true })
        end
    else
        if vim.fn.has("0.10") then
            vim.diagnostic.goto_prev({
                count = -1,
                severity = { min = level },
                float = true,
                focusable = true,
            })
        else
            vim.diagnostic.jump({ count = -1, severity = { min = level }, float = true, focusable = true })
        end
    end
end

return {
    {
        "xzbdmw/colorful-menu.nvim",
        config = function()
            require("colorful-menu").setup({})
        end,
    },
    {
        "saghen/blink.cmp",
        dependencies = {
            "moyiz/blink-emoji.nvim",
            "MahanRahmati/blink-nerdfont.nvim",
            -- "Kaiser-Yang/blink-cmp-avante",
            {
                "Kaiser-Yang/blink-cmp-dictionary",
                dependencies = { "nvim-lua/plenary.nvim" },
            },
        },
        opts = {
            sources = {
                default = {
                    -- "avante",
                    "emoji",
                    "nerdfont",
                    "dictionary",
                },
                providers = {
                    emoji = {
                        module = "blink-emoji",
                        name = "Emoji",
                        score_offset = 15,
                        opts = { insert = true },
                        should_show_items = function()
                            return vim.tbl_contains({ "gitcommit", "markdown", "txt" }, vim.o.filetype)
                        end,
                    },
                    nerdfont = {
                        module = "blink-nerdfont",
                        name = "Nerd Fonts",
                        score_offset = 15,
                        opts = { insert = true },
                        should_show_items = function()
                            return vim.tbl_contains({ "gitcommit", "markdown", "txt" }, vim.o.filetype)
                        end,
                    },
                    -- avante = {
                    --     module = "blink-cmp-avante",
                    --     name = "Avante",
                    --     opts = {},
                    -- },
                    dictionary = {
                        module = "blink-cmp-dictionary",
                        name = "Dict",
                        min_keyword_length = 3,
                        opts = {
                            dictionary_files = { "/usr/share/dict/british-english" },
                        },
                        should_show_items = function()
                            return vim.tbl_contains({ "gitcommit", "markdown", "txt" }, vim.o.filetype)
                        end,
                    },
                },
            },
            completion = {
                ghost_text = { enabled = false },
                menu = {
                    draw = {
                        columns = { { "label", gap = 1 }, { "kind_icon", "kind" } },
                        components = {
                            kind_icon = { width = { fill = true } },
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(ctx)
                                end,
                            },
                        },
                    },
                },
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "kosayoda/nvim-lightbulb",
                opts = {
                    autocmd = { enabled = true },
                    code_lenses = true,
                    sign = {
                        enabled = true,
                        text = theme.icons.code_action,
                        lens_text = theme.icons.codelens,
                        hl = "MoreMsg",
                    },
                    ignore = {
                        clients = { "bacon_ls", "lua_ls", "harper_ls" },
                    },
                },
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
                gitlab_ci_ls = { enabled = true },
                harper_ls = { enabled = true },
                protobuf_language_server = { enabled = false },
                blueprint_ls = { enabled = true },
            },
            setup = {
                bacon_ls = function()
                    require("lspconfig").bacon_ls.setup({
                        root_dir = function(fname)
                            local util = require("lspconfig.util")
                            local root_files = {
                                "Cargo.toml",
                                "Cargo.lock",
                            }
                            return util.root_pattern(unpack(root_files))(fname)
                                or util.root_pattern(".git")(fname)
                                or util.path.dirname(fname)
                        end,
                        init_options = {
                            useCargoBackend = true,
                        },
                    })
                    return true
                end,
                clangd = function()
                    require("lspconfig").clangd.setup({
                        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }, -- exclude "proto".
                    })
                    return true
                end,
                harper_ls = function()
                    require("lspconfig").harper_ls.setup({
                        settings = {
                            ["harper-ls"] = {
                                linters = {
                                    diagnosticSeverity = "hint",
                                    codeActions = {
                                        forceStable = true,
                                    },
                                },
                            },
                        },
                    })
                    return true
                end,
                nil_ls = function()
                    require("lspconfig").nil_ls.setup({
                        settings = {
                            ["nil"] = {
                                nix = {
                                    flake = {
                                        autoArchive = true,
                                    },
                                },
                                formatting = {
                                    command = { "nix", "fmt", "--", "--" },
                                },
                            },
                        },
                    })
                    return true
                end,
                ruff = function()
                    LazyVim.lsp.on_attach(function(client, _)
                        if client.name == "ruff" then
                            client.server_capabilities.documentFormattingProvider = false
                        end
                    end)
                end,
            },
        },
        keys = function()
            return {
                {
                    "gF",
                    "<cmd>lua vim.lsp.buf.format({ async = true })<cr>",
                    mode = { "n", "x" },

                    desc = "Format File",
                },
                {
                    "gA",
                    "<cmd>lua vim.lsp.codelens.run()<cr>",
                    desc = "Code Lens",

                    mode = { "n", "x" },
                },
                {
                    "gL",
                    "<cmd>lua vim.lsp.codelens.refresh()<cr>",
                    desc = "Refresh Lenses",

                    mode = { "n", "x" },
                },
                {
                    "ga",
                    "<cmd>lua require('actions-preview').code_actions()<cr>",
                    desc = "Code Actions",

                    mode = { "n", "x" },
                },
                {
                    "<c-k>",
                    "<cmd>lua vim.lsp.buf.signature_help()<cr>",
                    desc = "Signature Help",

                    mode = "i",
                },
                {
                    "gz",
                    "<cmd>lua vim.lsp.buf.signature_help()<cr>",
                    desc = "Signature Help",
                },
                {
                    "gg",
                    "<cmd>Telescope lsp_definitions<cr>",
                    desc = "Goto Definition",
                },
                {
                    "gt",
                    "<cmd>Telescope lsp_type_definitions<cr>",
                    desc = "Goto Type Definition",
                },
                {
                    "gd",
                    "<cmd>lua vim.lsp.buf.declaration()<cr>",
                    desc = "Goto Declaration",
                },
                {
                    "gO",
                    "<cmd>Telescope lsp_document_symbols<cr>",
                    desc = "Document Symbols",
                },
                {
                    "gr",
                    "<cmd>Telescope lsp_references jump_type=never<cr>",
                    desc = "Goto References",
                },
                {
                    "gi",
                    "<cmd>Telescope lsp_implementations jump_type=never reuse_win=true<cr>",
                    desc = "Goto Implementations",
                },
                {
                    "gl",
                    "<cmd>lua vim.diagnostic.open_float({ border = 'rounded', focusable = true })<cr>",
                    desc = "Line Diagnostics",
                },
                {
                    "gR",
                    "<cmd>lua vim.lsp.buf.rename()<cr>",
                    desc = "Rename Symbol",
                },
                {
                    "gx",
                    require("lsplinks").gx,
                    desc = "Open Link",
                },
                {
                    "gN",
                    function()
                        diagnostics("next", vim.diagnostic.severity.ERROR)
                    end,
                    desc = "Next ERROR",
                },
                {
                    "gP",
                    function()
                        diagnostics("prev", vim.diagnostic.severity.ERROR)
                    end,
                    desc = "Previous ERROR",
                },
                {
                    "gn",
                    function()
                        diagnostics("next", vim.diagnostic.severity.WARN)
                    end,
                    desc = "Next WARN",
                },
                {
                    "gp",
                    function()
                        diagnostics("prev", vim.diagnostic.severity.WARN)
                    end,
                    desc = "Previous WARN",
                },
                {
                    "gT",
                    function()
                        diagnostics("next", vim.diagnostic.severity.HINT)
                    end,
                    desc = "Next HINT",
                },
                {
                    "ge",
                    "<cmd>Telescope diagnostics<cr>",
                    desc = "Diagnostics",
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
                },
                {
                    "gW",
                    function()
                        local save_cursor = vim.fn.getpos(".")
                        vim.cmd([[%s/\s\+$//e]])
                        vim.fn.setpos(".", save_cursor)
                    end,
                    desc = "Trim Whitespaces",
                },
                {
                    "gb",
                    require("dap").toggle_breakpoint,
                    desc = "Toggle Breakpoint",
                },
            }
        end,
    },
}
