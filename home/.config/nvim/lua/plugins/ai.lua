return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
        mode = "agentic",
        provider = vim.g.avante_provider,
        providers = {
            ["coder"] = {
                __inherited_from = "openai",
                api_key_name = "CODER_API_KEY",
                endpoint = vim.env.CODER_ENDPOINT,
                model = vim.env.CODER_MODEL,
                -- disable_tools = true, -- Open-source models often do not support tools.
            },
        },
        web_search_engine = {
            provider = "kagi",
        },
        cursor_applying_provider = vim.g.avante_provider,
        behaviour = {
            enable_cursor_planning_mode = true,
            auto_focus_sidebar = true,
            auto_suggestions = false,
            auto_suggestions_respect_ignore = false,
            auto_set_highlight_group = true,
            auto_set_keymaps = true,
            auto_apply_diff_after_generation = false,
            jump_result_buffer_on_finish = false,
            support_paste_from_clipboard = false,
            minimize_diff = true,
            enable_token_counting = true,
            use_cwd_as_project_root = false,
            auto_focus_on_diff_view = false,
        },
    },
    build = "make",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "stevearc/dressing.nvim", -- for input provider dressing
        "folke/snacks.nvim", -- for input provider snacks
        "echasnovski/mini.icons", -- or echasnovski/mini.icons
        {
            -- Make sure to set this up properly if you have lazy=true
            "MeanderingProgrammer/render-markdown.nvim",
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
}
