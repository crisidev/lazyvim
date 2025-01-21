return {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
        -- "nvimtools/hydra.nvim",
        "cathyprime/hydra.nvim",
    },
    opts = {},
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    keys = {
        {
            mode = { "v", "n" },
            "<c-l>",
            "<cmd>MCstart<cr>",
            desc = "Create a selection for selected text or word under the cursor",
        },
    },
}
