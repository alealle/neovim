if not pcall(require, "luasnip") then
	-- vim.fn.echom("snippets not found")
	return
end

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

ls.config.set_config({
	-- Enable autosnippet
	enable_autosnippets = true,
	history = true,

	-- Enable dynamic update of snippets during typing
	updateedevents = "TextChanged, TextChangedI",
	-- <c-k> is my expansion key
	-- this will expand the current item or jump to the next item within the snippet.
})

vim.keymap.set({ "i", "s" }, "<c-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = false })

-- <c-j> is my jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<c-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>")

-- load test snippet for all files
ls.add_snippets("all", {
	s("aal", { t("Alessandro Alle") }),
})

-- Load snippets using lua format
require("luasnip.loaders.from_lua").load()
