local module = {}

local mason_install_path = vim.fn.stdpath("data") .. "/mason/bin"

module.basedpyright_cmd = function()
    local cmd_path = mason_install_path .. "/basedpyright-langserver"
    local cmd = { cmd_path, "--stdio" }
    local match = vim.fn.glob(vim.fn.getcwd() .. "/poetry.lock")
    if match ~= "" then
        cmd = { "poetry", "run", cmd_path, "--stdio" }
    end
    return cmd
end

module.ruff_lsp_cmd = function()
    local cmd_path = mason_install_path .. "/ruff-lsp"
    local cmd = { cmd_path }
    local match = vim.fn.glob(vim.fn.getcwd() .. "/poetry.lock")
    if match ~= "" then
        cmd = { "poetry", "run", cmd_path }
    end
    return cmd
end

module.insert_pyright_ignore = function()
    local line = vim.api.nvim_get_current_line()
    local nline = line .. "  # pyright: ignore"
    vim.api.nvim_set_current_line(nline)
end

module.build_tools = function()
    local which_key = require("which-key")
    local icons = require("config.theme").languages
    local opts = {
        mode = "n",
        prefix = "f",
        buffer = vim.fn.bufnr(),
        silent = true,
        noremap = true,
        nowait = true,
    }
    local mappings = {
        B = {
            name = icons.python .. "Build helpers",
            i = { "<cmd>PyrightOrganizeImports<cr>", "Organize imports" },
            p = { "<cmd>lua require('user.lsp.python').insert_pyright_ignore()<cr>", "Insert # pyright: ignore" },
        },
    }
    which_key.register(mappings, opts)
end

return module
