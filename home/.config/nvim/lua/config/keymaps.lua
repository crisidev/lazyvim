-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local icons = require("config.theme").icons

-- Mouse handling
vim.cmd([[
    function! s:MouseToggleFunc()
        if !exists('s:old_mouse')
            let s:old_mouse = 'a'
        endif

        if &mouse ==? ''
            let &mouse = s:old_mouse
            echo 'Mouse is for Vim (' . &mouse . ')'
        else
            let s:old_mouse = &mouse
            let &mouse=''
            echo 'Mouse is for terminal'
        endif
    endfunction
    command! MouseToggle :call <SID>MouseToggleFunc()
]])

-- Toggle numbers
vim.cmd([[
    function! s:NuModeToggleFunc()
        if &number == 1
            set relativenumber!
        else
            set number!
        endif
    endfunction
    command! NuModeToggle :call <SID>NuModeToggleFunc()
]])

-- No numbers
vim.cmd([[
    function! s:NoNuModeFunc()
        set norelativenumber
        set nonumber
    endfunction
    command! NoNuMode :call <SID>NoNuModeFunc()
]])

-- Open neotree
vim.keymap.set({ "n", "i" }, "<F3>", "<cmd>Neotree reveal toggle<cr>")
vim.keymap.set("n", "<F5>", "<cmd>MouseToggle<cr>")
vim.keymap.set("i", "<F5>", "<esc><cmd>MouseToggle<cr>")

-- Move to windows
vim.keymap.set({ "n", "i", "t" }, "<A-Up>", "<cmd>wincmd k<cr>", { desc = "Move to window above" })
vim.keymap.set({ "n", "i", "t" }, "<A-Down>", "<cmd>wincmd j<cr>", { desc = "Move to window below" })
vim.keymap.set({ "n", "i", "t" }, "<A-Left>", "<cmd>wincmd h<cr>", { desc = "Move to window left" })
vim.keymap.set({ "n", "i", "t" }, "<A-Right>", "<cmd>wincmd l<cr>", { desc = "Move to window right" })

-- Better movements
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Move Up" })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Move down" })
vim.keymap.set("n", "<", "<<", { desc = "Indent left" })
vim.keymap.set("n", ">", ">>", { desc = "Indent right" })

-- Clear highlight with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Yank/cut/paste
vim.api.nvim_set_keymap("x", "<c-c>", '"*y :let @+=@*<CR>', { noremap = true, silent = true })

-- Terminals
vim.keymap.set({ "n", "i", "t" }, "<c-\\>", function()
    Snacks.terminal(nil, {
        border = "rounded",
        cwd = LazyVim.root.get(),
        win = {
            position = "float",
            border = "rounded",
            relative = "editor",
        },
        env = { TERM_TYPE = "float" },
    })
end, { desc = "Float terminal" })
vim.keymap.set({ "n", "i", "t" }, "<c-]>", function()
    Snacks.terminal(nil, {
        border = "rounded",
        cwd = LazyVim.root.get(),
        win = { position = "bottom", relative = "editor" },
        env = { TERM_TYPE = "bottom" },
    })
end, { desc = "Bottom terminal" })

-- Misc
vim.keymap.set("n", "<leader>w", "<cmd>w! | lua vim.notify('File written')<cr>", { desc = "Save buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch buffer" })
vim.keymap.set("n", "<leader>um", "<cmd>MouseToggle<cr>", { desc = "Toggle mouse mode" })
vim.keymap.set("n", "<leader>ur", "<cmd>NuModeToggle<cr>", { desc = "Toggle number mode" })
vim.keymap.set("n", "<leader>uN", "<cmd>NoNuMode<cr>", { desc = "No number mode" })
