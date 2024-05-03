local module = {}

module.build_tools = function()
    local which_key = require("which-key")
    local theme = require("config.theme")
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
            name = theme.languages.go .. "Build helpers",
            i = { "<cmd>GoInstallDeps<cr>", "Install dependencies" },
            t = { "<cmd>GoMod tidy<cr>", "Tidy" },
            a = { "<cmd>GoTestAdd<cr>", "Add test" },
            A = { "<cmd>GoTestsAll<cr>", "Add all tests" },
            e = { "<cmd>GoTestsExp<cr>", "Add exported tests" },
            g = { "<cmd>GoGenerate<cr>", "Generate" },
            c = { "<cmd>GoCmt<cr>", "Comment" },
        },
    }
    which_key.register(mappings, opts)
end

return module
