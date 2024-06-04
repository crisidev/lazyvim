local module = {}

module.icons = {
    vim = " ",
    debug = " ",
    trace = "✎ ",
    code_action = "󰌵 ",
    code_lens_action = "󰄄 ",
    test = " ",
    docs = " ",
    clock = " ",
    calendar = " ",
    buffer = "󱡗 ",
    layers = " ",
    settings = " ",
    ls_active = "󰕮 ",
    ls_inactive = " ",
    question = " ",
    added = "  ",
    modified = " ",
    removed = " ",
    config = " ",
    git = " ",
    magic = " ",
    exit = " ",
    exit2 = " ",
    session = "󰔚 ",
    project = "⚝ ",
    stuka = " ",
    text = "󰊄 ",
    typos = "󰨸 ",
    files = " ",
    file = "󰈚 ",
    zoxide = " ",
    repo = " ",
    term = " ",
    palette = " ",
    buffers = "󰨝 ",
    telescope = " ",
    dashboard = "󰕮 ",
    boat = " ",
    unmute = "",
    mute = " ",
    quit = "󰗼 ",
    replace = " ",
    find = " ",
    comment = " ",
    ok = " ",
    no = " ",
    moon = " ",
    go = " ",
    resume = " ",
    codelens = "󰄄 ",
    folder = " ",
    package = " ",
    spelling = " ",
    copilot = " ",
    gpt = " ",
    attention = " ",
    Function = " ",
    power = "󰚥 ",
    zen = " ",
    music = " ",
    nuclear = "☢ ",
    treesitter = " ",
    lock = " ",
    presence_on = "󰅠 ",
    presence_off = " ",
    caret = "- ",
    flash = " ",
    world = " ",
    label = " ",
    link = "󰲔 ",
    person = " ",
    expanded = " ",
    collapsed = " ",
    circular = " ",
    circle_left = "",
    circle_right = "",
    neotest = "ﭧ ",
    rename = " ",
    amazon = " ",
    inlay = " ",
    pinned = " ",
    mind = " ",
    mind_tasks = "󱗽 ",
    mind_backlog = " ",
    mind_on_going = " ",
    mind_done = " ",
    mind_cancelled = " ",
    mind_notes = " ",
    button_off = " ",
    button_on = " ",
    up = " ",
    down = " ",
    todo = " ",
    right = " ",
    left = " ",
    outline = " ",
    window = "󱂬 ",
    cmdline = "",
    search_down = " ",
    search_up = " ",
    bash = "$",
    lua = "",
    help = "󰘥",
    calculator = "",
    ui = " ",
    snippets = "󱩽 ",
    floppy = " ",
    commander = "󰘳 ",
    gitlab = "󰮠 ",
}

module.battery_icons = {
    _100 = "􀛨",
    _75 = "􀺸",
    _50 = "􀺶",
    _25 = "􀛩",
    _0 = "􀛪",
    _charging = "􀢋",
}

module.dap_icons = {
    breakpoint = "",
    breakpoint_rejected = "",
    breakpoint_condition = "",
    stopped = "",
}

module.symbol_usage = {
    circle_left = "",
    circle_right = "",
    def = "󰳽 ",
    ref = "󰌹 ",
    impl = "󰡱 ",
}

module.languages = {
    c = " ",
    rust = "󱘗 ",
    js = " ",
    ts = " ",
    ruby = " ",
    vim = " ",
    git = " ",
    c_sharp = " ",
    python = " ",
    go = " ",
    java = " ",
    kotlin = " ",
    toml = "󰏗 ",
}

module.file_icons = {
    Brown = { "" },
    Aqua = { "" },
    LightBlue = { "", "" },
    Blue = { "", "", "", "", "", "", "", "", "", "", "", "", "" },
    DarkBlue = { "", "" },
    Purple = { "", "", "", "", "" },
    Red = { "", "", "", "", "", "" },
    Beige = { "", "", "" },
    Yellow = { "", "", "λ", "", "" },
    Orange = { "", "" },
    DarkOrange = { "", "", "", "", "" },
    Pink = { "", "" },
    Salmon = { "" },
    Green = { "", "", "", "", "", "" },
    LightGreen = { "", "", "", "﵂" },
    White = { "", "", "", "", "", "" },
}

module.colors = {
    cmp_border = "#181924",
    none = "NONE",
    bg_dark = "#1f2335",
    bg_alt = "#1a1b26",
    bg = "#24283b",
    bg_br = "#292e42",
    terminal_black = "#414868",
    fg = "#c0caf5",
    fg_dark = "#a9b1d6",
    fg_gutter = "#3b4261",
    dark3 = "#545c7e",
    comment = "#565f89",
    dark5 = "#737aa2",
    blue0 = "#3d59a1",
    blue = "#7aa2f7",
    cyan = "#7dcfff",
    blue1 = "#2ac3de",
    blue2 = "#0db9d7",
    blue5 = "#89ddff",
    blue6 = "#B4F9F8",
    blue7 = "#394b70",
    violet = "#bb9af7",
    magenta = "#bb9af7",
    magenta2 = "#ff007c",
    purple = "#9d7cd8",
    orange = "#ff9e64",
    yellow = "#e0af68",
    hlargs = "#e0af68",
    green = "#9ece6a",
    green1 = "#73daca",
    green2 = "#41a6b5",
    teal = "#1abc9c",
    red = "#f7768e",
    red1 = "#db4b4b",
    -- git = { change = "#6183bb", add = "#449dab", delete = "#914c54", conflict = "#bb7a61" },
    git = { change = "#6183bb", add = "#449dab", delete = "#f7768e", conflict = "#bb7a61" },
    gitSigns = { add = "#164846", change = "#394b70", delete = "#823c41" },
}

