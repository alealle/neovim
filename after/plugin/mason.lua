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
        "autopep8",
        "bashls",
        "black",
        "clangd",
        "cmake",
        "eslint_d",
        "flake_8",
        "jdtls",
        "quick_lint_js",
        "prettier",
        "prettierd",
        "pyright",
        "sumneko_lua",
        "sqlls",
        "tailwindcss",
        "tsserver",
        "vimls",
    },
})
