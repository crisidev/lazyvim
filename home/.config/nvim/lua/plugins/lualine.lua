local theme = require("config.theme")
local colors = require("config.theme").colors
local icons = require("config.theme").icons
local diagnostics_icons = require("config.theme").diagnostics_icons
local lazy_icons = require("lazyvim.config").icons
local file_icons = require("config.theme").file_icons
local mode_icons = require("config.theme").modes_icons
local nls = require("null-ls")

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

local function get_file_icon_color(file_icon)
    local f_name, f_ext = get_file_info()
    local has_devicons, devicons = pcall(require, "nvim-web-devicons")
    if has_devicons then
        local icon, iconhl = devicons.get_icon(f_name, f_ext)
        if icon ~= nil then
            return vim.fn.synIDattr(vim.fn.hlID(iconhl), "fg")
        end
    end

    local icon = file_icon:match("%S+")
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

local function lsp_server_icon(name, icon)
    local buf_clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
    if next(buf_clients) == nil then
        return ""
    end
    for _, client in pairs(buf_clients) do
        if client.name == name then
            return icon
        end
    end
    return ""
end

local function vim_mode()
    return {
        function()
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
        end,
        color = function()
            return { fg = mode_color[vim.fn.mode()], bg = colors.bg }
        end,
        padding = { left = 1, right = 0 },
    }
end

local function git()
    return {
        "b:gitsigns_head",
        icon = " " .. icons.git,
        cond = conditions.check_git_workspace,
        color = { fg = colors.blue, bg = colors.bg },
        padding = 0,
    }
end

local function file_icon()
    return {
        function()
            local fi = get_file_icon()
            vim.api.nvim_command("hi! LualineFileIconColor guifg=" .. get_file_icon_color(fi) .. " guibg=" .. colors.bg)
            local fname = vim.fn.expand("%:p")
            if string.find(fname, "term://") ~= nil then
                return icons.term
            end
            local winnr = vim.api.nvim_win_get_number(vim.api.nvim_get_current_win())
            if winnr > 10 then
                winnr = 10
            end
            local win = window_numbers[winnr]
            return win .. " " .. fi
        end,
        padding = { left = 2, right = 0 },
        cond = conditions.buffer_not_empty,
        color = "LualineFileIconColor",
        gui = "bold",
    }
end

local function file_name()
    return {
        function()
            local show_name = vim.fn.expand("%:t")
            local modified = ""
            if vim.bo.modified then
                modified = " " .. icons.floppy
            end
            return show_name .. modified
        end,
        padding = { left = 1, right = 1 },
        color = { fg = colors.fg, gui = "bold", bg = colors.bg },
        cond = conditions.buffer_not_empty,
    }
end

local function diff()
    return {
        "diff",
        symbols = {
            added = lazy_icons.git.added,
            modified = lazy_icons.git.modified,
            removed = lazy_icons.git.removed,
        },
        diff_color = {
            added = { fg = colors.git.add, bg = colors.bg },
            modified = { fg = colors.git.change, bg = colors.bg },
            removed = { fg = colors.git.delete, bg = colors.bg },
        },
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
    }
end

local function lazy_status()
    return {
        require("lazy.status").updates,
        cond = require("lazy.status").has_updates,
        color = { fg = colors.orange, bg = colors.bg },
    }
end

local function circle_icon(direction)
    return {
        function()
            if direction == "left" then
                return icons.circle_left
            else
                return icons.circle_right
            end
        end,
        padding = { left = 0, right = 0 },
        color = { fg = colors.bg },
    }
end

local function treesitter()
    return {
        function()
            if next(vim.treesitter.highlighter.active) then
                return icons.treesitter
            end
            return ""
        end,
        padding = 0,
        color = { fg = colors.green, bg = colors.bg },
        cond = conditions.hide_in_width,
    }
end

local function file_size()
    return {
        function()
            local file = vim.fn.expand("%:p")
            if string.len(file) == 0 then
                return ""
            end
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
        end,

        color = { fg = colors.fg, bg = colors.bg },
        cond = conditions.buffer_not_empty,
    }
end

local function file_format()
    return {
        "fileformat",
        fmt = string.upper,
        icons_enabled = true,
        color = { fg = colors.green, gui = "bold", bg = colors.bg },
        cond = conditions.hide_in_width,
    }
end