module.cmp_icons = {
    Class = " Class", -- Emoji for classes
    Color = " Color", -- Emoji for colors
    Constant = " Constant", -- Emoji for constants
    Enum = " Enum", -- Emoji for enums
    EnumMember = " Enum Member", -- Emoji for enum members
    Field = " Field", -- Emoji for fields
    File = " File", -- Emoji for files
    Folder = " Folder", -- Emoji for folders
    Function = "󰡱 Function", -- Emoji for functions
    Interface = " Interface", -- Emoji for interfaces
    Keyword = " Keyword", -- Emoji for keywords
    Method = " Method", -- Emoji for methods
    Module = "󰕳 Module", -- Emoji for modules
    Operator = " Operator", -- Emoji for operators
    Property = " Property", -- Emoji for properties
    Reference = " Reference", -- Emoji for references
    Snippet = " Snippet", -- Emoji for snippets
    Struct = " Struct", -- Emoji for structs
    Text = " Text", -- Emoji for text
    TypeParameter = " Typed Param", -- Emoji for type parameters
    Unit = "󰭍 Unit", -- Emoji for units
    Value = "󱇇 Value", -- Emoji for values
    Variable = " Variable", -- Emoji for variables
}

module.diagnostics_icons = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = "󰗖 ",
}

module.modes_icons = {
    n = " ",
    i = " ",
    v = " ",
    c = " ",
    r = " ",
    R = " ",
    d = " ",
}

function module.dap()
    vim.fn.sign_define("DapBreakpoint", {
        text = module.dap_icons.breakpoint,
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
    })
    vim.fn.sign_define("DapStopped", {
        text = module.dap_icons.stopped,
        texthl = "DiagnosticSignWarn",
        linehl = "Visual",
        numhl = "DiagnosticSignWarn",
    })
    vim.fn.sign_define("DapBreakpointRejected", {
        text = module.dap_icons.breakpoint_rejected,
        texthl = "DapBreakpoint",
        linehl = "DapBreakpoint",
        numhl = "DapBreakpoint",
    })
    vim.fn.sign_define("DapBreakpointCondition", {
        text = module.dap_icons.breakpoint_condition,
        texthl = "DapBreakpoint",
        linehl = "DapBreakpoint",
        numhl = "DapBreakpoint",
    })
    vim.fn.sign_define(
        "DapLogPoint",
        { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
    )
end

function module.cmp()
    vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = module.colors.blue5 })
    vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = module.colors.yellow })
    vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = module.colors.orange })
    vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = module.colors.blue })
    vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = module.colors.fg_dark })
    vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = module.colors.violet })
end

function module.lualine()
    local colors = require("tokyonight.colors").setup({ transform = true })
    local config = require("tokyonight.config").options
    local bg_statusline = "#1a1b26"

    local tokyonight = {}

    tokyonight.normal = {
        a = { bg = colors.blue, fg = colors.black },
        b = { bg = colors.fg_gutter, fg = colors.blue },
        c = { bg = bg_statusline, fg = colors.fg_sidebar },
    }

    tokyonight.insert = {
        a = { bg = colors.green, fg = colors.black },
        b = { bg = colors.fg_gutter, fg = colors.green },
    }

    tokyonight.command = {
        a = { bg = colors.yellow, fg = colors.black },
        b = { bg = colors.fg_gutter, fg = colors.yellow },
    }

    tokyonight.visual = {
        a = { bg = colors.magenta, fg = colors.black },
        b = { bg = colors.fg_gutter, fg = colors.magenta },
    }

    tokyonight.replace = {
        a = { bg = colors.red, fg = colors.black },
        b = { bg = colors.fg_gutter, fg = colors.red },
    }

    tokyonight.inactive = {
        a = { bg = bg_statusline, fg = colors.blue },
        b = { bg = bg_statusline, fg = colors.fg_gutter, gui = "bold" },
        c = { bg = bg_statusline, fg = colors.fg_gutter },
    }

    if config.lualine_bold then
        for _, mode in pairs(tokyonight) do
            mode.a.gui = "bold"
        end
    end

    return tokyonight
end

function module.alpha_banner()
    vim.api.nvim_set_hl(0, "StartLogo1", { fg = "#1C506B" })
    vim.api.nvim_set_hl(0, "StartLogo2", { fg = "#1D5D68" })
    vim.api.nvim_set_hl(0, "StartLogo3", { fg = "#1E6965" })
    vim.api.nvim_set_hl(0, "StartLogo4", { fg = "#1F7562" })
    vim.api.nvim_set_hl(0, "StartLogo5", { fg = "#21825F" })
    vim.api.nvim_set_hl(0, "StartLogo6", { fg = "#228E5C" })
    vim.api.nvim_set_hl(0, "StartLogo7", { fg = "#239B59" })
    vim.api.nvim_set_hl(0, "StartLogo8", { fg = "#24A755" })
    return {
        [[                                                                   ]],
        [[      ████ ██████           █████      ██                    ]],
        [[     ███████████             █████                            ]],
        [[     █████████ ███████████████████ ███   ███████████  ]],
        [[    █████████  ███    █████████████ █████ ██████████████  ]],
        [[   █████████ ██████████ █████████ █████ █████ ████ █████  ]],
        [[ ███████████ ███    ███ █████████ █████ █████ ████ █████ ]],
        [[██████  █████████████████████ ████ █████ █████ ████ ██████]],
    }
end

return module
