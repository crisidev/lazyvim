local colors = require("config.theme").colors
local icons = require("config.theme").icons
local file_icons = require("config.theme").file_icons
local mode_icons = require("config.theme").modes_icons
local codeium = require("utils.codeium")
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

local module = {}

module.mode_color = {
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

module.conditions = {
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

module.vim_mode = function()
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

module.file_icon = function()
    local file_icon = get_file_icon()
    vim.api.nvim_command("hi! LualineFileIconColor guifg=" .. get_file_icon_color(file_icon) .. " guibg=" .. colors.bg)
    local fname = vim.fn.expand("%:p")
    if string.find(fname, "term://") ~= nil then
        return icons.term
    end
    local winnr = vim.api.nvim_win_get_number(vim.api.nvim_get_current_win())
    if winnr > 10 then
        winnr = 10
    end
    local win = window_numbers[winnr]
    return win .. " " .. file_icon
end

module.file_name = function()
    local show_name = vim.fn.expand("%:t")
    local modified = ""
    if vim.bo.modified then
        modified = " " .. icons.floppy
    end
    return show_name .. modified
end

module.lsp_server_icon = function(name, icon)
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

module.codeium = function()
    if codeium.is_enabled() == nil then
        return ""
    else
        return icons.copilot
    end
end

module.treesitter = function()
    if next(vim.treesitter.highlighter.active) then
        return icons.treesitter
    end
    return ""
end

module.file_size = function()
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
end

module.lsp_servers = function(msg)
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
    return icons.ls_active .. table.concat(buf_client_names, " ")
end

module.file_position = function()
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
    return chars[index]
end

module.file_read_only = function()
    if not vim.bo.readonly or not vim.bo.modifiable then
        return ""
    end
    return icons.lock
end

return module
