if not pcall(require, "luasnip") then
	-- vim.fn.echom("snippets not found")
	return
end

local ls = require("luasnip")

-- <c-k> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
vim.api.nvim_command('echomsg "fund"')
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
