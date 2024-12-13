return {
    "harrisoncramer/gitlab.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "stevearc/dressing.nvim", -- Recommended but not required. Better UI for pickers.
        "nvim-tree/nvim-web-devicons", -- Recommended but not required. Icons in discussion tree.
    },
    enabled = vim.g.gitlab,
    build = function()
        require("gitlab.server").build(true)
    end, -- Builds the Go binary
    config = function()
        require("gitlab").setup()
    end,
    keys = function()
        return {
            { "<leader>Gb", "<cmd>require('gitlab').choose_merge_request()<cr>", desc = "Choose merge request" },
            { "<leader>Gs", "<cmd>require('gitlab').review()<cr>", desc = "Open review pane" },
            { "<leader>Gc", "<cmd>require('gitlab').create_comment()<cr>", desc = "Crate comment" },
            {
                "<leader>Gc",
                "<cmd>require('gitlab').create_multiline_comment()<cr>",
                mode = "v",
                desc = "Crate multiline comment",
            },
            {
                "<leader>GC",
                "<cmd>require('gitlab').create_comment_suggestion()<cr>",
                mode = "v",
                desc = "Create comment suggestion",
            },
            {
                "<leader>GM",
                "<cmd>require('gitlab').move_to_discussion_tree_from_diagnostic()<cr>",
                desc = "Move discussion tree from diagnostics",
            },
            { "<leader>Gd", "<cmd>require('gitlab').toggle_discussions()<cr>", desc = "Toggle discussion" },
            { "<leader>Gp", "<cmd>require('gitlab').pipeline()<cr>", desc = "Pipeline" },
            { "<leader>Go", "<cmd>require('gitlab').open_in_browser()<cr>", desc = "Open in browser" },
            { "<leader>Gu", "<cmd>require('gitlab').copy_mr_url()<cr>", desc = "Copy merge request URL" },
            { "<leader>GP", "<cmd>require('gitlab').publish_all_drafts()<cr>", desc = "Publish all drafts" },
            { "<leader>Gd", "<cmd>require('gitlab').toggle_draft_mode()<cr>", desc = "Toggle draf mode" },
            { "<leader>Gn", "<cmd>require('gitlab').create_note()<cr>", desc = "Crate note" },
            { "<leader>Gl", "<cmd>require('gitlab').add_label()<cr>", desc = "Add label" },
            { "<leader>GL", "<cmd>require('gitlab').delete_label()<cr>", desc = "Delete label" },
            { "<leader>Ga", "<cmd>require('gitlab').add_assignee()<cr>", desc = "Add assignee" },
            { "<leader>GA", "<cmd>require('gitlab').delete_assignee()<cr>", desc = "Delete assignee" },
            { "<leader>Gr", "<cmd>require('gitlab').add_reviewer()<cr>", desc = "Add reviewer" },
            { "<leader>GR", "<cmd>require('gitlab').delete_reviewer()<cr>", desc = "Delete reviewer" },
            { "<leader>Gmc", "<cmd>require('gitlab').create_mr()<cr>", desc = "New" },
            { "<leader>Gms", "<cmd>require('gitlab').summary()<cr>", desc = "Summary" },
            { "<leader>Gmg", "<cmd>require('gitlab').approve()<cr>", desc = "Approve" },
            { "<leader>GmG", "<cmd>require('gitlab').revoke()<cr>", desc = "Revoke" },
            { "<leader>Gmm", "<cmd>require('gitlab').merge()<cr>", desc = "Merge" },
        }
    end,
}
