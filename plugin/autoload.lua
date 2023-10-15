local hasSetup = false

local luaFutures = vim.api.nvim_create_augroup("LuaFutures", {
    clear = true
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*.*",
    callback = function()
        if not hasSetup then
            hasSetup = true
            vim.api.nvim_command("lua require('future')._loadFutures()")
            print("Loaded lua-futures")
        end
    end,
    group = luaFutures
})

vim.api.nvim_create_user_command("Future", function(_)
    vim.api.nvim_command("lua require('future').profile()")
end, {})
