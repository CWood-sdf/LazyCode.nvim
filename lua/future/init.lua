local M = {}

local futures = {}
local profile = {}
M.load = function(name, callback)
    futures[name] = callback
end

M._loadFutures = function()
    for name, callback in pairs(futures) do
        local startTick = vim.uv.hrtime()
        callback()
        local endTick = vim.uv.hrtime()
        profile[name] = endTick - startTick
        futures[name] = nil
    end

    vim.cmd('e')
end

local bufnr = nil
M.profile = function()
    if bufnr == nil then
        bufnr = vim.api.nvim_create_buf(false, true)
    end
    vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
    local offsetX = 8
    local offsetY = 3
    local width = vim.o.columns - offsetX * 2
    local height = vim.o.lines - offsetY * 2 - 4
    vim.api.nvim_open_win(bufnr, true, {
        relative = "win",
        width = width,
        height = height,
        row = offsetY,
        col = offsetX,
        style = "minimal",
    })

    local lines = {}
    local name = "Futures Profile"
    while #name < width do
        name = " " .. name .. " "
    end
    if #name > width then
        name = string.sub(name, 1, width)
    end
    table.insert(lines, name)

    local seperator = string.rep("-", width)
    table.insert(lines, seperator)

    for n, time in pairs(profile) do
        table.insert(lines, string.format("  %s: %fms", n, time / 1000000))
    end


    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
    vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
    vim.api.nvim_buf_set_var(bufnr, "no", false)

    vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":q<CR>", { noremap = true, silent = true })
end


return M
