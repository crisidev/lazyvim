return {
    "jackMort/ChatGPT.nvim",
    lazy = true,
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
        { "gGp", "<cmd>ChatGPT<cr>", desc = "Prompt" },
        { "gGa", "<cmd>ChatGPTActAs<cr>", desc = "Act as" },
        { "gGe", "<cmd>ChatGPTEditWithInstruction<cr>", desc = "Edit with instruction" },
        { "gGd", "<cmd>ChatGPTRun docstring<cr>", desc = "Docstring", mode = { "n", "x" } },
        { "gGt", "<cmd>ChatGPTRun add_tests<cr>", desc = "Add tests", mode = { "n", "x" } },
        { "gGo", "<cmd>ChatGPTRun optimize_code<cr>", desc = "Optimize code", mode = { "n", "x" } },
        { "gGE", "<cmd>ChatGPTRun explain_code<cr>", desc = "Explain code", mode = { "n", "x" } },
        { "gGc", "<cmd>ChatGPTRun complete_code<cr>", desc = "Complete code", mode = { "n", "x" } },
        { "gGr", "<cmd>ChatGPTRun code_readability_analysis<cr>", desc = "Code readability", mode = { "n", "x" } },
        { "gGTg", "<cmd>ChatGPTRun grammar_correction<cr>", desc = "Correct grammar", mode = { "n", "x" } },
        { "gGTt", "<cmd>ChatGPTRun translate<cr>", desc = "Translate", mode = { "n", "x" } },
        { "gGTk", "<cmd>ChatGPTRun keywords<cr>", desc = "Keywords", mode = { "n", "x" } },
        { "gGTs", "<cmd>ChatGPTRun summarize<cr>", desc = "Summarize", mode = { "n", "x" } },
    },
}
