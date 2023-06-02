-- import lspsaga safely
local status, saga = pcall(require, "lspsaga")
if (not status) then return end

saga.setup({
  ui = {
    winblend = 10,
    border = 'rounded',
    colors = {
      normal_bg = '#002b36'
    }
  },
})

local keymap = vim.keymap.set
--
-- -- Lsp finder find the symbol definition implement reference
-- -- if there is no implement it will hide
-- -- when you use action in finder like open vsplit then you can
-- -- use <C-t> to jump back
keymap("n", "<leader>F", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
--
-- -- Code action
keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })
--
-- Rename
keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true })
--
-- Peek Definition
-- you can edit the definition file in this flaotwindow
-- also support open/vsplit/etc operation check definition_action_keys
-- support tagstack C-t jump back
keymap("n", "<leader>d", "<cmd>Lspsaga peek_definition<CR>", { silent = true })
--
-- -- Show line diagnostics
keymap("n", "<leader>a", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
--
--- Show buffer diagnostics
keymap("n", "<leader>ab", "<cmd>Lspsaga show_buf_diagnostics<CR>")

-- Show cursor diagnostic
keymap("n", "<leader>A", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })

-- Diagnsotic jump can use `<c-o>` to jump back
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })
--
-- Only jump to error
keymap("n", "[E", function()
    require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
keymap("n", "]E", function()
    require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
--
-- Outline
keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>")
--
-- -- Hover Doc
keymap("n", "<leader>h", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
--
-- Float terminal
-- keymap("n", "<leader>i", "<cmd>Lspsaga open_floaterm<CR>", { silent = true })
-- if you want pass somc cli command into terminal you can do like this
-- open lazygit in lspsaga float terminal
-- keymap("n", "<leader>I", "<cmd>Lspsaga open_floaterm lazygit<CR>", { silent = true })
-- close floaterm
--keymap("t", "<leader>i", [[<C-\><C-n><cmd>Lspsaga close_floaterm<CR>]], { silent = true })
-- Float terminal
keymap({ "n", "t" }, "<leader>i", "<cmd>Lspsaga term_toggle<CR>")
