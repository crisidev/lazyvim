local module = {}

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

function module.language_group(name, extension, highlight)
    local opts = {
        highlight = { sp = highlight },
        name = name,
        matcher = function(buf)
            return vim.fn.fnamemodify(buf.path, ":e") == extension
        end,
    }
    return opts
end

function module.diagnostic_indicator(_, _, diagnostics, _)
    local icons = require("config.theme").diagnostics_icons
    local result = {}
    local symbols = { error = icons.Error, warning = icons.Warn }
    for name, count in pairs(diagnostics) do
        if symbols[name] and count > 0 then
            table.insert(result, symbols[name] .. count)
        end
    end
    local res = table.concat(result, " ")
    return #res > 0 and res or ""
end

function module.config_file_matcher(buf)
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

function module.test_file_matcher(buf)
    return vim.api.nvim_buf_get_name(buf.id):match("_spec") or vim.api.nvim_buf_get_name(buf.id):match("test_")
end

function module.doc_file_matcher(buf)
    local p_list = require("plenary.collections.py_list")
    local list = p_list({ "md", "org", "norg", "wiki", "rst", "txt" })
    return list:contains(vim.fn.fnamemodify(buf.path, ":e"))
end

return module
