local colors = require("config.theme").colors
local icons = require("config.theme").icons
local file_icons = require("config.theme").file_icons
local mode_icons = require("config.theme").modes_icons
local codeium = require("utils.codeium")
local nls = require("null-ls")

local mode_color = {
    n = colors.git.delete,
    i = colors.green,
    v = colors.yellow,
    [""] = colors.blue,
    V = colors.yellow,
    c = colors.cyan,
    no = colors.magenta,
    s = colors.orange,
    S = colors.orange,
    [""] = colors.orange,
    ic = colors.yellow,
    R = colors.violet,
    Rv = colors.violet,
    cv = colors.red,
    ce = colors.red,
    r = colors.cyan,
    rm = colors.cyan,
    ["r?"] = colors.cyan,
    ["!"] = colors.red,
    t = colors.red,
}

local file_icon_colors = {
    Brown = "#905532",
    Aqua = "#3AFFDB",
    Blue = "#689FB6",
    DarkBlue = "#44788E",
    Purple = "#834F79",
    Red = "#AE403F",
    Beige = "#F5C06F",
    Yellow = "#F09F17",
    Orange = "#D4843E",
    DarkOrange = "#F16529",
    Pink = "#CB6F6F",
    Salmon = "#EE6E73",
    Green = "#8FAA54",
    LightGreen = "#31B53E",
    White = "#FFFFFF",
    LightBlue = "#5fd7ff",
}

local window_numbers = {
    "󰼏 ",
    "󰼐 ",
    "󰼑 ",
    "󰼒 ",
    "󰼓 ",
    "󰼔 ",
    "󰼕 ",
    "󰼖 ",
    "󰼗 ",
    "󰿪 ",
}

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    hide_small = function()
        return vim.fn.winwidth(0) > 120
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
}

local function format_file_size(file)
    local size = vim.fn.getfsize(file)
    if size <= 0 then
        return ""
    end
    local sufixes = { "b", "k", "m", "g" }
    local i = 1
    while size > 1024 do
        size = size / 1024
        i = i + 1
    end
    return string.format("%.1f%s", size, sufixes[i])
end

local function get_file_info()
    return vim.fn.expand("%:t"), vim.fn.expand("%:e")
end

local function get_file_icon()
    local icon
    local ok, devicons = pcall(require, "nvim-web-devicons")
    if not ok then
        print("No icon plugin found. Please install 'kyazdani42/nvim-web-devicons'")
        return ""
    end
    local f_name, f_extension = get_file_info()
    icon = devicons.get_icon(f_name, f_extension)
    if icon == nil then
        icon = icons.question
    end
    return icon
end

local function get_file_icon_color()
    local f_name, f_ext = get_file_info()
    local has_devicons, devicons = pcall(require, "nvim-web-devicons")
    if has_devicons then
        local icon, iconhl = devicons.get_icon(f_name, f_ext)
        if icon ~= nil then
            return vim.fn.synIDattr(vim.fn.hlID(iconhl), "fg")
        end
    end

    local icon = get_file_icon():match("%S+")
    for k, _ in pairs(file_icons) do
        if vim.fn.index(file_icons[k], icon) ~= -1 then
            return file_icon_colors[k]
        end
    end
end

local function list_nls_providers(filetype)
    local s = require("null-ls.sources")
    local available_sources = s.get_available(filetype)
    local registered = {}
    for _, source in ipairs(available_sources) do
        for method in pairs(source.methods) do
            registered[method] = registered[method] or {}
            table.insert(registered[method], source.name)
        end
    end
    return registered
end

local function list_registered_formatters(filetype)
    local registered_providers = list_nls_providers(filetype)
    return registered_providers[nls.methods.FORMATTING] or {}
end

local function list_registered_linters(filetype)
    local registered_providers = list_nls_providers(filetype)
    local providers_for_methods = vim.iter(vim.tbl_map(function(m)
        return registered_providers[m] or {}
    end, {
        nls.methods.DIAGNOSTICS,
        nls.methods.DIAGNOSTICS_ON_OPEN,
        nls.methods.DIAGNOSTICS_ON_SAVE,
    }))
        :flatten()
        :totable()

    return providers_for_methods
end

local function mode()
    local mod = vim.fn.mode()
    if mod == "n" or mod == "no" or mod == "nov" then
        return mode_icons.n
    elseif mod == "i" or mod == "ic" or mod == "ix" then
        return mode_icons.i
    elseif mod == "V" or mod == "v" or mod == "vs" or mod == "Vs" or mod == "cv" then
        return mode_icons.v
    elseif mod == "c" or mod == "ce" then
        return mode_icons.c
    elseif mod == "r" or mod == "rm" or mod == "r?" then
        return mode_icons.r
    elseif mod == "R" or mod == "Rc" or mod == "Rv" or mod == "Rv" then
        return mode_icons.R
    else
        return mode_icons.d
    end
