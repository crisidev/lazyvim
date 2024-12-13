local methods = require("null-ls.methods")
local c = require("null-ls.config")
local loop = require("null-ls.loop")
local nls = require("null-ls")
local theme = require("config.theme")
local code_action = methods.internal.CODE_ACTION

local function extract_struct_name(params)
    local linenr = params.row
    local line = params.content[linenr]
    return line:match("^type (.*) struct")
end

local function apply_edits(edits, params)
    local bufnr = params.bufnr
    -- directly use handler, since formatting_sync uses a custom handler that won't work if called twice
    -- formatting and rangeFormatting handlers should be identical
    local handler = require("null-ls.client").resolve_handler(params.lsp_method)

    local diffed_edits = {}
    for _, edit in ipairs(edits) do
        local split_text, line_ending = require("null-ls.utils").split_at_newline(bufnr, edit.text)
        local diffed = require("null-ls.diff").compute_diff(params.content, split_text, line_ending)
        -- check if the computed diff is an actual edit
        if not (diffed.newText == "" and diffed.rangeLength == 0) then
            table.insert(diffed_edits, diffed)
        end
    end

    handler(nil, diffed_edits, {
        method = params.lsp_method,
        client_id = params.client_id,
        bufnr = bufnr,
    })
end

local function make_code_action(opts)
    local name = opts.name
    local filetypes = opts.filetypes or {}
    local action_fn = opts.action_fn
    local save_on_return = opts.save_on_return or true

    return {
        name = name,
        method = code_action,
        filetypes = filetypes,
        generator = {
            fn = function(params)
                -- cli callback handler
                local handler = function(_, output)
                    if not output then
                        return
                    end

                    -- patch params method
                    params.lsp_method = methods.lsp.FORMATTING
                    apply_edits({
                        {
                            row = 1,
                            col = 1,
                            end_row = vim.tbl_count(params.content) + 1,
                            end_col = 1,
                            text = output,
                        },
                    }, params)

                    if save_on_return then
                        vim.schedule(function()
                            vim.cmd(params.bufnr .. "bufdo! silent keepjumps noautocmd update")
                        end)
                    end
                end

                -- function to invoke cli
                local invoke_cli = function(action)
                    local command = action.command
                    local args = action.args
                    local timeout = action.timeout or c.get().default_timeout
                    local stdin = action.stdin or false
                    assert(
                        vim.fn.executable(command) > 0,
                        string.format(
                            "command %s is not executable (make sure it's installed and on your $PATH)",
                            command
                        )
                    )

                    local client = vim.lsp.get_client_by_id(params.client_id)
                    local spawn_opts = {
                        cwd = client and client.config.root_dir or vim.fn.getcwd(),
                        input = command,
                        handler = handler,
                        timeout = timeout,
                    }
                    if stdin then
                        local content = table.concat(params.content, "\n")
                        spawn_opts["input"] = content
                    end

                    loop.spawn(command, args, spawn_opts)
                end

                local action_list = action_fn(params)
                if not action_list then
                    return
                end

                local actions = {}
                for _, action in pairs(action_list) do
                    table.insert(actions, {
                        title = action.title,
                        action = function()
                            if action.callback then
                                action.callback(invoke_cli)
                            else
                                invoke_cli(action)
                            end
                        end,
                    })
                end

                return actions
            end,
        },
    }
end

return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvimtools/none-ls-extras.nvim",
    },
    opts = {
        sources = {
            -- Completion
            nls.builtins.completion.luasnip,

            -- Formatting
            nls.builtins.formatting.clang_format.with({
                filetypes = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
            }),
            nls.builtins.formatting.cmake_format,
            nls.builtins.formatting.isort.with({
                extra_args = { "isort", "--profile=black" },
            }),
            nls.builtins.formatting.black.with({
                extra_args = { "--fast", "--line-length=120" },
            }),
            nls.builtins.formatting.stylua,
            nls.builtins.formatting.shfmt,

            -- Diagnostics
            nls.builtins.diagnostics.alex,
            nls.builtins.diagnostics.ansiblelint.with({
                condition = function(utils)
                    return (utils.root_has_file("roles") and utils.root_has_file("inventory"))
                        or utils.root_has_file("ansible")
                end,
            }),
            nls.builtins.diagnostics.checkmake,
            nls.builtins.diagnostics.selene.with({
                condition = function(utils)
                    return utils.root_has_file({ "selene.toml" })
                end,
            }),
            nls.builtins.diagnostics.vint,
            nls.builtins.diagnostics.zsh,
            nls.builtins.diagnostics.protolint,

            -- Code actions
            nls.builtins.code_actions.refactoring.with({
                filetypes = { "typescript", "javascript", "c", "cpp", "go", "python" },
            }),
            -- nls.builtins.code_actions.gitrebase,
            nls.builtins.code_actions.gitsigns,
            -- go struct helper
            make_code_action({
                name = "gostructhelper",
                method = code_action,
                filetypes = { "go" },
                action_fn = function(params)
                    local typ = extract_struct_name(params)
                    if not typ then
                        return
                    end

                    local command = "gostructhelper"
                    local actions = {
                        {
                            title = "[gostructhelper] Generate constructor",
                            command = command,
                            stdin = true,
                            args = { "-stdin", "-file", params.bufname, "-type", typ, "-constructor" },
                        },
                        {
                            title = "[gostructhelper] Generate getter",
                            command = command,
                            stdin = true,
                            args = { "-stdin", "-file", params.bufname, "-type", typ, "-getter" },
                        },
                    }
                    return actions
                end,
            }),

            -- Hover
            nls.builtins.hover.dictionary,
        },
    },
}
