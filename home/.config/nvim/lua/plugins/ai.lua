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
            { "gGp", "<cmd>ChatGPT<cr>",                    desc = "Prompt" },
            { "gGa", "<cmd>ChatGPTActAs<cr>",               desc = "Act as" },
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
        event = "VeryLazy",
        lazy = false,
        version = false, -- set this if you want to always pull the latest change
        enabled = vim.g.ai_plugin == "avante",
        opts = {
            provider = "ollama",
            vendors = {
                ollama = {
                    __inherited_from = "openai",
                    api_key_name = "",
                    endpoint = "http://127.0.0.1:11434/v1",
                    model = "codellama:13b",
                },
            },
            file_selector = {
                provider = "fzf",
            },
        },
        build = "make",
        dependencies = {
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            {
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },
}
