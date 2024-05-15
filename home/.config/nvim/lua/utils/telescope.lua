local utils = require("telescope.utils")
local builtin = require("telescope.builtin")
local theme = require("config.theme")

local function get_visual()
    local _, ls, cs = unpack(vim.fn.getpos("v"))
    local _, le, ce = unpack(vim.fn.getpos("."))

    -- nvim_buf_get_text requires start and end args be in correct order
    ls, le = math.min(ls, le), math.max(ls, le)
    cs, ce = math.min(cs, ce), math.max(cs, ce)

    return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
end

local function process_grep_under_text(value, opts)
    local helpers = require("telescope-live-grep-args.helpers")
    opts = opts or {}
    opts = vim.tbl_extend("force", {
        postfix = " -F ",
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

local module = {}

function module.find_files()
    local opts = {
        hidden = true,
    }
    builtin.find_files(theme.telescope(opts))
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
            builtin.find_files(theme.telescope(opts))
            return
        end
    end
    builtin.git_files(theme.telescope(opts))
end

function module.file_browser()
    require("telescope").extensions.file_browser.file_browser(theme.telescope())
end

function module.resume()
    builtin.resume(theme.telescope())
end

function module.visual_selection()
    local visual = get_visual()
    local text = visual[1] or ""
    local opts = {
        hidden = true,
        default_text = process_grep_under_text(text),
    }
    require("telescope").extensions.live_grep_args.live_grep_args(theme.telescope(opts))
end

function module.find_identifier()
    local text = vim.fn.expand("<cword>")
    local opts = {
        hidden = true,
        default_text = process_grep_under_text(text),
    }
    require("telescope").extensions.live_grep_args.live_grep_args(theme.telescope(opts))
end

function module.find_string()
    local opts = {
        hidden = true,
    }
    require("telescope").extensions.live_grep_args.live_grep_args(theme.telescope(opts))
    -- builtin.live_grep(module.get_theme(opts))
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
    local opts = theme.telescope()
    opts["default_text"] = visual_selection()
    builtin.live_grep(opts)
end

function module.zoxide()
    require("telescope").extensions.zoxide.list(theme.telescope())
end

function module.smart_open()
    require("telescope").extensions.smart_open.smart_open(theme.telescope())
end

function module.buffers()
    local opts = theme.telescope()
    opts["on_complete"] = {
        function(_picker)
            vim.cmd("startinsert")
        end,
    }
    builtin.buffers(opts)
end

function module.lsp_references()
    local opts = { reuse_win = true }
    builtin.lsp_references(theme.telescope(opts))
end

function module.lsp_implementations()
    local opts = { reuse_win = true }
    builtin.lsp_implementations(theme.telescope(opts))
end

function module.lsp_type_definitions()
    local opts = { reuse_win = true }
    builtin.lsp_type_definitions(theme.telescope(opts))
end

function module.todo_comments(opts)
    require("telescope").extensions["todo-comments"].todo(theme.telescope(opts))
end

function module.lua_snips()
    require("telescope").extensions.luasnip.luasnip(theme.telescope())
end

function module.smart_quit()
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

return module
