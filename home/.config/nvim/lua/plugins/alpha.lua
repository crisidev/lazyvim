local plenary_path = require("plenary.path")
local mini = require("mini.icons")
local theme = require("config.theme")

local use_last_commit = false

local function get_last_config_commit_date()
    local handle = io.popen("git -C " .. vim.fn.stdpath("config") .. " log -1 --format=%ct")
    if not handle then
        return 0
    else
        local result = handle:read("*a")
        handle:close()
        return tonumber(result)
    end
end

-- Calculates the time since the last modification or the last commit date
local function time_since_last_config_change()
    local last_modified = 0

    if use_last_commit then
        last_modified = get_last_config_commit_date()
    else
        local config_dir = vim.fn.stdpath("config")
        local files = vim.fn.split(vim.fn.glob(config_dir .. "/**/*.lua"), "\n")

        for _, file in pairs(files) do
            local modified_time = vim.fn.getftime(file)
            last_modified = modified_time > last_modified and modified_time or last_modified
        end
    end

    local current_time = os.time()
    local diff_seconds = os.difftime(current_time, last_modified)
    local days = vim.fn.floor(diff_seconds / 86400)
    local hours = vim.fn.floor((diff_seconds % 86400) / 3600)
    local minutes = vim.fn.floor((diff_seconds % 3600) / 60)
    local seconds = vim.fn.floor(diff_seconds % 60)

    return string.format("%02d", days),
        string.format("%02d", hours),
        string.format("%02d", minutes),
        string.format("%02d", seconds)
end

local function get_extension(fn)
    local match = fn:match("^.+(%..+)$")
    local ext = ""
    if match ~= nil then
        ext = match:sub(2)
    end
    return ext
end

local function icon(fn)
    local ext = get_extension(fn)
    if type(ext) == "string" then
        return mini.get("extension", ext)
    end
    if type(fn) == "string" then
        return mini.get("file", fn)
    end
end

local function shortcut_and_short_fn(cwd, fn, i, start)
    local target_width = 70
    local short_fn
    if cwd then
        short_fn = vim.fn.fnamemodify(fn, ":.")
    else
        short_fn = vim.fn.fnamemodify(fn, ":~")
    end

    if #short_fn > target_width then
        short_fn = plenary_path.new(short_fn):shorten(1, { -2, -1 })
        if #short_fn > target_width then
            short_fn = plenary_path.new(short_fn):shorten(1, { -1 })
        end
    end

    return tostring(i + start - 1), short_fn
end

local function header()
    local lines = {}

    for i, chars in pairs(theme.alpha_banner()) do
        local line = {
            type = "text",
            val = chars,
            opts = {
                hl = "StartLogo" .. i,
                shrink_margin = false,
                position = "center",
            },
        }

        table.insert(lines, line)
    end

    return {
        type = "group",
        val = lines,
    }
end

local function text(message, hl, pos)
    if not hl then
        hl = "String"
    end
    if not pos then
        pos = "center"
    end
    return {
        type = "text",
        val = message,
        opts = {
            position = pos,
            hl = hl,
        },
    }
end

local function button(sc, txt, keybind)
    local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

    local opts = {
        position = "center",
        text = txt,
        shortcut = sc,
        cursor = 5,
        width = 80,
        align_shortcut = "right",
        hl_shortcut = "Number",
        hl = "Function",
    }
    if keybind then
        opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
    end

    return {
        type = "button",
        val = txt,
        on_press = function()
            local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
            vim.api.nvim_feedkeys(key, "normal", false)
        end,
        opts = opts,
    }
end