end

local function remove_duplicates(input_table)
    local unique_values = {}
    local result_table = {}

    for _, value in ipairs(input_table) do
        if not unique_values[value] then
            unique_values[value] = true
            table.insert(result_table, value)
        end
    end

    return result_table
end

return {
    "nvim-lualine/lualine.nvim",
    opts = function()
        -- PERF: we don't need this lualine require madness 🤷
        local lualine_require = require("lualine_require")
        lualine_require.require = require

        vim.o.laststatus = vim.g.lualine_laststatus

        return {
            options = {
                theme = require("config.theme").lualine(),
                globalstatus = true,
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                always_divide_middle = true,
                disabled_filetypes = {
                    "dashboard",
                    "NvimTree",
                    "neo-tree",
                    "Outline",
                    "alpha",
                    "vista",
                    "vista_kind",
                    "TelescopePrompt",
                },
            },
            sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {
                    {
                        function()
                            return mode()
                        end,
                        color = function()
                            return { fg = mode_color[vim.fn.mode()], bg = colors.bg }
                        end,
                        padding = { left = 1, right = 0 },
                    },
                    {
                        "b:gitsigns_head",
                        icon = " " .. icons.git,
                        cond = conditions.check_git_workspace,
                        color = { fg = colors.blue, bg = colors.bg },
                        padding = 0,
                    },
                    {
                        function()
                            vim.api.nvim_command(
                                "hi! LualineFileIconColor guifg=" .. get_file_icon_color() .. " guibg=" .. colors.bg
                            )
                            local fname = vim.fn.expand("%:p")
                            if string.find(fname, "term://") ~= nil then
                                return icons.term
                            end
                            local winnr = vim.api.nvim_win_get_number(vim.api.nvim_get_current_win())
                            if winnr > 10 then
                                winnr = 10
                            end
                            local win = window_numbers[winnr]
                            return win .. " " .. get_file_icon()
                        end,
                        padding = { left = 2, right = 0 },
                        cond = conditions.buffer_not_empty,
                        color = "LualineFileIconColor",
                        gui = "bold",
                    },
                    {
                        function()
                            local fname = vim.fn.expand("%:p")
                            local ftype = vim.bo.filetype
                            local cwd = vim.api.nvim_call_function("getcwd", {})
                            if string.find(fname, "zsh;#toggleterm") ~= nil then
                                return icons.term .. " " .. cwd
                            elseif string.find(fname, "lazygit;#toggleterm") ~= nil then
                                local git_repo_cmd = io.popen('git remote get-url origin | tr -d "\n"')
                                local git_repo = git_repo_cmd:read("*a")
                                git_repo_cmd:close()
                                local git_branch_cmd = io.popen('git branch --show-current | tr -d "\n"')
                                local git_branch = git_branch_cmd:read("*a")
                                git_branch_cmd:close()
                                return icons.term .. " " .. git_repo .. "~" .. git_branch
                            elseif #ftype < 1 and string.find(fname, "term") ~= nil then
                                return icons.term
                            end
                            local show_name = vim.fn.expand("%:t")
                            local modified = ""
                            if vim.bo.modified then
                                modified = "  "
                            end
                            return show_name .. modified
                        end,
                        cond = conditions.buffer_not_empty,
                        padding = { left = 1, right = 1 },
                        color = { fg = colors.fg, gui = "bold", bg = colors.bg },
                    },
                    {
                        "diff",
                        source = function()
                            local gitsigns = vim.b.gitsigns_status_dict
                            if gitsigns then
                                return {
                                    added = gitsigns.added,
                                    modified = gitsigns.changed,
                                    removed = gitsigns.removed,
                                }
                            end
                        end,
                        symbols = {
                            added = icons.added,
                            modified = icons.modified,
                            removed = icons.removed,
                        },
                        diff_color = {
                            added = { fg = colors.git.add, bg = colors.bg },
                            modified = { fg = colors.git.change, bg = colors.bg },
                            removed = { fg = colors.git.delete, bg = colors.bg },
                        },
                        color = {},
                        cond = nil,
                    },
                    {
                        function()
                            return icons.circle_right
                        end,
                        padding = { left = 0, right = 0 },
                        color = { fg = colors.bg },
                        cond = nil,
                    },
                },

                lualine_x = {
                    {
                        function()
                            return icons.circle_left
                        end,
                        padding = { left = 0, right = 0 },
                        color = { fg = colors.bg },
                        cond = nil,
                    },
                    {
                        function()
                            if not vim.bo.readonly or not vim.bo.modifiable then
                                return ""
                            end
                            return icons.lock -- """
                        end,
                        color = { fg = colors.red },
                    },
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        symbols = { error = icons.error, warn = icons.warn, info = icons.info, hint = icons.hint },
                        cond = conditions.hide_in_width,
                        color = { fg = colors.fg, bg = colors.bg },
                    },
                    {
                        function()
                            local buf_clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
                            if next(buf_clients) == nil then
                                return ""
                            end
                            for _, client in pairs(buf_clients) do
                                if client.name == "null-ls" then
                                    return " " .. icons.code_lens_action
                                end
                            end
                            return ""
                        end,
                        padding = 0,
                        color = { fg = colors.blue, bg = colors.bg },
                        cond = conditions.hide_in_width,
                    },
                    {
                        function()
                            if codeium.is_enabled() == nil then
                                return ""
                            else
                                return icons.copilot
                            end
                        end,
                        padding = 0,
                        color = { fg = colors.purple, bg = colors.bg },
                        cond = conditions.hide_in_width,
                    },
                    {
                        function()
                            local buf_clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
                            if next(buf_clients) == nil then
                                return ""
                            end
                            for _, client in pairs(buf_clients) do
                                if client.name == "typos_lsp" then
                                    return icons.typos
                                end
                            end
                            return ""
                        end,
                        padding = 0,
                        color = { fg = colors.yellow, bg = colors.bg },
                        cond = conditions.hide_in_width,
                    },
                    {
                        function()
                            if next(vim.treesitter.highlighter.active) then
                                return icons.treesitter
                            end
                            return ""
                        end,
                        padding = 0,
                        color = { fg = colors.green, bg = colors.bg },
                        cond = conditions.hide_in_width,
                    },
                    {
                        function(msg)
                            msg = msg or icons.ls_inactive
                            local buf_clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
                            if next(buf_clients) == nil then
                                if type(msg) == "boolean" or #msg == 0 then
                                    return icons.ls_inactive
                                end
                                return msg
                            end
                            local buf_ft = vim.bo.filetype
                            local buf_client_names = {}
                            local trim_width = 100
                            local trim = vim.fn.winwidth(0) < trim_width

                            for _, client in pairs(buf_clients) do
                                if not (client.name == "null-ls" or client.name == "typos_lsp") then
                                    local _added_client = client.name
                                    if trim then
                                        _added_client = string.sub(client.name, 1, 4)
                                    end
                                    table.insert(buf_client_names, _added_client)
                                end
                            end

                            -- add formatter
                            local supported_formatters = {}
                            for _, fmt in pairs(list_registered_formatters(buf_ft)) do
                                local _added_formatter = fmt
                                if trim then
                                    _added_formatter = string.sub(fmt, 1, 4)
                                end
                                table.insert(supported_formatters, _added_formatter)
                            end
                            vim.list_extend(buf_client_names, supported_formatters)

                            -- add linter
                            local supported_linters = {}
                            for _, lnt in pairs(list_registered_linters(buf_ft)) do
                                local _added_linter = lnt
                                if trim then
                                    _added_linter = string.sub(lnt, 1, 4)
                                end
                                table.insert(supported_linters, _added_linter)
                            end
                            vim.list_extend(buf_client_names, supported_linters)

                            local client_names = {}
                            if #buf_client_names > 4 then
                                for i = 1, 4 do
                                    client_names[i] = buf_client_names[i]
                                end
                                client_names[5] = icons.right
                            else
                                client_names = buf_client_names
                            end
                            client_names = remove_duplicates(client_names)
                            return icons.ls_active .. table.concat(client_names, " ")
                        end,
                        color = { fg = colors.fg, bg = colors.bg },
                        cond = conditions.hide_in_width,
                    },
                    {
                        "location",
                        padding = 0,
                        color = { fg = colors.orange, bg = colors.bg },
                    },
                    {
                        function()
                            local file = vim.fn.expand("%:p")
                            if string.len(file) == 0 then
                                return ""
                            end
                            return format_file_size(file)
                        end,
                        cond = conditions.buffer_not_empty,
                        color = { fg = colors.fg, bg = colors.bg },
                    },
                    {
                        "fileformat",
                        fmt = string.upper,
                        icons_enabled = true,
                        color = { fg = colors.green, gui = "bold", bg = colors.bg },
                        cond = conditions.hide_in_width,
                    },
                    {
                        function()
                            local current_line = vim.fn.line(".")
                            local total_lines = vim.fn.line("$")
                            local chars =
                                { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
                            local line_ratio = current_line / total_lines
                            local index = math.ceil(line_ratio * #chars)
                            return chars[index]
                        end,
                        padding = 0,
                        color = { fg = colors.yellow, bg = colors.bg },
                        cond = nil,
                    },
                },
                lualine_y = {},
                lualine_z = {},
            },
            extensions = { "neo-tree", "lazy" },
        }
    end,
}
