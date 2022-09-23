-- :> nvim-tree
-- Following changes in config acc. https://github.com/kyazdani42/nvim-tree.lua
require("nvim-tree").setup({
	disable_netrw = true,
	hijack_netrw = true,
	-- open_on_tab = true,
	sort_by = "case_sensitive",
	view = {
		adaptive_size = true,
		mappings = {
			list = {
				{ key = "u", action = "dir_up" },
				{ key = "<CR>", action = "tabnew" },
				{ key = "<C-b>", action = "edit" },
			},
		},
		number = true,
		relativenumber = true,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
	},
	diagnostics = { enable = true },
	system_open = { cmd = "silent toggle_replace" },
})
local function toggle_replace()
	local view = require("nvim-tree.view")
	if view.is_visible() then
		view.close()
	else
		require("nvim-tree").open_replacing_current_buffer()
	end
end

vim.keymap.set("n", "<C-;>", toggle_replace)
vim.keymap.set("n", "<leader>.", ":NvimTreeToggle<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>/", ":NvimTreeFindFile<CR>", { silent = true, noremap = true })
