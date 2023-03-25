-- Lua:
require('lualine').setup({
    options = {
        -- ...
        theme = 'vscode',
        -- ...
    },
})

local status, bufferline = pcall(require, "bufferline")
if not status then
    return
end

bufferline.setup({
        options = {
        highlights = {
            background = {
                fg = "#1f1c11",
                bg = "#ebecf0",
            },
            buffer_selected = {
                fg = "#fd1cfc",
                bold = true,
            },
            fill = {
                bg = "#ebecf0",
            },
         }
    }
    })
