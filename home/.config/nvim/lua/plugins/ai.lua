return {
    {
        "jackMort/ChatGPT.nvim",
        enabled = vim.g.ai_plugin == "chatgpt",
        lazy = true,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        keys = {
            { "gGp", "<cmd>ChatGPT<cr>", desc = "Prompt" },
            { "gGa", "<cmd>ChatGPTActAs<cr>", desc = "Act as" },
            { "gGe", "<cmd>ChatGPTEditWithInstruction<cr>", desc = "Edit with instruction" },
            {
                "gGd",
                "<cmd>ChatGPTRun docstring<cr>",
                desc = "Docstring",
                mode = { "n", "x" },
            },
            {
                "gGt",
                "<cmd>ChatGPTRun add_tests<cr>",
                desc = "Add tests",
                mode = { "n", "x" },
            },
            {
                "gGo",
                "<cmd>ChatGPTRun optimize_code<cr>",
                desc = "Optimize code",
                mode = { "n", "x" },
            },
            {
                "gGE",
                "<cmd>ChatGPTRun explain_code<cr>",
                desc = "Explain code",
                mode = { "n", "x" },
            },
            {
                "gGc",
                "<cmd>ChatGPTRun complete_code<cr>",
                desc = "Complete code",
                mode = { "n", "x" },
            },
            {
                "gGr",
                "<cmd>ChatGPTRun code_readability_analysis<cr>",
                desc = "Code readability",
                mode = { "n", "x" },
            },
            {
                "gGTg",
                "<cmd>ChatGPTRun grammar_correction<cr>",
                desc = "Correct grammar",
                mode = { "n", "x" },
            },
            {
                "gGTt",
                "<cmd>ChatGPTRun translate<cr>",
                desc = "Translate",
                mode = { "n", "x" },
            },
            {
                "gGTk",
                "<cmd>ChatGPTRun keywords<cr>",
                desc = "Keywords",
                mode = { "n", "x" },
            },
            {
                "gGTs",
                "<cmd>ChatGPTRun summarize<cr>",
                desc = "Summarize",
                mode = { "n", "x" },
            },
        },
    },
    {
        "yetone/avante.nvim",
        enabled = vim.g.ai_plugin == "avante",
        event = "VeryLazy",
        version = "*", -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
        opts = {
            provider = "openai",
            openai = {
                endpoint = "https://api.openai.com/v1",
                model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
                timeout = 30000, -- timeout in milliseconds
                temperature = 0, -- adjust if needed
                max_tokens = 4096,
                -- reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
            },
        },
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "echasnovski/mini.pick", -- for file_selector provider mini.pick
            "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
            "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
            "ibhagwan/fzf-lua", -- for file_selector provider fzf
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            "zbirenbaum/copilot.lua", -- for providers='copilot'
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },
}
