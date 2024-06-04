return {
    "harrisoncramer/gitlab.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "stevearc/dressing.nvim", -- Recommended but not required. Better UI for pickers.
        "nvim-tree/nvim-web-devicons", -- Recommended but not required. Icons in discussion tree.
    },
    enabled = false,
    build = function()
        require("gitlab.server").build(true)
    end, -- Builds the Go binary
    config = function()
        require("gitlab").setup()
    end,
    keys = function()
        return {
            { "<space>b", "<cmd>require('gitlab').choose_merge_request()<cr>", desc = "Choose merge request" },
            { "<space>s", "<cmd>require('gitlab').review()<cr>", desc = "Open review pane" },
            { "<space>c", "<cmd>require('gitlab').create_comment()<cr>", desc = "Crate comment" },
            {
                "<space>c",
                "<cmd>require('gitlab').create_multiline_comment()<cr>",
                mode = "v",
                desc = "Crate multiline comment",
            },
            {
                "<space>C",
                "<cmd>require('gitlab').create_comment_suggestion()<cr>",
                mode = "v",
                desc = "Create comment suggestion",
            },
            {
                "<space>M",
                "<cmd>require('gitlab').move_to_discussion_tree_from_diagnostic()<cr>",
                desc = "Move discussion tree from diagnostics",
            },
            { "<space>d", "<cmd>require('gitlab').toggle_discussions()<cr>", desc = "Toggle discussion" },
            { "<space>p", "<cmd>require('gitlab').pipeline()<cr>", desc = "Pipeline" },
            { "<space>o", "<cmd>require('gitlab').open_in_browser()<cr>", desc = "Open in browser" },
            { "<space>u", "<cmd>require('gitlab').copy_mr_url()<cr>", desc = "Copy merge request URL" },
            { "<space>P", "<cmd>require('gitlab').publish_all_drafts()<cr>", desc = "Publish all drafts" },
            { "<space>d", "<cmd>require('gitlab').toggle_draft_mode()<cr>", desc = "Toggle draf mode" },
            { "<space>n", "<cmd>require('gitlab').create_note()<cr>", desc = "Crate note" },
            { "<space>l", "<cmd>require('gitlab').add_label()<cr>", desc = "Add label" },
            { "<space>L", "<cmd>require('gitlab').delete_label()<cr>", desc = "Delete label" },
            { "<space>a", "<cmd>require('gitlab').add_assignee()<cr>", desc = "Add assignee" },
            { "<space>A", "<cmd>require('gitlab').delete_assignee()<cr>", desc = "Delete assignee" },
            { "<space>r", "<cmd>require('gitlab').add_reviewer()<cr>", desc = "Add reviewer" },
            { "<space>R", "<cmd>require('gitlab').delete_reviewer()<cr>", desc = "Delete reviewer" },
            { "<space>mc", "<cmd>require('gitlab').create_mr()<cr>", desc = "New" },
            { "<space>ms", "<cmd>require('gitlab').summary()<cr>", desc = "Summary" },
            { "<space>mg", "<cmd>require('gitlab').approve()<cr>", desc = "Approve" },
            { "<space>mG", "<cmd>require('gitlab').revoke()<cr>", desc = "Revoke" },
            { "<space>mm", "<cmd>require('gitlab').merge()<cr>", desc = "Merge" },
        }
    end,
}
