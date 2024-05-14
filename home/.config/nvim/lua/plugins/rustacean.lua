return {
    "mrcjkb/rustaceanvim",
    opts = function(_, opts)
        local cfg = require("rustaceanvim.config")
        local codelldb_path = vim.fn.stdpath("data") .. "/mason/bin/codelldb"
        local liblldb_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/lldb/lib/liblldb.dylib"
        opts.server.on_attach = function(client, bufnr)
            local _, _ = pcall(vim.lsp.codelens.refresh)
        end
        opts.dap = {
            adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        }
    end,
}
