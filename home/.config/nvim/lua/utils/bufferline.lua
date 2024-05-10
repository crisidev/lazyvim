local module = {}

module.delete_buffer = function()
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

module.smart_quit = function()
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

module.language_group = function(name, extension, highlight)
    local opts = {
        highlight = { sp = highlight },
        name = name,
        matcher = function(buf)
            return vim.fn.fnamemodify(buf.path, ":e") == extension
        end,
    }
    return opts
end

module.diagnostic_indicator = function(_, _, diagnostics, _)
    local icons = require("config.theme").icons
    local result = {}
    local symbols = { error = icons.error, warning = icons.warn }
    for name, count in pairs(diagnostics) do
        if symbols[name] and count > 0 then
            table.insert(result, symbols[name] .. count)
        end
    end
    local res = table.concat(result, " ")
    return #res > 0 and res or ""
end

module.config_file_matcher = function(buf)
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

module.test_file_matcher = function(buf)
    return vim.api.nvim_buf_get_name(buf.id):match("_spec") or vim.api.nvim_buf_get_name(buf.id):match("test_")
end

module.doc_file_matcher = function(buf)
    local p_list = require("plenary.collections.py_list")
    local list = p_list({ "md", "org", "norg", "wiki", "rst", "txt" })
    return list:contains(vim.fn.fnamemodify(buf.path, ":e"))
end

return module
