local function smart_quit()
    local bufnr = vim.api.nvim_get_current_buf()
    local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
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

return {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
        local theme = require("config.theme")
        local builtin = require("bufferline.groups").builtin

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

        local function diagnostic_indicator(_, _, diagnostics, _)
            local result = {}
            local symbols = { error = theme.diagnostics_icons.Error, warning = theme.diagnostics_icons.Warn }
            for name, count in pairs(diagnostics) do
                if symbols[name] and count > 0 then
                    table.insert(result, symbols[name] .. count)
                end
            end
            local res = table.concat(result, " ")
            return #res > 0 and res or ""
        end

        local function config_file_matcher(buf)
            return vim.api.nvim_buf_get_name(buf.id):match("go.mod")
                or vim.api.nvim_buf_get_name(buf.id):match("go.sum")
                or vim.api.nvim_buf_get_name(buf.id):match("Cargo.toml")
                or vim.api.nvim_buf_get_name(buf.id):match("manage.py")
                or vim.api.nvim_buf_get_name(buf.id):match("config.toml")
                or vim.api.nvim_buf_get_name(buf.id):match("setup.py")
                or vim.api.nvim_buf_get_name(buf.id):match("pyproject.toml")
                or vim.api.nvim_buf_get_name(buf.id):match("Makefile")
                or vim.api.nvim_buf_get_name(buf.id):match("Config")
                or vim.api.nvim_buf_get_name(buf.id):match("gradle.properties")
                or vim.api.nvim_buf_get_name(buf.id):match("build.gradle.kt")
                or vim.api.nvim_buf_get_name(buf.id):match("settings.gradle.kt")
        end

        local function test_file_matcher(buf)
            return vim.api.nvim_buf_get_name(buf.id):match("_spec") or vim.api.nvim_buf_get_name(buf.id):match("test_")
        end

        local function doc_file_matcher(buf)
            local p_list = require("plenary.collections.py_list")
            local list = p_list({ "md", "org", "norg", "wiki", "rst", "txt" })
            return list:contains(vim.fn.fnamemodify(buf.path, ":e"))
        end

        opts.options.separator_style = "slant"
        opts.options.sort_by = "insert_after_current"
        opts.options.diagnostics_indicator = diagnostic_indicator
        opts.options.groups = {
            options = {
                toggle_hidden_on_enter = true,
            },
            items = {
                builtin.pinned:with({ icon = "⭐" }),
                builtin.ungrouped,
                language_group("rs", "rs", theme.colors.red),
                language_group("py", "py", theme.colors.green),
                language_group("kt", "kt", theme.colors.magenta),
                language_group("js", "java", theme.colors.white),
                language_group("lua", "lua", theme.colors.yellow),
                language_group("rb", "rb", theme.colors.red1),
                language_group("go", "go", theme.colors.blue),
                {
                    highlight = { sp = theme.colors.purple },
                    name = "tests",
                    icon = theme.icons.test,
                    matcher = test_file_matcher,
                },
                {
                    highlight = { sp = theme.colors.blue5 },
                    name = "docs",
                    icon = theme.icons.docs,
                    matcher = doc_file_matcher,
                },
                {
                    highlight = { sp = theme.colors.bg_br },
                    name = "cfg",
                    theme.icons.config,
                    matcher = config_file_matcher,
                },
                {
                    highlight = { sp = theme.colors.bg },
                    name = "terms",
                    auto_close = true,
                    matcher = function(buf)
                        return buf.path:match("term://") ~= nil
                    end,
                },
            },
        }
        return opts
    end,
    keys = function()
        return {
            { "<F1>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer", mode = { "n", "i" } },
            { "<F2>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer", mode = { "n", "i" } },
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
            {
                "<leader>Q",
                smart_quit,
                desc = require("config.theme").icons.no .. "Quit",
            },
        }
    end,
}
