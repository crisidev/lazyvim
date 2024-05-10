local module = {}

local utils = require("telescope.utils")
local builtin = require("telescope.builtin")
local themes = require("telescope.themes")

function module.layout_config()
    return {
        width = 0.9,
        height = 0.4,
        preview_cutoff = 135,
        prompt_position = "bottom",
        horizontal = {
            preview_width = 0.32,
        },
        vertical = {
            width = 0.9,
            height = 0.4,
            preview_height = 0.5,
        },
        flex = {
            horizontal = {
                preview_width = 0.4,
            },
        },
    }
end

function module.get_theme(opts)
    if not opts then
        opts = {}
    end
    opts["layout_config"] = module.layout_config()
    opts["layout_config"]["preview_width"] = 0.4
    opts["sorting_strategy"] = "descending"
    return themes.get_ivy(opts)
end

function module.find_files()
    local opts = {
        hidden = true,
    }
    builtin.find_files(module.get_theme(opts))
end

function module.find_project_files(opts)
    opts = opts or {}
    if opts.cwd then
        opts.cwd = vim.fn.expand(opts.cwd)
    else
        opts.cwd = vim.loop.cwd()
    end

    local _, ret = utils.get_os_command_output({ "git", "rev-parse", "--show-toplevel" }, opts.cwd)
    if ret ~= 0 then
        local in_worktree = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" }, opts.cwd)
        local in_bare = utils.get_os_command_output({ "git", "rev-parse", "--is-bare-repository" }, opts.cwd)
        if in_worktree[1] ~= "true" and in_bare[1] ~= "true" then
            builtin.find_files(module.get_theme(opts))
            return
        end
    end
    builtin.git_files(module.get_theme(opts))
end

function module.file_browser()
    require("telescope").extensions.file_browser.file_browser(module.get_theme())
end

function module.resume()
    builtin.resume(module.get_theme())
end

function module.find_identifier()
    local opts = {
        hidden = true,
    }
    builtin.grep_string(module.get_theme(opts))
end

function module.only_certain_files()
    local opts = {
        find_command = {
            "rg",
            "--files",
            "--type",
            vim.fn.input("Type: "),
        },
    }
    builtin.find_files(module.get_theme(opts))
end

function module.find_string()
    local opts = {
        hidden = true,
    }
    builtin.live_grep(module.get_theme(opts))
end

function module.find_string_visual()
    local visual_selection = function()
        local save_previous = vim.fn.getreg("a")
        vim.api.nvim_command('silent! normal! "ay')
        local selection = vim.fn.trim(vim.fn.getreg("a"))
        vim.fn.setreg("a", save_previous)
        local ret = vim.fn.substitute(selection, [[\n]], [[\\n]], "g")
        return ret
    end
    local opts = module.get_theme()
    opts["default_text"] = visual_selection()
    builtin.live_grep(opts)
end

function module.zoxide()
    require("telescope").extensions.zoxide.list(module.get_theme())
end

function module.smart_open()
    require("telescope").extensions.smart_open.smart_open(module.get_theme())
end

function module.buffers()
    local opts = module.get_theme()
    opts["on_complete"] = {
        function(_picker)
            vim.cmd("startinsert")
        end,
    }
    builtin.buffers(opts)
end

function module.lsp_references()
    local opts = { reuse_win = true }
    builtin.lsp_references(module.get_theme(opts))
end

function module.lsp_implementations()
    local opts = { reuse_win = true }
    builtin.lsp_implementations(module.get_theme(opts))
end

function module.lsp_type_definitions()
    local opts = { reuse_win = true }
    builtin.lsp_type_definitions(module.get_theme(opts))
end

function module.todo_comments(opts)
    require("telescope").extensions["todo-comments"].todo(module.get_theme(opts))
end

return module
