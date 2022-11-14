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
		--"autopep8",
		"bashls",
		"clangd",
		--"black",
		"cmake",
		--"flake_8",
		--"eslint_d",
		"jdtls",
		"quick_lint_js",
		--"prettier",
		"pyright",
		--"prettierd",
		"sumneko_lua",
		"sqlls",
		"tailwindcss",
		"tsserver",
		"vimls",
	},
})
