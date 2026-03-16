return {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
        { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff View" },
        { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
        { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
    },
}
