-- :> Consolidates all Lsp managers (Mason, Mason-LSP, LSP, NULLS) plugins in a single config file
local status, mason = pcall(require, "mason")
if not status then
	return
end

local status2, mylspconfig = pcall(require, "lspconfig")
if not status2 then
	return
end

local status3, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status3 then
	return
end

local status4, formatter = pcall(require, "formatter")
if not status4 then
	return
end
local util = require("formatter.util")

--local status4, mason_null_ls = pcall(require, "mason-null-ls")
--if not status4 then
--	return
--end
--
--local status5, null_ls = pcall(require, "null-ls")
--if not status5 then
--	return
--end

-- :>mason
mason.setup({})

-- :> mason_lspconfig
local DEFAULT_SETTINGS = {
	-- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "lua_ls" }
	-- This setting has no relation with the `automatic_installation` setting.
	---@type string[]
	ensure_installed = {
        "rust_analyzer",
		"arduino_language_server",
		"bashls",
		"clangd",
		"cmake",
		-- "eslint",
		"jdtls",
		-- "quick_lint_js",
		--"prettier",
		"pyright",
		"lua_ls",
		"sqlls",
        "terraformls",
        "tflint",
		"tailwindcss",
		"tsserver",
		"vimls",
	},

	-- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
	-- This setting has no relation with the `ensure_installed` setting.
	-- Can either be:
	--   - false: Servers are not automatically installed.
	--   - true: All servers set up via lspconfig are automatically installed.
	--   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
	--       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
	automatic_installation = true,
}

mason_lspconfig.setup(DEFAULT_SETTINGS)

mason_lspconfig.setup_handlers({
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function(server_name) -- default handler (optional)
		mylspconfig[server_name].setup({})
	end,
	-- Next, you can provide a dedicated handler for specific servers.
	-- For example, a handler override for the `rust_analyzer`:
	-- ["rust_analyzer"] = function ()
	--     require("rust-tools").setup {}
	-- end
	-- If you use this approach, make sure you don't also manually set up servers
	--     directly via `lspconfig` as this will cause servers to be set up more than
	--     once.
})

