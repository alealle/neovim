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
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
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
end -- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
--[[
"rust_analyzer",
		"arduino_language_server",
		"bashls",
		"clangd",
		"cmake",
        "gopls",
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
		"ts_ls",
		"vimls",zR
        ]] --
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
        "gopls",
        -- "eslint",
        "jdtls",
        -- "quick_lint_js",
        --"prettier",
        "pyright",
        -- using mason to setup lua_ls because otherwise (via lspconfi)
        "lua_ls",
        "sqlls",
        "terraformls",
        "tflint",
        "tailwindcss",
        "ts_ls",
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
    -- Defaults
    function(server_name) -- default handler (optional)
        mylspconfig[server_name].setup({
            tonga = { "milonga" },
            on_attach = on_attach,
            flags = lsp_flags,
            settings = {
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { "vim" },
                },

            },
            capabilities = capabilities,
        })
    end,
    -- Next, you can provide a dedicated handler for specific servers.
    -- For example, a handler override for the `rust_analyzer`:
    -- ["rust_analyzer"] = function ()
    --     require("rust-tools").setup {}
    -- end
    -- If you use this approach, make sure you don't also manually set up servers
    --     directly via `lspconfig` as this will cause servers to be set up more than
    --     once.

    -- Python
    ["pyright"] = function()
        mylspconfig.pyright.setup({
            tong1 = { "milongs" },
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                    },
                },
            },
        })
    end,

    -- C
    ["clangd"] = function()
        mylspconfig.clangd.setup({
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
            cmd = {
                "clangd",
                --    "--offset-encoding=utf-16",
            },
        })
    end,
    ["bashls"] = function()
        mylspconfig.bashls.setup({
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
            GLOB_PATTERN = "*@(.sh|.inc|.bash|.command|.zsh|.zshrc)",
        })
    end,
    ["ts_ls"] = function()
        mylspconfig.ts_ls.setup({
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "typescript.tsx" },
        })
    end,
    -- HTML, CSS, Javascript and other languages focused on web development
    ["tailwindcss"] = function()
        mylspconfig.tailwindcss.setup({
            capabilities = capabilities,
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
                --	"javascript",
                -- "javascriptreact",
                "reason",
                "rescript",
                -- "vue",
                "svelte",
            },
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
    end,
    -- Golang
    ['gopls'] = function()
        require 'lspconfig'.gopls.setup {
            on_attach = on_attach,
            cmd = { "gopls" },
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            root_dir = mylspconfig.util.root_pattern("go.work", "go.mod", ".git"),
            settings = {
                gopls = {
                    completeUnimported = true,
                    usePlaceholders = true,
                    analyses = {
                        unusedparams = true,
                    },
                },
            },
        }
    end,

    -- Terraform
    ['terraformls'] = function()
        mylspconfig.terraformls.setup({
            root_dir = mylspconfig.util.root_pattern('.terraform', '.git', '.'),
        })
    end,

    ['tflint'] = function()
        mylspconfig.tflint.setup({
            root_dir = mylspconfig.util.root_pattern('.terraform', '.git', '.'),
        })
    end,

    -- Scala
    -- ['metals'] = function()
    --     mylspconfig.metals.setup {
    --         root_dir = mylspconfig.util.root_pattern("build.sbt", "build.sc", "build.gradle", "pom.xml", '.'),
    --     }
    -- end,
})

--[[transfering setup to mason
mylspconfig.clangd.setup({
    on_attach = on_attach,
    flags = lsp_flags,
    cmd = {
        "clangd",
        --    "--offset-encoding=utf-16",
    },
})
mylspconfig.cmake.setup({})
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
--]]
-- Lua
--[[
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
mylspconfig.ts_ls.setup({
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "typescript.tsx" },
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
        --	"javascript",
        -- "javascriptreact",
        "reason",
        "rescript",
        -- "vue",
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
    root_dir = mylspconfig.util.root_pattern('.terraform', '.git', '.'),
})

mylspconfig.tflint.setup({
    root_dir = mylspconfig.util.root_pattern('.terraform', '.git', '.'),
})


-- SQL
mylspconfig.sqlls.setup({})


-- Golang
require 'lspconfig'.gopls.setup {
    on_attach = on_attach,
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_dir = mylspconfig.util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
                unusedparams = true,
            },
        },
    },
}
]] --

-- Lua
mylspconfig.lua_ls.setup({
    on_attach = on_attach,
    flags = lsp_flags,
    cmd = { '/usr/local/bin/lua-language-server' },
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
                globals = { "vim", },
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
    capabilities = capabilities,
})

-- Scala
mylspconfig.metals.setup {
    root_dir = mylspconfig.util.root_pattern("build.sbt", "build.sc", "build.gradle", "pom.xml", '.'),
}
-- Zig
mylspconfig.zls.setup {
    cmd = { '/usr/local/bin/zls' }
}

-- Ending
vim.api.nvim_command([[echom "All LSP plugins setup"]])