local function lsp_servers()
    return {
        function()
            local buf_clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
            if next(buf_clients) == nil then
                return icons.ls_inactive .. "none"
            end
            local buf_ft = vim.bo.filetype
            local buf_client_names = {}
            local trim_width = 100
            local trim = vim.fn.winwidth(0) < trim_width

            for _, client in pairs(buf_clients) do
                if not (client.name == "null-ls" or client.name == "typos_lsp" or client.name == "harper_ls") then
                    local _added_client = client.name
                    if trim then
                        _added_client = string.sub(client.name, 1, 4)
                    end
                    table.insert(buf_client_names, _added_client)
                end
            end

            -- add formatter
            for _, fmt in pairs(list_registered_formatters(buf_ft)) do
                local _added_formatter = fmt
                if trim then
                    _added_formatter = string.sub(fmt, 1, 4)
                end
                table.insert(buf_client_names, _added_formatter)
            end

            -- add linter
            for _, lnt in pairs(list_registered_linters(buf_ft)) do
                local _added_linter = lnt
                if trim then
                    _added_linter = string.sub(lnt, 1, 4)
                end
                table.insert(buf_client_names, _added_linter)
            end

            if #buf_client_names == 0 then
                return icons.ls_inactive .. "none"
            else
                return icons.ls_active .. table.concat(buf_client_names, " ")
            end
        end,
        color = { fg = colors.fg, bg = colors.bg },
        cond = conditions.hide_in_width,
    }
end

local function location()
    return {
        "location",
        padding = 0,
        color = { fg = colors.orange, bg = colors.bg },
    }
end

local function file_position()
    return {
        function()
            local current_line = vim.fn.line(".")
            local total_lines = vim.fn.line("$")
            local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
            local line_ratio = current_line / total_lines
            local index = math.ceil(line_ratio * #chars)
            return chars[index]
        end,
        padding = 0,
        color = { fg = colors.yellow, bg = colors.bg },
    }
end

local function file_read_only()
    return {
        function()
            if not vim.bo.readonly or not vim.bo.modifiable then
                return ""
            end
            return string.gsub(icons.lock, "%s+", "")
        end,
        color = { fg = colors.red, bg = colors.bg },
    }
end

local function diagnostics()
    return {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = {
            error = diagnostics_icons.Error,
            warn = diagnostics_icons.Warn,
            info = diagnostics_icons.Info,
            hint = diagnostics_icons.Hint,
        },
        cond = conditions.hide_in_width,
        color = { fg = colors.fg, bg = colors.bg },
    }
end

local function dap_status()
    return {
        function()
            return icons.debug .. require("dap").status()
        end,
        cond = function()
            return package.loaded["dap"] and require("dap").status() ~= ""
        end,
        color = { fg = colors.red, bg = colors.bg },
    }
end

local function space()
    return {
        function()
            return " "
        end,
        padding = 0,
        color = { fg = colors.blue, bg = colors.bg },
        cond = conditions.hide_in_width,
    }
end

local function null_ls()
    return {
        function()
            return lsp_server_icon("null-ls", icons.code_lens_action)
        end,
        padding = 0,
        color = { fg = colors.blue, bg = colors.bg },
        cond = conditions.hide_in_width,
    }
end

local function typos_lsp()
    return {
        function()
            return lsp_server_icon("typos_lsp", icons.typos)
        end,
        padding = 0,
        color = { fg = colors.yellow, bg = colors.bg },
        cond = conditions.hide_in_width,
    }
end

local function harper_ls()
    return {
        function()
            return lsp_server_icon("harper_ls", icons.typos)
        end,
        padding = 0,
        color = { fg = colors.yellow, bg = colors.bg },
        cond = conditions.hide_in_width,
    }
end

return {
    "nvim-lualine/lualine.nvim",
    opts = {
        options = {
            -- theme = theme.lualine(),
            globalstatus = true,
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            always_divide_middle = true,
        },
        sections = {
            lualine_a = {
                vim_mode(),
            },
            lualine_b = {
                git(),
            },
            lualine_c = {
                file_icon(),
                file_name(),
                diff(),
                lazy_status(),
                circle_icon("right"),
            },
            lualine_x = {
                circle_icon("left"),
                diagnostics(),
            },
            lualine_y = {
                space(),
                dap_status(),
                treesitter(),
                typos_lsp(),
                harper_ls(),
                null_ls(),
                lsp_servers(),
            },
            lualine_z = {
                space(),
                location(),
                file_size(),
                file_read_only(),
                file_format(),
                file_position(),
            },
        },
    },
}
