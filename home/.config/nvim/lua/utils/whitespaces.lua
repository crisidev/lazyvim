local module = {}

module.auto = false

function module.trim(force)
    if force ~= nil then
        force = false
    else
        force = module.auto
    end
    if module.auto then
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end
end

return module
