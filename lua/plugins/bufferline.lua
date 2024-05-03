local icons = require("config.theme").icons
local List = require("plenary.collections.py_list")

local function delete_buffer()
    local fn = vim.fn
    local cmd = vim.cmd
    local buflisted = fn.getbufinfo({ buflisted = 1 })
    local cur_winnr, cur_bufnr = fn.winnr(), fn.bufnr()
    if #buflisted < 2 then
        cmd("bd!")
        return
    end
    for _, winid in ipairs(fn.getbufinfo(cur_bufnr)[1].windows) do
        cmd(string.format("%d wincmd w", fn.win_id2win(winid)))
        cmd(cur_bufnr == buflisted[#buflisted].bufnr and "bp" or "bn")
    end
    cmd(string.format("%d wincmd w", cur_winnr))
    local is_terminal = fn.getbufvar(cur_bufnr, "&buftype") == "terminal"
    cmd(is_terminal and "bd! #" or "silent! confirm bd #")
end

local function smart_quit()
    local bufnr = vim.api.nvim_get_current_buf()
    local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
    vim.cmd("Neotree close")
    require("edgy").close()
    if modified then
        vim.ui.input({
            prompt = "You have unsaved changes. Quit anyway? (y/n) ",
        }, function(input)
            if input == "y" then
                vim.cmd("q!")
            end
        end)
    else
        vim.cmd("q!")
    end
end

local function language_group(name, extension, highlight)
    local opts = {
        highlight = { sp = highlight },
        name = name,
        matcher = function(buf)
            return vim.fn.fnamemodify(buf.path, ":e") == extension
        end,
    }
    return opts
end

vim.cmd("function! Quit_vim(a,b,c,d) \n qa \n endfunction")

return {
    "akinsho/bufferline.nvim",
    opts = {
        options = {
            separator_style = "slant",
            indicator = { style = "none" },
            max_name_length = 20,
            max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
            truncate_names = true,  -- whether or not tab names should be truncated
            tab_size = 25,
            color_icons = true,
            diagnostics_update_in_insert = true,
            show_close_icon = true,
            show_buffer_icons = true,
            show_buffer_close_icons = true,
            show_tab_indicators = true,
            navigation = { mode = "uncentered" },
            mode = "buffers",
            sort_by = "insert_after_current",
            always_show_bufferline = true,
            hover = { enabled = true, reveal = { "close" } },
            diagnostics = "nvim_lsp",
            diagnostics_indicator = function(_, _, diagnostics, _)
                local result = {}
                local symbols = { error = icons.error, warning = icons.warn }
                for name, count in pairs(diagnostics) do
                    if symbols[name] and count > 0 then
                        table.insert(result, symbols[name] .. count)
                    end
                end
                local res = table.concat(result, " ")
                return #res > 0 and res or ""
            end,
            groups = {
                options = {
                    toggle_hidden_on_enter = true,
                },
                items = {
                    require("bufferline.groups").builtin.pinned:with({ icon = "⭐" }),
                    require("bufferline.groups").builtin.ungrouped,
                    language_group("rs", "rs", "#b7410e"),
                    language_group("py", "py", "#195905"),
                    language_group("kt", "kt", "#75368f"),
                    language_group("js", "java", "#7db700"),
                    language_group("lua", "lua", "#ffb300"),
                    language_group("rb", "rb", "#ff4500"),
                    language_group("smithy", "smithy", "#009bff"),
                    language_group("go", "go", "#214b77"),
                    {
                        highlight = { sp = "#483d8b" },
                        name = "tests",
                        icon = icons.test,
                        matcher = function(buf)
                            return vim.api.nvim_buf_get_name(buf.id):match("_spec")
                                or vim.api.nvim_buf_get_name(buf.id):match("test_")
                        end,
                    },
                    {
                        highlight = { sp = "#636363" },
                        name = "docs",
                        matcher = function(buf)
                            local list = List({ "md", "org", "norg", "wiki", "rst", "txt" })
                            return list:contains(vim.fn.fnamemodify(buf.path, ":e"))
                        end,
                    },
                    {
                        highlight = { sp = "#636363" },
                        name = "cfg",
                        matcher = function(buf)
                            return vim.api.nvim_buf_get_name(buf.id):match("go.mod")
                                or vim.api.nvim_buf_get_name(buf.id):match("go.sum")
                                or vim.api.nvim_buf_get_name(buf.id):match("Cargo.toml")
                                or vim.api.nvim_buf_get_name(buf.id):match("manage.py")
                                or vim.api.nvim_buf_get_name(buf.id):match("config.toml")
                                or vim.api.nvim_buf_get_name(buf.id):match("setup.py")
                                or vim.api.nvim_buf_get_name(buf.id):match("Makefile")
                                or vim.api.nvim_buf_get_name(buf.id):match("Config")
                                or vim.api.nvim_buf_get_name(buf.id):match("gradle.properties")
                                or vim.api.nvim_buf_get_name(buf.id):match("build.gradle.kt")
                                or vim.api.nvim_buf_get_name(buf.id):match("settings.gradle.kt")
                        end,
                    },
                    {
                        highlight = { sp = "#000000" },
                        name = "terms",
                        auto_close = true,
                        matcher = function(buf)
                            return buf.path:match("term://") ~= nil
                        end,
                    },
                },
            },
            offsets = {
                {
                    text = "EXPLORER",
                    filetype = "neo-tree",
                    highlight = "PanelHeading",
                    text_align = "left",
                    separator = true,
                },
                {
                    text = "UNDOTREE",
                    filetype = "undotree",
                    highlight = "PanelHeading",
                    separator = true,
                },
                {
                    text = " LAZY",
                    filetype = "lazy",
                    highlight = "PanelHeading",
                    separator = true,
                },
                {
                    text = " DIFF VIEW",
                    filetype = "DiffviewFiles",
                    highlight = "PanelHeading",
                    separator = true,
                },
            },
            custom_areas = {
                right = function()
                    return {
                        { text = "%@Quit_vim@" .. icons.exit2 .. " %X", fg = "#f7768e" },
                    }
                end,
            },
        },
    },
    keys = function()
        return {
            { "<F1>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer", mode = { "n", "i" } },
            { "<F2>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer",     mode = { "n", "i" } },
            {
                "<A-S-Left>",
                "<cmd>BufferLineMovePrev<cr>",
                desc = "Move buffer left",
                mode = { "n", "i" },
            },
            {
                "<A-S-Right>",
                "<cmd>BufferLineMoveNext<cr>",
                desc = "Move buffer right",
                mode = { "n", "i" },
            },
            { "<leader>q", delete_buffer, desc = icons.no .. "Close buffer" },
            { "<leader>Q", smart_quit,    desc = icons.no .. "Quit" },
        }
    end,
}
