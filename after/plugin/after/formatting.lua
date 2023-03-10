local api = vim.api
-- Format on saving
local FormatGroupId = api.nvim_create_augroup("PreWriteFormatGroup",
    {clear = true})
api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.py", "*.pyi",
        "*.cpp", "*.c", "*.h",
        "*.html", "*.css", "*.xml",
        "*.sh", "*.zsh", "*.bash",
        "*.ts", "*.ns", "*.json", "*.js", "*.yaml",
    },
    callback =function ()
        vim.schedule(function ()
            vim.lsp.buf.format()
            print("File formatted")
        end)
    end,
    group = FormatGroupId,
})
