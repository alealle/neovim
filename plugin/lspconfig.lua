-- :> LSP-config

-- -> Language servers
-- This is the default in Nvim 0.7+
local lsp_flags = {
	debounce_text_changes = 150,
}
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Key bindings suggested by LSP-config page on github
	-- See `:help vim.diagnostic.*` for documentation on any of the below functions
	local opts = { noremap = true, silent = true }
	-- Mappings for all buffers
	vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	-- Enable autoformat
	-- vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})")
	-- Mappings buffer dependent
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "<space>h", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<space>s", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "<space>gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting, bufopts)
	--  Format on save: disabled -> moved to null-ls (except .c, .cpp)
	if client.resolved_capabilities.document_formatting then
		vim.api.nvim_command([[augroup Formatc]])
		vim.api.nvim_command([[autocmd! * <buffer>]])
		vim.api.nvim_command([[autocmd BufWritePre <buffer> lua
	                             vim.lsp.buf.formatting_seq_sync()]])
		vim.api.nvim_command([[autocmd BufWritePre <buffer> echom "formatted!!"]])
		vim.api.nvim_command([[augroup END]])
	else
		vim.api.nvim_command([[echom "client's does not support formatting"]])
	end
	vim.api.nvim_command([[echom "LSP attached"]])
end

-- Clangd:
require("lspconfig").clangd.setup({
	on_attach = on_attach,
	flags = lsp_flags,
})

-- Python:
require("lspconfig").pyright.setup({
	on_attach = on_attach,
	flags = lsp_flags,
})

-- Neovim: no requirements
require("lspconfig").vimls.setup({
	on_attach = on_attach,
	flags = lsp_flags,
})

--- Bash: no requirements
require("lspconfig").bashls.setup({
	GLOB_PATTERN = "*@(.sh|.inc|.bash|.command|.zsh|.zshrc)",
	on_attach = on_attach,
	flags = lsp_flags,
})

-- Lua
require("lspconfig").sumneko_lua.setup({
	on_attach = on_attach,
	flags = lsp_flags,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},

			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

-- Typescript:
require("lspconfig").tsserver.setup({
	on_attach = on_attach,
	filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
	flags = lsp_flags,
	settings = { documentFormatting = true },
})
-- HTML, CSS, Javascript and other languages focused on web development
require("lspconfig").tailwindcss.setup({
	on_attach = on_attach,
	filetypes = {
		"aspnetcorerazor",
		"astro",
		"astro-markdown",
		"blade",
		"django-html",
		"htmldjango",
		"edge",
		"eelixir",
		"elixir",
		"ejs",
		"erb",
		"eruby",
		"gohtml",
		"haml",
		"handlebars",
		"hbs",
		"html",
		"html-eex",
		"heex",
		"jade",
		"leaf",
		"liquid",
		"markdown",
		"mdx",
		"mustache",
		"njk",
		"nunjucks",
		"php",
		"razor",
		"slim",
		"twig",
		"css",
		"less",
		"postcss",
		"sass",
		"scss",
		"stylus",
		"sugarss",
		"javascript",
		"javascriptreact",
		"reason",
		"rescript",
		"vue",
		"svelte",
	},
	flags = lsp_flags,
	init_options = {
		userLanguages = {
			eelixir = "html-eex",
			eruby = "erb",
			html = "html",
			css = "css",
		},
	},
	settings = { documentFormatting = true },
})
