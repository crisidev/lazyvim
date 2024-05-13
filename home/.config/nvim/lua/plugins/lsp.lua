return {
    {
        "aznhe21/actions-preview.nvim",
        event = "LspAttach",
        lazy = true,
        config = function()
            require("actions-preview").setup({
                telescope = {
                    sorting_strategy = "ascending",
                    layout_strategy = "vertical",
                    layout_config = {
                        width = 0.8,
                        height = 0.9,
                        prompt_position = "top",
                        preview_cutoff = 20,
                        preview_height = function(_, _, max_lines)
                            return max_lines - 20
                        end,
                    },
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
    {
        "Wansmer/symbol-usage.nvim",
        event = "LspAttach",
        lazy = true,
        config = function()
            local text_format = function(symbol)
                local theme = require("config.theme")
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
            vim.api.nvim_set_hl(
                0,
                "SymbolUsageContent",
                { bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true }
            )
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
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            local python = require("utils.lang.python")
            local theme = require("config.theme")
            opts.diagnostics = {
                virtual_text = false,
                update_in_insert = true,
                float = {
                    spacing = 4,
                    border = "rounded",
                    focusable = true,
                    source = "if_many",
                },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = theme.diagnostics_icons.Error,
                        [vim.diagnostic.severity.WARN] = theme.diagnostics_icons.Warn,
                        [vim.diagnostic.severity.HINT] = theme.diagnostics_icons.Hint,
                        [vim.diagnostic.severity.INFO] = theme.diagnostics_icons.Info,
                    },
                },
            }
            opts.inlay_hints = { enabled = true }
            opts.servers = {
                typos_lsp = { enabled = true },
                basedpyright = { enabled = true, cmd = python.basedpyright_cmd() },
                ruff_lsp = { enabled = true, cmd = python.ruff_lsp_cmd() },
                gitlab_ci_ls = { enabled = true },
                snyk_ls = { enabled = true, autostart = false },
            }
            opts.setup = {
                typos_lsp = function(_, opts)
                    require("lspconfig").typos_lsp.setup({
                        init_options = {
                            diagnosticSeverity = "Hint",
                        },
                    })
                    return true
                end,
                ruff_lsp = function(_, opts)
                    LazyVim.lsp.on_attach(function(client, _)
                        if client.name == "ruff_lsp" then
                            client.server_capabilities.documentFormattingProvider = false
                        end
                    end)
                end,
            }
            return opts
        end,
        init = function()
            local theme = require("config.theme")

            local function show_documentation()
                local filetype = vim.bo.filetype
                if vim.tbl_contains({ "vim", "help" }, filetype) then
                    vim.cmd("h " .. vim.fn.expand("<cword>"))
                elseif vim.fn.expand("%:t") == "Cargo.toml" then
                    require("crates").show_popup()
                elseif vim.tbl_contains({ "man" }, filetype) then
                    vim.cmd("Man " .. vim.fn.expand("<cword>"))
                elseif filetype == "rust" then
                    vim.cmd.RustLsp({ "hover", "actions" })
                else
                    vim.lsp.buf.hover()
                end
            end

            local function diagnostics(direction, level)
                if direction == "next" then
                    vim.diagnostic.goto_next({ severity = { min = level } })
                else
                    vim.diagnostic.goto_prev({ severity = { min = level } })
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

            require("lazyvim.plugins.lsp.keymaps")._keys = {}
            local keys = require("lazyvim.plugins.lsp.keymaps").get()
            keys[#keys + 1] = {
                "fF",
                "<cmd>lua vim.lsp.buf.format({ async = true })<cr>",
                mode = { "n", "x" },
                desc = theme.icons.magic .. "Format file",
            }
            keys[#keys + 1] = { "K", show_documentation, desc = "Hover" }
            keys[#keys + 1] = {
                "fA",
                "<cmd>lua vim.lsp.codelens.run()<cr>",
                desc = theme.icons.codelens .. "Code lens",
                mode = { "n", "x" },
                has = "codeLens",
            }
            keys[#keys + 1] = {
                "fa",
                "<cmd>lua require('actions-preview').code_actions()<cr>",
                desc = theme.icons.codelens .. "Code actions",
                mode = { "n", "x" },
                has = "codeAction",
            }
            keys[#keys + 1] = {
                "<c-k>",
                "<cmd>lua vim.lsp.buf.signature_help()<cr>",
                mode = "i",
                desc = "Signature Help",
                has = "signatureHelp",
            }
            keys[#keys + 1] = {
                "fz",
                "<cmd>lua vim.lsp.buf.signature_help()<cr>",
                desc = theme.icons.Function .. "Signature Help",
                has = "signatureHelp",
            }
            keys[#keys + 1] = {
                "ff",
                "<cmd>lua vim.lsp.buf.definition()<cr>",
                desc = theme.icons.go .. "Goto definition",
                has = "definition",
            }
            keys[#keys + 1] = {
                "ft",
                "<cmd>lua require('utils.telescope').lsp_type_definitions()<cr>",
                desc = theme.icons.go .. "Goto type definition",
            }
            keys[#keys + 1] = {
                "fd",
                "<cmd>lua vim.lsp.buf.declaration()<cr>",
                desc = theme.icons.go .. "Goto declaration",
            }
            keys[#keys + 1] = {
                "fr",
                "<cmd>lua require('utils.telescope').lsp_references()<cr>",
                desc = theme.icons.go .. "References",
            }
            keys[#keys + 1] = {
                "fi",
                "<cmd>lua require('utils.telescope').lsp_implementations()<cr>",
                desc = theme.icons.go .. "Implementations",
            }
            keys[#keys + 1] = {
                "fl",
                "<cmd>lua vim.diagnostic.open_float({ border = 'rounded', focusable = true })<cr>",
                desc = theme.diagnostics_icons.Hint .. "Line diagnostics",
            }
            keys[#keys + 1] =
                { "fR", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = theme.icons.rename .. "Rename", has = "rename" }
            keys[#keys + 1] = { "fx", require("lsplinks").gx, desc = theme.icons.world .. "Open link" }
            keys[#keys + 1] = {
                "fN",
                function()
                    diagnostics("next", vim.diagnostic.severity.ERROR)
                end,
                desc = theme.diagnostics_icons.Error .. "Next ERROR",
            }
            keys[#keys + 1] = {
                "fP",
                function()
                    diagnostics("prev", vim.diagnostic.severity.ERROR)
                end,
                desc = theme.diagnostics_icons.Error .. "Previous ERROR",
            }
            keys[#keys + 1] = {
                "fn",
                function()
                    diagnostics("next", vim.diagnostic.severity.WARN)
                end,
                desc = theme.diagnostics_icons.Warn .. "Next diagnostic",
            }
            keys[#keys + 1] = {
                "fp",
                function()
                    diagnostics("prev", vim.diagnostic.severity.WARN)
                end,
                desc = theme.diagnostics_icons.Warn .. "Previous diagnostic",
            }
            keys[#keys + 1] = {
                "fT",
                function()
                    diagnostics("next", vim.diagnostic.severity.HINT)
                end,
                desc = theme.diagnostics_icons.Hint .. "Next typo",
            }
            keys[#keys + 1] = {
                "fe",
                "<cmd>Trouble diagnostics<cr>",
                desc = theme.diagnostics_icons.Hint .. "Diagnostics",
            }
            keys[#keys + 1] = {
                "fw",
                toggle_inlay_hints,
                desc = theme.icons.inlay .. "Toggle inlays",
            }
            keys[#keys + 1] = {
                "fk",
                "<cmd>LspStart snyk_ls<cr>",
                desc = theme.icons.codelens .. "Enable snyk",
            }

            keys[#keys + 1] = {
                "fW",
                "<cmd>lua require('utils.whitespaces').trim(true)<cr>",
                desc = theme.icons.project .. "Trim whitespaces",
            }
        end,
    },
}
