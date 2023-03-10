local status, mason = pcall(require, "mason")
if not status then
    return
end
local status2, lspconfig = pcall(require, "mason-lspconfig")
if not status2 then
    return
end

mason.setup({})

lspconfig.setup({
    ensure_installed = {
        "arduino_language_server",
        "bashls",
        "clangd",
        "cmake",
        -- "eslint",
        -- "jdtls",
        -- "quick_lint_js",
        --"prettier",
        "pyright",
        "lua_ls",
        "sqlls",
        "tailwindcss",
        "tsserver",
        "vimls",
    },
})
