return {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
        if vim.fn.filereadable(vim.fn.expand("~/.config/lvim/.gpt")) == 1 then
            local ok, gpt = pcall(require, "chatgpt")
            if ok then
                gpt.setup({
                    api_key_cmd = "cat ~/.config/lvim/.gpt",
                })
            end
        end
    end,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    keys = {
        { "fGp",  "<cmd>ChatGPT<cr>",                              desc = "Prompt" },
        { "fGa",  "<cmd>ChatGPTActAs<cr>",                         desc = "Act as" },
        { "fGe",  "<cmd>ChatGPTEditWithInstruction<cr>",           desc = "Edit with instruction" },
        { "fGd",  "<cmd>ChatGPTRun docstring<cr>",                 desc = "Docstring",            mode = { "n", "x" } },
        { "fGt",  "<cmd>ChatGPTRun add_tests<cr>",                 desc = "Add tests",            mode = { "n", "x" } },
        { "fGo",  "<cmd>ChatGPTRun optimize_code<cr>",             desc = "Optimize code",        mode = { "n", "x" } },
        { "fGE",  "<cmd>ChatGPTRun explain_code<cr>",              desc = "Explain code",         mode = { "n", "x" } },
        { "fGc",  "<cmd>ChatGPTRun complete_code<cr>",             desc = "Complete code",        mode = { "n", "x" } },
        { "fGr",  "<cmd>ChatGPTRun code_readability_analysis<cr>", desc = "Code readability",     mode = { "n", "x" } },
        { "fGTg", "<cmd>ChatGPTRun grammar_correction<cr>",        desc = "Correct grammar",      mode = { "n", "x" } },
        { "fGTt", "<cmd>ChatGPTRun translate<cr>",                 desc = "Translate",            mode = { "n", "x" } },
        { "fGTk", "<cmd>ChatGPTRun keywords<cr>",                  desc = "Keywords",             mode = { "n", "x" } },
        { "fGTs", "<cmd>ChatGPTRun summarize<cr>",                 desc = "Summarize",            mode = { "n", "x" } },
    },
}
