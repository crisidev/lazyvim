local function process_grep_under_text(value, opts)
    local helpers = require("telescope-live-grep-args.helpers")
    opts = opts or {}
    opts = vim.tbl_extend("force", {
        -- postfix = " -f ",
        quote = true,
        trim = true,
    }, opts)

    if opts.trim then
        value = vim.trim(value)
    end

    if opts.quote then
        value = helpers.quote(value, opts)
    end

    if opts.postfix then
        value = value .. opts.postfix
    end

    return value
end

local function layout_config()
    return {
        width = 0.9,
        height = 0.4,
        prompt_position = "bottom",
        horizontal = {
            preview_width = 0.32,
            preview_cutoff = 135,
        },
        vertical = {
            width = 0.9,
            height = 0.4,
            preview_height = 0.5,
            preview_width = 0.32,
            preview_cutoff = 135,
        },
        flex = {
            horizontal = {
                preview_width = 0.32,
                preview_cutoff = 135,
            },
            vertical = {
                preview_height = 0.5,
                preview_cutoff = 135,
            },
        },
    }
end

local function mappings()
    local actions = require("telescope.actions")
    return {
        n = {
            ["<esc>"] = actions.close,
            ["<c-c>"] = actions.close,
            ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
            ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
            ["<c-n>"] = actions.cycle_history_next,
            ["<c-p>"] = actions.cycle_history_prev,
            ["<c-x>"] = require("telescope.actions.layout").toggle_preview,
        },
        i = {
            ["<esc>"] = actions.close,
            ["<c-c>"] = actions.close,
            ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
            ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
            ["<c-n>"] = actions.cycle_history_next,
            ["<c-p>"] = actions.cycle_history_prev,
            ["<c-x>"] = require("telescope.actions.layout").toggle_preview,
        },
    }
end

return {
    "nvim-telescope/telescope.nvim",
    opts = {
        defaults = {
            sorting_strategy = "descending",
            layout_strategy = "bottom_pane",
            layout_config = layout_config(),
            mappings = mappings(),
        },
    },
    dependencies = {
        {
            "nvim-telescope/telescope-live-grep-args.nvim",
            module = "telescope._extensions.live_grep_args",
            lazy = true,
        },
        {
            "danielfalk/smart-open.nvim",
            branch = "0.2.x",
            dependencies = {
                "kkharji/sqlite.lua",
                "nvim-telescope/telescope-fzy-native.nvim",
            },
            module = "telescope._extensions.smart_open",
            lazy = true,
        },
        {
            "jvgrootveld/telescope-zoxide",
            module = "telescope._extensions.zoxide",
            lazy = true,
        },
        {
            "nvim-telescope/telescope-file-browser.nvim",
            module = "telescope._extensions.file_browser",
            lazy = true,
        },
        {
            "crispgm/telescope-heading.nvim",
            module = "telescope._extensions.heading",
            lazy = true,
        },
    },
    keys = function()
        local builtin = require("telescope.builtin")
        local utils = require("telescope.utils")
        return {
            -- Main group
            {
                "<leader>T",
                "<cmd>Telescope resume<cr>",
                desc = "Last Search",
            },
            {
                "<leader>i",
                function()
                    local text = vim.fn.expand("<cword>")
                    local opts = {
                        hidden = true,
                        default_text = process_grep_under_text(text),
                    }
                    require("telescope").extensions.live_grep_args.live_grep_args(opts)
                end,
                desc = "Find Identifier",
            },
            {
                "<leader>i",
                function()
                    local function get_visual()
                        local _, ls, cs = unpack(vim.fn.getpos("v"))
                        local _, le, ce = unpack(vim.fn.getpos("."))

                        -- nvim_buf_get_text requires start and end args be in correct order
                        ls, le = math.min(ls, le), math.max(ls, le)
                        cs, ce = math.min(cs, ce), math.max(cs, ce)

                        return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
                    end
                    local visual = get_visual()

                    local text = visual[1] or ""
                    local opts = {
                        hidden = true,
                        default_text = process_grep_under_text(text),
                    }
                    require("telescope").extensions.live_grep_args.live_grep_args(opts)
                end,
                desc = "Find Visual Selection",

                mode = { "x" },
            },
            {
                "<leader>e",
                "<cmd>Telescope file_browser hidden=true<cr>",
                desc = "File Browser",
            },
            {
                "<leader>f",
                function()
                    local opts = {
                        cwd = vim.loop.cwd(),
                    }
                    local _, ret = utils.get_os_command_output({ "git", "rev-parse", "--show-toplevel" }, opts.cwd)
                    if ret ~= 0 then
                        local in_worktree =
                            utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" }, opts.cwd)
                        local in_bare =
                            utils.get_os_command_output({ "git", "rev-parse", "--is-bare-repository" }, opts.cwd)
                        if in_worktree[1] ~= "true" and in_bare[1] ~= "true" then
                            builtin.find_files(opts)
                            return
                        end
                    end
                    builtin.git_files(opts)
                end,
                desc = "Find Project Files",
            },
            {
                "<leader>F",
                "<cmd>Telescope find_files hidden=true<cr>",
                desc = "Find All Files",
            },

            {
                "<leader>s",
                "<cmd>Telescope live_grep_args hidden=true<cr>",
                desc = "Find String",

                mode = { "n" },
            },
            {
                "<leader>s",
                function()
                    local visual_selection = function()
                        local save_previous = vim.fn.getreg("a")
                        vim.api.nvim_command('silent! normal! "ay')
                        local selection = vim.fn.trim(vim.fn.getreg("a"))
                        vim.fn.setreg("a", save_previous)
                        local ret = vim.fn.substitute(selection, [[\n]], [[\\n]], "g")
                        return ret
                    end
                    builtin.live_grep({ default_text = visual_selection() })
                end,
                desc = "Find String",

                mode = { "x" },
            },
            {
                "<leader>r",
                "<cmd>Telescope smart_open<cr>",

                desc = "Smart Open",
            },
            {
                "<leader>z",
                "<cmd>lua require('telescope').extensions.zoxide.list()<cr>",

                desc = "Zoxide",
            },
            {
                "<leader>b",
                function()
                    local opts = {
                        on_complete = {
                            function(_picker)
                                vim.cmd("startinsert")
                            end,
                        },
                    }
                    builtin.buffers(opts)
                end,
                desc = "Buffers",
            },
            {
                "<leader>Q",
                function()
                    local bufnr = vim.api.nvim_get_current_buf()
                    local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
                    vim.cmd("Neotree close")
                    if modified then
                        vim.ui.input({
                            prompt = "You have unsaved changes. Quit anyway? (y/n) ",
                        }, function(input)
                            if input == "y" then
                                vim.cmd("q")
                            end
                        end)
                    else
                        vim.cmd("q!")
                    end
                end,
                desc = "Quit",
            },
            {
                "<leader>C",
                "<cmd>TodoTelescope<cr>",
                desc = "Todos",
            },
            {
                "<leader>H",
                "<cmd>Telescope heading<cr>",
                desc = "Heading",
            },
        }
    end,
}
