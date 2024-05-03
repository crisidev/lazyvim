return {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
        local nls = require("null-ls")
        local home = vim.env.HOME
        opts.sources = vim.list_extend(opts.sources or {}, {
            -- Formatting
            nls.builtins.formatting.prettier,
            nls.builtins.formatting.stylua,
            nls.builtins.formatting.goimports,
            nls.builtins.formatting.gofumpt,
            nls.builtins.formatting.clang_format.with({
                filetypes = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
            }),
            nls.builtins.formatting.cmake_format,
            nls.builtins.formatting.scalafmt,
            nls.builtins.formatting.terraform_fmt,
            nls.builtins.formatting.shfmt.with({
                extra_args = { "-i", "4", "-ci" },
            }),
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
            nls.builtins.diagnostics.cmake_lint,
            nls.builtins.diagnostics.hadolint,
            nls.builtins.diagnostics.vint,
            nls.builtins.diagnostics.markdownlint,
            nls.builtins.diagnostics.zsh,
            nls.builtins.diagnostics.terraform_validate,

            -- Code actions
            nls.builtins.code_actions.refactoring.with({
                filetypes = { "typescript", "javascript", "c", "cpp", "go", "python" },
            }),
            nls.builtins.code_actions.gitrebase,
            nls.builtins.code_actions.gitsigns,
            nls.builtins.code_actions.impl,

            -- Hover
            nls.builtins.hover.dictionary,
        })
    end,
}
