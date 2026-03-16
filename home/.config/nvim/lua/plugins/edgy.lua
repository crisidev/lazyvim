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
        local new_left = {}
        for _, element in ipairs(opts.left) do
            if element.ft == "neotest-output-panel" or element.ft == "neotest-summary" then
                table.insert(opts.right, element)
            else
                table.insert(new_left, element)
            end
        end
        opts.left = new_left
        return opts
    end,
}
