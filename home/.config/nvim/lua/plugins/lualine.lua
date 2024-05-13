return {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
        local lualine = require("utils.lualine")
        opts.options.theme = require("config.theme").lualine()
        opts.options.globalstatus = true
        opts.options.component_separators = { left = "", right = "" }
        opts.options.section_separators = { left = "", right = "" }
        opts.options.always_divide_middle = true
        opts.sections = {
            lualine_a = {
                lualine.vim_mode(),
            },
            lualine_b = {
                lualine.git(),
            },
            lualine_c = {
                lualine.file_icon(),
                lualine.file_name(),
                lualine.diff(),
                lualine.lazy_status(),
                lualine.circle_icon("right"),
            },
            lualine_x = {
                lualine.circle_icon("left"),
                lualine.file_read_only(),
                lualine.diagnostics(),
            },
            lualine_y = {
                lualine.dap_status(),
                lualine.null_ls(),
                lualine.codeium(),
                lualine.typos_lsp(),
                lualine.treesitter(),
                lualine.lsp_servers(),
            },
            lualine_z = {
                lualine.location(),
                lualine.file_size(),
                lualine.file_format(),
                lualine.file_position(),
            },
        }
    end,
}