-- :> LSP-config
-- -> Language servers
-- This is the default in Nvim 0.7+
local lsp_flags = {
	debounce_text_changes = 150,
}
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- key bindings suggested by lsp-config page on github
	-- see `:help vim.diagnostic.*` for documentation on any of the below functions
	local opts = { noremap = true, silent = true }
	-- mappings for all buffers
	vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

	-- enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	-- enable autoformat
	-- vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})")
	-- mappings buffer dependent
	-- see `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gd", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "<space>h", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<space>s", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<space>d", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "<space>gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<space>f", vim.lsp.buf.format, bufopts)
	-- (10/03/2023) format on save moved to formatting.lua
	--  (2022) format on save: disabled -> moved to null-ls (except .c, .cpp)
	-- if client.supports_method("textdocument/formatting") then
	--     vim.api.nvim_command([[augroup formatc]])
	--     vim.api.nvim_command([[autocmd! * <buffer>]])
	--     vim.api.nvim_command([[autocmd bufwritepre <buffer> lua
	--                              vim.lsp.buf.format()]])
	--     vim.api.nvim_command([[autocmd bufwritepre <buffer> echom "formatted!!"]])
	--     vim.api.nvim_command([[augroup end]])
	-- else
	--     vim.api.nvim_command([[echom "client's does not support formatting"]])
	-- end
	-- vim.api.nvim_command([[echom "lsp attached"]])
end

-- clangd:
-- fix to get rid of warning for conflict with nullls: multiple enconding
-- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
-- check https://clangd.llvm.org/installation for improving build and
-- autocompletion with YouCompleteMe
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = { "utf-16" }
mylspconfig.clangd.setup({
	on_attach = on_attach,
	flags = lsp_flags,
	capabilities = capabilities,
})

-- Python:
mylspconfig.pyright.setup({
	on_attach = on_attach,
	flags = lsp_flags,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
			},
		},
	},
})

-- Neovim: no requirements
mylspconfig.vimls.setup({
	on_attach = on_attach,
	flags = lsp_flags,
})

--- Bash: no requirements
mylspconfig.bashls.setup({
	GLOB_PATTERN = "*@(.sh|.inc|.bash|.command|.zsh|.zshrc)",
	on_attach = on_attach,
	flags = lsp_flags,
})

-- Lua
mylspconfig.lua_ls.setup({
	on_attach = on_attach,
	flags = lsp_flags,
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
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
-- Rust commented to not cause conflicts with rust-tools config
-- mylspconfig.rust_analyzer.setup({
-- on_attach = function(client, bufnr)
--         vim.lsp.inlay_hint.enable(bufnr)
--     end,
--     capabilities = capabilities,
-- filetypes = {"rust"},
--     root_dir = mylspconfig.util.root_pattern("Cargo.toml"),
--   settings = {
--     ["rust_analyzer"] = {
--             imports = {
--                 granularity = {
--                     group = "module",
--                 },
--                 prefix = "self",
--             },
--             cargo = {
--                 allFeatures = true,
--                 buildScripts = {
--                     enable = true,
--                 },
--             },
--             procMacro = {
--                 enable = true
--             },
--         }
--     }
--       })
-- Typescript:
mylspconfig.tsserver.setup({
	on_attach = on_attach,
	filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
	flags = lsp_flags,
	settings = { documentFormatting = true },
})

-- HTML, CSS, Javascript and other languages focused on web development
mylspconfig.tailwindcss.setup({
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

-- unocss: backup for tailwindcss
--require'lspconfig'.unocss.setup{}
-- Terraform
mylspconfig.terraformls.setup({
    root_dir = mylspconfig.util.root_pattern('.terraform', '.git','.'),
})

mylspconfig.tflint.setup({
    root_dir = mylspconfig.util.root_pattern('.terraform', '.git','.'),
})

-- Scala
mylspconfig.metals.setup{
    root_dir = mylspconfig.util.root_pattern("build.sbt", "build.sc", "build.gradle", "pom.xml",'.'),
}
-- SQL
mylspconfig.sqlls.setup({})

-- :> null-ls: first source of truth
-- :> having known that null-ls has been archived and that it may conflict with
-- nvim core https://www.youtube.com/watch?v=oy_-hQdkoXg, I decided to stop using it
-- null_ls.setup({
-- 	sources = {
-- 		-- Code action
-- 		null_ls.builtins.code_actions.eslint_d,
-- 		null_ls.builtins.code_actions.shellcheck,
-- 		-- Filetypes: { "go", "javascript", "lua", "python", "typescript" }
-- 		null_ls.builtins.code_actions.refactoring,
-- 		----------------------------------------------------------------------
-- 		-- Diagnostics
-- 		-- Filetypes: { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" }
-- 		-- Mason: null_ls.builtins.diagnostics.eslint_d,
-- 		-- Filetypes: { "python" } -- eliminating redundancy because lspconfig has pyright
-- 		-- null_ls.builtins.diagnostics.flake8,
-- 		-- Filetypes: {"sh"}
-- 		-- Mason: null_ls.builtins.diagnostics.shellcheck,
-- 		-- Filetypes: {"vim"}
-- 		null_ls.builtins.diagnostics.vint,
-- 		-- Filetypes: { "scss", "less", "css", "sass" }
-- 		-- null_ls.builtins.diagnostics.stylelint,
-- 		-- Filetypes: { "html", "xml" }
-- 		null_ls.builtins.diagnostics.tidy,
-- 		----------------------------------------------------------------------
-- 		--Formatting
-- 		-- null_ls.builtins.formatting.autopep8,
-- 		-- Mason: null_ls.builtins.formatting.beautysh.with({
-- 		--    filetypes = { "bash", "sh", "zsh" }, -- change to your dialect
-- 		--}),
-- 		-- c
-- 		null_ls.builtins.formatting.uncrustify,
-- 		-- python
-- 		null_ls.builtins.formatting.black,
-- 		null_ls.builtins.formatting.isort,
-- 		--null_ls.builtins.formatting.csharpier,
-- 		-- Filetypes: { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" }
-- 		-- Mason: null_ls.builtins.formatting.eslint_d,
-- 		-- Filetypes: {{ "javascript", "javascriptreact", "typescript", "typescriptreact",
-- 		-- "vue", "css", "scss", "less", "html", "json", "jsonc", "yaml", "markdown",
-- 		-- "markdown.mdx", "graphql", "handlebars" }}
-- 		-- Mason: null_ls.builtins.formatting.prettierd,
--         -- change to your dialect
-- 		null_ls.builtins.formatting.sqlfluff.with({
-- 		    extra_args = { "--dialect", "sqlite" },
-- 		}),
-- Mason: null_ls.builtins.formatting.stylua,
-- 	},
-- on_attach warnings removed after I got to know that NulllsInfo does it
--    on_attach = function(client, bufnr)
--        --  Code moved from lspconfig.lua
--        if client.supports_method("textDocument/formatting") then
--            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
--            vim.api.nvim_create_autocmd("BufWritePre", {
--                group = augroup,
--                buffer = bufnr,
--                callback = function()
--                    -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
--                    -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
--                    vim.lsp.buf.formatting_sync()
--                end,
--            })
--        else
--            vim.api.nvim_command([[echom "Nulls client's does not support formatting"]])
--        end
--        vim.api.nvim_command([[echom "Null-ls attached"]])
--    end,
-- })

-- > mason-null-ls
-- mason_null_ls.setup({
-- 	ensure_installed = {
-- 		-- Opt to list sources here, when available in mason.
-- 		-- .sh
-- 		-- "black",
-- 		"eslint_d",
-- 		-- .sh
-- 		"shellcheck",
-- 		--"sqlfluff",
-- 		"stylelint",
-- 	},
-- 	automatic_installation = false,
-- 	handlers = {},
-- })
-- Utilities for creating configurations

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
formatter.setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		-- Formatter configurations for filetype "lua" go here
		-- and will be executed in order
		lua = {
			-- "formatter.filetypes.lua" defines default configurations for the
			-- "lua" filetype
			require("formatter.filetypes.lua").stylua,

			-- You can also define your own configuration
			function()
				-- Full specification of configurations is down below and in Vim help
				-- files
				return {
					exe = "stylua",
					args = {
						"--search-parent-directories",
						"--stdin-filepath",
						util.escape_path(util.get_current_buffer_file_path()),
						"--",
						"-",
					},
					stdin = true,
				}
			end,
		},

		--		java = {
		--			-- "formatter.filetypes.lua" defines default configurations for the
		--			-- "lua" filetype
		--			require("formatter.filetypes.java").google_java_format,
		--
		--			function()
		--				-- Full specification of configurations is down below and in Vim help
		--				-- files
		--				return {
		--					stdin = true,
		--				}
		--			end,
		--		},
	},
})
vim.keymap.set("n", "<leader>=", function()
	vim.api.nvim_command([[:Format]])
end, { noremap = true })
vim.api.nvim_command([[echom "All LSP plugins setup"]])
