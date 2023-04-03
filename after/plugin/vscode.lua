-- Lua:
if vim.g.colors_name == 'vscode' then
    vim.api.nvim_command('echo "hi"')
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
            mode = "tabs",
            separator_style = "slant",
            always_show_bufferline = false,
            show_buffer_close_icons = false,
            show_close_icon = false,
            color_icons = true,
        },
        highlights = {
            separator = {
                fg = "#073642",
                bg = "#002b36",
            },
            separator_selected = {
                fg = "#073642",
            },
            background = {
                fg = "#457b83",
                bg = "#002b36",
            },
            buffer_selected = {
                fg = "#fdf6e3",
                bold = true,
            },
            fill = {
                bg = "#073642",
            },
        },
    })
    bufferline.setup({
            options = {
            highlights = {
       --         background = {
         --           fg = "#1f1c11",
           --         bg = "#ebecf0",
             --   },
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
end
