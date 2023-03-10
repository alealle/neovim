local status, null_ls = pcall(require, "null-ls")
if not status then
	return
end

local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })

null_ls.setup({
	sources = {
		-- Code action
		null_ls.builtins.code_actions.eslint_d,
		null_ls.builtins.code_actions.shellcheck,
        -- Filetypes: { "go", "javascript", "lua", "python", "typescript" }
        null_ls.builtins.code_actions.refactoring,
		----------------------------------------------------------------------
		-- Diagnostics
		-- Filetypes: { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" }
		null_ls.builtins.diagnostics.eslint_d,
		-- Filetypes: { "python" }
		null_ls.builtins.diagnostics.flake8,
        -- Filetypes: {"sh"}
		null_ls.builtins.diagnostics.shellcheck,
		-- Filetypes: {"vim"}
        null_ls.builtins.diagnostics.vint,
        -- Filetypes: { "scss", "less", "css", "sass" }
		null_ls.builtins.diagnostics.stylelint,
        -- Filetypes: { "html", "xml" }
        null_ls.builtins.diagnostics.tidy,
		----------------------------------------------------------------------
		--Formatting
		-- null_ls.builtins.formatting.autopep8,
		null_ls.builtins.formatting.beautysh.with({
			filetypes = { "bash", "sh", "zsh" }, -- change to your dialect
		}),
		null_ls.builtins.formatting.uncrustify,
		null_ls.builtins.formatting.black,
		--null_ls.builtins.formatting.csharpier,
		-- Filetypes: { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" }
		null_ls.builtins.formatting.eslint_d,
		-- Filetypes: {{ "javascript", "javascriptreact", "typescript", "typescriptreact",
		-- "vue", "css", "scss", "less", "html", "json", "jsonc", "yaml", "markdown",
		-- "markdown.mdx", "graphql", "handlebars" }}
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.sqlfluff.with({
			extra_args = { "--dialect", "postgres" }, -- change to your dialect
		}),
		null_ls.builtins.formatting.stylua,
	},
	on_attach = function(client, bufnr)
		--  Code moved from lspconfig.lua
		if client.server_capabilities.document_formatting then
			vim.api.nvim_command([[augroup Format]])
			vim.api.nvim_command([[autocmd! * <buffer>]])
			vim.api.nvim_command([[autocmd BufWritePre <buffer> lua
                                vim.lsp.buf.format()]])
			vim.api.nvim_command([[autocmd BufWritePre <buffer> echom "nullls formatted"]])
			vim.api.nvim_command([[augroup END]])
		else
			vim.api.nvim_command([[echom "Nulls client's does not support formatting"]])
		end
		vim.api.nvim_command([[echom "Null-ls attached"]])
	end,
})
