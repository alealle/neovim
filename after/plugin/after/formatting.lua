local api = vim.api
-- Format on saving
local FormatGroupId = api.nvim_create_augroup("PreWriteFormatGroup",
    { clear = true })
api.nvim_create_autocmd("BufWritePre", {
    pattern = { -- removed python as pyright not formats "*.py", "*.pyi",
        "*.cpp", "*.c", "*.h",
        "*.go",
        "*.html", "*.css", "*.xml",
        "*.java",
        "*.lua",
        "*.sh", "*.zsh", "*.bash",
        "*.ts", "*.ns", "*.json", "*.js", "*.yaml",
        "*.sql",
        "*.rs"
    },
    callback = function()
        -- 10/03/2023 removing schedule so that does not print the msg to terminal
        vim.schedule(function()
            vim.lsp.buf.format()
            print("File formatted")
        end)
    end,
    group = FormatGroupId,
})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*.py" },
    desc = "Auto-format Python files before saving",
    callback = function()
        local fileName = vim.api.nvim_buf_get_name(0)
        vim.cmd(":silent !black --preview -q " .. fileName)
        vim.cmd(":silent !isort --profile black --float-to-top -q " .. fileName)
        vim.cmd(":silent !docformatter --in-place --black " .. fileName)
        vim.schedule(function()
            vim.lsp.buf.format()
            print("File formatted")
        end)
    end,
    group = FormatGroupId,
})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*.tf" },
    desc = "Auto-format Terraform before saving",
    callback = function()
        local fileName = vim.api.nvim_buf_get_name(0)
        vim.cmd(":silent !terraform fmt " .. fileName)
        vim.schedule(function()
            vim.lsp.buf.format()
            print("File formatted")
        end)
    end,
    group = FormatGroupId,
})
