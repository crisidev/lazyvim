-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
require("lazyvim.plugins.lsp.keymaps")._keys = {}

-- Mouse handling
local _old_mouse = "a"
vim.api.nvim_create_user_command("MouseToggle", function()
    if vim.o.mouse == "" then
        vim.o.mouse = _old_mouse
        vim.notify("Mouse is for Vim (" .. _old_mouse .. ")")
    else
        _old_mouse = vim.o.mouse
        vim.o.mouse = ""
        vim.notify("Mouse is for terminal")
    end
end, {})

-- Toggle numbers
vim.api.nvim_create_user_command("NuModeToggle", function()
    if vim.o.number then
        vim.o.relativenumber = not vim.o.relativenumber
    else
        vim.o.number = true
    end
end, {})

-- No numbers
vim.api.nvim_create_user_command("NoNuMode", function()
    vim.o.relativenumber = false
    vim.o.number = false
end, {})

-- Open neotree
local function focus_neotree()
    local neotree = require("neo-tree.command")
    local bufname = vim.bo.filetype
    if bufname == "neo-tree" then
        vim.api.nvim_command("wincmd l")
    else
        neotree.execute({ action = "focus" })
    end
end

-- Sudo write
vim.keymap.set("n", "<leader>W", "<cmd>SudaWrite<cr>", { silent = true, desc = "Write as root" })
-- Neotree
vim.keymap.set(
    { "n", "i" },
    "<F3>",
    focus_neotree,
    { noremap = true, silent = true, desc = "Toggle and focus Neo-tree with F3" }
)
vim.keymap.set({ "n", "i" }, "<F15>", function()
    vim.cmd("Neotree close")
end, { noremap = true, silent = true, desc = "Close neotree" })
-- Neotest
vim.keymap.set({ "n", "i" }, "<F4>", function()
    require("neotest").summary.toggle()
end, { noremap = true, silent = true, desc = "Toggle Neotest summary" })
-- Coverage
vim.keymap.set({ "n", "i" }, "<F5>", function()
    vim.cmd("CoverageSummary")
end, { noremap = true, silent = true, desc = "Toggle Coverage summary" })
-- Mouse
vim.keymap.set("n", "<F6>", "<cmd>MouseToggle<cr>", { noremap = true, silent = true, desc = "Toggle mouse mode" })

-- Move to windows
vim.keymap.set(
    { "n", "i", "t" },
    "<A-Up>",
    "<cmd>wincmd k<cr>",
    { noremap = true, silent = true, desc = "Move to window above" }
)
vim.keymap.set(
    { "n", "i", "t" },
    "<A-Down>",
    "<cmd>wincmd j<cr>",
    { noremap = true, silent = true, desc = "Move to window below" }
)
vim.keymap.set(
    { "n", "i", "t" },
    "<A-Left>",
    "<cmd>wincmd h<cr>",
    { noremap = true, silent = true, desc = "Move to window left" }
)
vim.keymap.set(
    { "n", "i", "t" },
    "<A-Right>",
    "<cmd>wincmd l<cr>",
    { noremap = true, silent = true, desc = "Move to window right" }
)

-- Better movements
vim.keymap.set(
    { "n", "x" },
    "<Up>",
    "v:count == 0 ? 'gk' : 'k'",
    { noremap = true, expr = true, silent = true, desc = "Move Up" }
)
vim.keymap.set(
    { "n", "x" },
    "<Down>",
    "v:count == 0 ? 'gj' : 'j'",
    { noremap = true, expr = true, silent = true, desc = "Move down" }
)
vim.keymap.set("n", "<", "<<", { noremap = true, silent = true, desc = "Indent left" })
vim.keymap.set("n", ">", ">>", { noremap = true, silent = true, desc = "Indent right" })

-- Clear highlight with <esc>
vim.keymap.set(
    { "i", "n" },
    "<esc>",
    "<cmd>noh<cr><esc>",
    { noremap = true, silent = true, desc = "Escape and Clear hlsearch" }
)

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
end, { noremap = true, silent = true, desc = "Float terminal" })
vim.keymap.set({ "n", "i", "t" }, "<c-enter>", function()
    Snacks.terminal(nil, {
        border = "rounded",
        cwd = LazyVim.root.get(),
        win = { position = "bottom", relative = "editor" },
        env = { TERM_TYPE = "bottom" },
    })
end, { noremap = true, silent = true, desc = "Bottom terminal" })

-- Misc
vim.keymap.set(
    "n",
    "<leader>w",
    "<cmd>w! | lua vim.notify('File written')<cr>",
    { noremap = true, silent = true, desc = "Save buffer" }
)
vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { noremap = true, silent = true, desc = "Switch buffer" })
vim.keymap.set("n", "<leader>um", "<cmd>MouseToggle<cr>", { noremap = true, silent = true, desc = "Toggle mouse mode" })
vim.keymap.set(
    "n",
    "<leader>ur",
    "<cmd>NuModeToggle<cr>",
    { noremap = true, silent = true, desc = "Toggle number mode" }
)
vim.keymap.set("n", "<leader>uN", "<cmd>NoNuMode<cr>", { noremap = true, silent = true, desc = "No number mode" })
