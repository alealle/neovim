-- :> Completion
-- Set up nvim-cmp.
local cmp = require("cmp")

if cmp == nil then
	return
end

-- Changes nvim menu
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- load snips
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

--   פּ ﯟ   some other good icons
local kind_icons = {
	Text = "",
	Method = "m",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.close(),
		-- Accept currently selected item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		-- ["<CR>"] = cmp.mapping.confirm({
		-- 	select = true,
		-- 	behavior = cmp.ConfirmBehavior.Replace,
		-- }),
		["<c-y>"] = cmp.mapping(
			cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = true,
			}),
			{ "i", "c" }
		),

		["<c-space>"] = cmp.mapping({
			i = cmp.mapping.complete(),
			c = function(
				_ --[[fallback]]
			)
				if cmp.visible() then
					if not cmp.confirm({ select = true }) then
						return
					end
				else
					cmp.complete()
				end
			end,
		}),

		-- ["<tab>"] = false,
		["<tab>"] = cmp.config.disable,

		-- ["<tab>"] = cmp.mapping {
		--   i = cmp.config.disable,
		--   c = function(fallback)
		--     fallback()
		--   end,
		-- },

		-- Testing
		["<c-q>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),

		-- If you want tab completion :'
		--  First you have to just promise to read `:help ins-completion`.
		--
		-- ["<Tab>"] = function(fallback)
		--   if cmp.visible() then
		--     cmp.select_next_item()
		--   else
		--     fallback()
		--   end
		-- end,
		-- ["<S-Tab>"] = function(fallback)
		--   if cmp.visible() then
		--     cmp.select_prev_item()
		--   else
		--     fallback()
		--   end
		-- end,
	}),
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			-- Kind icons
			vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
			-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				luasnip = "[Snippet]",
				buffer = "[Buffer]",
				path = "[Path]",
			})[entry.source.name]
			return vim_item
		end,
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp", keyword_length = 3 },
		-- { name = 'vsnip' }, -- For vsnip users.
		{ name = "luasnip", option = { use_show_condition = false }, keyword_length = 2 }, -- For luasnip users.
		-- { name = "ultisnips" }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
		{ name = "buffer",
          option = {
                    get_bufnrs = function()
                                   return vim.api.nvim_list_bufs()
                                   end
                   },
         keyword_length = 5 },
	}),
    experimental = {
        ghost_text = true,
    },
})

-- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--  sources = cmp.config.sources({
--     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--   }, {
--     { name = 'buffer' },
--   })
-- })

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline({
        -- ['<CR>'] = function(fallback)
        --                     if cmp.visible() then
        --                         cmp.confirm()
        --                     else
        --                         fallback() -- If you use vim-endwise, this fallback will behave the same as vim-endwise.
        --                     end
        --             end,
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.close(),
		-- Accept currently selected item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		-- ["<CR>"] = cmp.mapping.confirm({
		-- 	select = true,
		-- 	behavior = cmp.ConfirmBehavior.Replace,
		-- }),
		["<c-y>"] = cmp.mapping(
			cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = true,
			}),
			{ "i", "c" }
		),

		["<c-space>"] = cmp.mapping({
			i = cmp.mapping.complete(),
			c = function(
				_ --[[fallback]]
			)
				if cmp.visible() then
					if not cmp.confirm({ select = true }) then
						return
					end
				else
					cmp.complete()
				end
			end,
		}),

		-- ["<tab>"] = false,
		["<tab>"] = cmp.config.disable,

		-- ["<tab>"] = cmp.mapping {
		--   i = cmp.config.disable,
		--   c = function(fallback)
		--     fallback()
		--   end,
		-- },

		-- Testing
		["<c-q>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),

		-- If you want tab completion :'(
		--  First you have to just promise to read `:help ins-completion`.
		--
		-- ["<Tab>"] = function(fallback)
		--   if cmp.visible() then
		--     cmp.select_next_item()
		--   else
		--     fallback()
		--   end
		-- end,
		-- ["<S-Tab>"] = function(fallback)
		--   if cmp.visible() then
		--     cmp.select_prev_item()
		--   else
		--     fallback()
		--   end
		-- end,
	}),
	sources = cmp.config.sources({
		{ name = "path", keyword_length = 5 },
	}, {
		{ name = "cmdline", keyword_length = 5 },
	}),
})

-- Add vim-dadbod-completion in sql files
_ = vim.cmd([[
  augroup DadbodSql
    au!
    autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer { sources = { { name = 'vim-dadbod-completion' } } }
  augroup END
]])

_ = vim.cmd([[
  augroup CmpZsh
    au!
    autocmd Filetype zsh lua require'cmp'.setup.buffer { sources = { { name = "zsh" }, } }
  augroup END
]])

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require("lspconfig")["clangd"].setup({
	capabilities = capabilities,
})
require("lspconfig")["pyright"].setup({
	capabilities = capabilities,
})
require("lspconfig")["vimls"].setup({
	capabilities = capabilities,
})
require("lspconfig")["bashls"].setup({
	capabilities = capabilities,
})
require("lspconfig")["lua_ls"].setup({
	capabilities = capabilities,
})
require("lspconfig")["tsserver"].setup({
	capabilities = capabilities,
})
require("lspconfig")["tailwindcss"].setup({
	capabilities = capabilities,
})
require("lspconfig")["sqlls"].setup({
	capabilities = capabilities,
})
