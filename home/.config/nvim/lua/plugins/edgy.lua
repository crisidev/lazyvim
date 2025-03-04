return {
    "folke/edgy.nvim",
    opts = function(_, opts)
        opts.animate = { enabled = false }
        -- Bottom term height
        for _, element in ipairs(opts.bottom) do
            if element.ft == "snacks_terminal" then
                element.size.height = 0.2
            end
        end
        -- Move tests to right panel
        for i, element in ipairs(opts.left) do
            if element.ft == "neotest-output-panel" then
                table.insert(opts.right, element)
                table.remove(opts.left, i)
            end
            if element.ft == "neotest-summary" then
                table.insert(opts.right, element)
                table.remove(opts.left, i)
            end
        end
        return opts
    end,
}
