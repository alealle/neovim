local api = vim.api
-- Format on saving
local FormatGroupId = api.nvim_create_augroup("PreWriteFormatGroup",
    {clear = true})
api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.py", "*.pyi",
        "*.cpp", "*.c", "*.h",
        "*.html", "*.css", "*.xml",
        "*.java",
        "*.sh", "*.zsh", "*.bash",
        "*.ts", "*.ns", "*.json", "*.js", "*.yaml",
        "*.sql"
    },
    callback =function ()
        -- 10/03/2023 removing schedule so that does not print the msg to terminal
        vim.schedule(function ()
            vim.lsp.buf.format()
            print("File formatted")
        end)
    end,
    group = FormatGroupId,
})
