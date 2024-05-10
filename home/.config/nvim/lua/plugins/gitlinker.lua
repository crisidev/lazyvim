return {
    "ruifm/gitlinker.nvim",
    config = function()
        local callbacks = {
            ["code.crisidev.org"] = require("gitlinker.hosts").get_gitea_type_url,
        }
        local gitlab_url = os.getenv("CORPORATE_GITLAB_URL")
        if gitlab_url then
            callbacks[gitlab_url] = require("gitlinker.hosts").get_gitlab_type_url
        end

        require("gitlinker").setup({
            opts = {
                -- adds current line nr in the url for normal mode
                add_current_line_on_normal_mode = true,
                -- callback for what to do with the url
                action_callback = require("gitlinker.actions").copy_to_clipboard,
                -- print the url after performing the action
                print_url = false,
                -- mapping to call url generation
                mappings = nil,
            },
            callbacks = callbacks,
        })

        vim.keymap.del("n", "<leader>gy")
    end,
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
        {
            "<leader>gl",
            "<cmd>lua require('gitlinker').get_buf_range_url('n', {action_callback = require('gitlinker.actions').copy_to_clipboard})<cr>",
            desc = "Copy line",
        },
        {
            "<leader>gL",
            "<cmd>lua require('gitlinker').get_buf_range_url('n', {action_callback = require('gitlinker.actions').open_in_browser})<cr>",
            desc = "Open line",
        },
    },
}
