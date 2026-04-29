local methods = require("null-ls.methods")
local nls = require("null-ls")
local helpers = require("null-ls.helpers")

local darker = {
    name = "darker",
    meta = {
        url = "https://github.com/akaihola/darker",
        description = "For when you want to use black but really can't",
    },
    method = methods.internal.FORMATTING,
    filetypes = { "python" },
    generator = helpers.formatter_factory({
        args = {
            "--line-length",
            "120",
            "--isort",
            "--flynt",
            "--stdout",
            "$FILENAME",
        },
        command = "darker",
    }),
}

return {
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvimtools/none-ls-extras.nvim",
        },
        opts = {
            sources = {
                -- Completion

                -- Formatting
                nls.builtins.formatting.buf,
                nls.builtins.formatting.clang_format.with({
                    filetypes = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
                }),
                nls.builtins.formatting.cmake_format,
                nls.builtins.formatting.isort.with({
                    extra_args = { "--profile=black" },
                }),
                nls.builtins.formatting.black.with({
                    extra_args = { "--fast", "--line-length=120" },
                }),
                nls.builtins.formatting.prettier,
                nls.builtins.formatting.shfmt,
                nls.builtins.formatting.terraform_fmt,

                -- Diagnostics
                nls.builtins.diagnostics.actionlint,
                nls.builtins.diagnostics.alex,
                nls.builtins.diagnostics.ansiblelint.with({
                    condition = function(utils)
                        return (utils.root_has_file("roles") and utils.root_has_file("inventory"))
                            or utils.root_has_file("ansible")
                    end,
                }),
                nls.builtins.diagnostics.buf,
                nls.builtins.diagnostics.checkmake,
                nls.builtins.diagnostics.deadnix,
                nls.builtins.diagnostics.markdownlint_cli2.with({
                    extra_args = { "--config", vim.fn.expand("~/.config/markdownlint-cli2.yaml") },
                }),
                nls.builtins.diagnostics.protolint,
                nls.builtins.diagnostics.selene.with({
                    condition = function(utils)
                        return utils.root_has_file({ "selene.toml" })
                    end,
                }),
                nls.builtins.diagnostics.statix,
                nls.builtins.diagnostics.zsh,

                -- Code actions
                nls.builtins.code_actions.refactoring,
                -- nls.builtins.code_actions.gitrebase,
                -- nls.builtins.code_actions.gitsigns,
                nls.builtins.code_actions.statix,

                -- Hover
                nls.builtins.hover.dictionary,
            },
        },
    },
}