local function file_button(fn, sc, short_fn, autocd, cmd)
    short_fn = short_fn or fn
    local ico_txt
    local fb_hl = {}

    local ico, hl = icon(fn)
    if hl then
        table.insert(fb_hl, { hl, 0, #ico })
    end
    ico_txt = ico .. "  "
    local file_button_el
    if not cmd then
        local cd_cmd = (autocd and " | cd %:p:h" or "")
        file_button_el = button(sc, ico_txt .. short_fn, "<cmd>e " .. vim.fn.fnameescape(fn) .. cd_cmd .. " <cr>")
    else
        file_button_el = button(sc, ico_txt .. short_fn, cmd)
    end
    local fn_start = short_fn:match(".*[/\\]")
    if fn_start ~= nil then
        table.insert(fb_hl, { "Comment", #ico_txt - 2, #fn_start + #ico_txt })
    end
    file_button_el.opts.hl = fb_hl
    return file_button_el
end

local function recent_files(start, cwd, items_number, opts)
    opts = opts
        or {

            ignore = function(path, ext)
                return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains({ "gitcommit" }, ext))
            end,
            autocd = false,
        }
    items_number = vim.F.if_nil(items_number, 10)

    local oldfiles = {}
    for _, v in pairs(vim.v.oldfiles) do
        if #oldfiles == items_number then
            break
        end
        local cwd_cond
        if not cwd then
            cwd_cond = true
        else
            cwd_cond = vim.startswith(v, cwd)
        end
        local ignore = (opts.ignore and opts.ignore(v, get_extension(v))) or false
        if (vim.fn.filereadable(v) == 1) and cwd_cond and not ignore then
            oldfiles[#oldfiles + 1] = v
        end
    end

    local tbl = {}
    for i, fn in ipairs(oldfiles) do
        local shortcut, short_fn = shortcut_and_short_fn(cwd, fn, i, start)
        tbl[i] = file_button(fn, shortcut, short_fn, opts.autocd)
    end
    return {
        type = "group",
        val = tbl,
        opts = {},
    }
end

local function recent_sessions(start, cwd, items_number)
    items_number = vim.F.if_nil(items_number, 10)
    local persistence = require("persistence")
    local sessions = {}
    for _, v in ipairs(persistence.list()) do
        local _, end_index = string.find(v, "%%") -- Find index of first '%'
        local remaining_path = string.sub(v, end_index + 1) -- Extract path after '%'
        local fn = string.gsub(remaining_path, "%%", "/")
        fn = "/" .. string.gsub(fn, "%.vim$", "")
        table.insert(sessions, { fn = fn, path = v, mtime = vim.loop.fs_stat(v).mtime.sec })
    end
    table.sort(sessions, function(a, b)
        return a.mtime > b.mtime
    end)

    local tbl = {}
    for i, session in ipairs(sessions) do
        if i > items_number then
            break
        end
        local _, end_index = string.find(session.path, "%%") -- Find index of first '%'
        if end_index then
            local shortcut, short_fn = shortcut_and_short_fn(cwd, session.fn, i, start)
            local file_button_el = file_button(
                session.fn,
                shortcut,
                short_fn,
                false,
                "<cmd>silent! source " .. vim.fn.fnameescape(session.path) .. "<cr>"
            )
            tbl[i] = file_button_el
        end
    end

    return {
        type = "group",
        val = tbl,
        opts = {},
    }
end

local function mru()
    return {
        type = "group",
        val = {
            {
                type = "text",
                val = "Files",
                opts = {
                    hl = "String",
                    shrink_margin = false,
                    position = "center",
                },
            },
            { type = "padding", val = 1 },
            {
                type = "group",
                val = function()
                    return { recent_files(0, vim.fn.getcwd()) }
                end,
                opts = { shrink_margin = false },
            },
        },
    }
end

local function sessions()
    return {
        type = "group",
        val = {
            {
                type = "text",
                val = "Sessions",
                opts = {
                    hl = "String",
                    shrink_margin = false,
                    position = "center",
                },
            },
            { type = "padding", val = 1 },
            {
                type = "group",
                val = function()
                    return { recent_sessions(10, vim.fn.getcwd()) }
                end,
                opts = { shrink_margin = false },
            },
        },
    }
end

local function buttons()
    return {
        type = "group",
        name = "some",
        val = {
            {
                type = "text",
                val = "Actions",
                opts = {
                    hl = "String",
                    shrink_margin = false,
                    position = "center",
                },
            },
            { type = "padding", val = 1 },
            {
                type = "group",
                val = {
                    button("r", theme.icons.clock .. " Smart open", "<cmd>Telescope smart_open<cr>"),
                    button(
                        "l",
                        theme.icons.magic .. " Last session",
                        "<cmd>lua require('persistence').load({ last = true })<cr>"
                    ),
                    button(
                        "z",
                        theme.icons.folder .. " Zoxide",
                        "<cmd>lua require('telescope').extensions.zoxide.list()<cr>"
                    ),
                    button("f", theme.icons.file .. " Find file", function()
                        local builtin = require("telescope.builtin")
                        local utils = require("telescope.utils")
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
                    end),
                    button("s", theme.icons.text .. " Find word", "<cmd>Telescope live_grep_args hidden=true<cr>"),
                    button("n", theme.icons.stuka .. " New file", "<cmd>ene <BAR> startinsert <cr>"),
                    button("b", theme.icons.files .. " File browser", "<cmd>Telescope file_browser<cr>"),
                    button("q", theme.icons.exit .. " Quit", "<cmd>quit<cr>"),
                },
                opts = { shrink_margin = false },
            },
        },
    }
end

local function footer()
    return {
        type = "text",
        val = require("alpha.fortune")(),
        opts = {
            position = "center",
        },
    }
end

return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        -- close Lazy and re-open when the dashboard is ready
        if vim.o.filetype == "lazy" then
            vim.cmd.close()
            vim.api.nvim_create_autocmd("User", {
                once = true,
                pattern = "AlphaReady",
                callback = function()
                    require("lazy").show()
                end,
            })
        end

        local vim_version = {}
        if vim.version().prerelease == "dev" then
            vim_version = text(
                "│ "
                    .. theme.icons.vim
                    .. "Neovim nightly v"
                    .. vim.version().major
                    .. "."
                    .. vim.version().minor
                    .. "."
                    .. vim.version().patch
                    .. "  │"
            )
        else
            vim_version = text(
                "│ "
                    .. theme.icons.vim
                    .. "Neovim stable v"
                    .. vim.version().major
                    .. "."
                    .. vim.version().minor
                    .. "."
                    .. vim.version().patch
                    .. "   │"
            )
        end

        local stats = require("lazy").stats()
        local days, hours, minutes, seconds = time_since_last_config_change()
        local opts = {
            layout = {
                { type = "padding", val = 1 },
                header(),
                { type = "padding", val = 1 },
                text("╭───────────────────────────╮"),
                text("│ " .. theme.icons.calendar .. "Today is " .. os.date("%a %d %b") .. "     │"),
                vim_version,
                text("│ " .. theme.icons.package .. stats.loaded .. "/" .. stats.count .. " plugins loaded    │"),
                text(
                    "│ "
                        .. theme.icons.config
                        .. "Changed "
                        .. days
                        .. "d "
                        .. hours
                        .. "h "
                        .. minutes
                        .. "m "
                        .. seconds
                        .. "s │"
                ),
                text("╰───────────────────────────╯"),
                { type = "padding", val = 1 },
                mru(),
                { type = "padding", val = 1 },
                buttons(),
                { type = "padding", val = 1 },
                sessions(),
                { type = "padding", val = 1 },
                footer(),
            },
        }

        require("alpha").setup(opts)
    end,
    keys = function()
        return {
            { "<leader>;", "<cmd>Alpha<cr>", desc = "Dashboard" },
        }
    end,
}
