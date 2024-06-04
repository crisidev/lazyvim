return {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
        local nls = require("null-ls")
        local home = vim.env.HOME
        opts.sources = vim.list_extend(opts.sources or {}, {
            -- Formatting
            nls.builtins.formatting.clang_format.with({
                filetypes = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
            }),
            nls.builtins.formatting.cmake_format,
            nls.builtins.formatting.isort.with({
                command = home .. "/.bin/poetry-isort",
                extra_args = { "--profile=black" },
            }),
            nls.builtins.formatting.black.with({
                command = home .. "/.bin/poetry-black",
                extra_args = { "--fast", "--line-length=120" },
            }),

            -- Diagnostics
            nls.builtins.diagnostics.alex,
            nls.builtins.diagnostics.ansiblelint.with({
                condition = function(utils)
                    return (utils.root_has_file("roles") and utils.root_has_file("inventory"))
                        or utils.root_has_file("ansible")
                end,
            }),
            nls.builtins.diagnostics.checkmake,
            nls.builtins.diagnostics.vint,
            nls.builtins.diagnostics.zsh,

            -- Code actions
            nls.builtins.code_actions.refactoring.with({
                filetypes = { "typescript", "javascript", "c", "cpp", "go", "python" },
            }),
            -- nls.builtins.code_actions.gitrebase,
            nls.builtins.code_actions.gitsigns,

            -- Hover
            nls.builtins.hover.dictionary,
        })
    end,
}
