"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Author:
"       Alessandro Alle
"
" This file is necessary because vim overwrites any formatoptions
" set in init.vim when loading my plugins, since plugins are
" loaded after loading init.vim in vim start up process.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Disable comment sign insertion in a new line after C-r in a comment line
set formatoptions=jcql

" Plugins settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :> Nerd Tree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" let g:NERDTreeWinPos = "right"
" let NERDTreeShowHidden=1
" let NERDTreeIgnore = ['\.pyc$', '__pycache__']
" let g:NERDTreeWinSize=35
" map <leader>nn :NERDTreeToggle<cr>
" map <leader>nb :NERDTreeFromBookmark<Space>
" map <leader>nf :NERDTreeFind<cr>
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" :> LSP-config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
"
" -> Language servers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
lua << EOF
-- This is the default in Nvim 0.7+
local lsp_flags = {
  debounce_text_changes = 150,
}
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    -- Key bindings suggested by LSP-config page on github
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    local opts = { noremap=true, silent=true }
    -- Mappings for all buffers
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- Enable autoformat
    vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr(#{timeout_ms:250})')
    -- Mappings buffer dependent
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', '<space>h', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<space>s', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<space>gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
    --  Format on save
    if client.resolved_capabilities.document_formatting then
         vim.api.nvim_command[[augroup Format]]
         vim.api.nvim_command[[autocmd! * <buffer>]]
         vim.api.nvim_command[[autocmd BufWritePre <buffer> lua
                                vim.lsp.buf.formatting_seq_sync()]]
         vim.api.nvim_command[[echom "formatted"]]
         vim.api.nvim_command[[augroup END]]
    else
         vim.api.nvim_command[[echom "client's does not support formatting"]]
    end
    vim.api.nvim_command[[echom "attached"]]
end

-- Clang:
require'lspconfig'.clangd.setup{
     on_attach = on_attach,
     flags = lsp_flags,
}

-- Python:
require'lspconfig'.pyright.setup{
    on_attach = on_attach,
    flags = lsp_flags,
}

-- Neovim: no requirements
require'lspconfig'.vimls.setup{
    on_attach = on_attach,
    flags = lsp_flags,
}

--- Bash: no requirements
require'lspconfig'.bashls.setup{
    GLOB_PATTERN = "*@(.sh|.inc|.bash|.command|.zsh|.zshrc)",
    on_attach = on_attach,
    flags = lsp_flags,
}

-- Lua
require'lspconfig'.sumneko_lua.setup{
    on_attach = on_attach,
    flags = lsp_flags,
    settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
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
}

-- Typescript:
require'lspconfig'.tsserver.setup{
    on_attach = on_attach,
    filetypes = {"typescript", "typescriptreact", "typescript.tsx"},
    flags = lspflags,
    settings = {documentFormatting = true}
}

EOF

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :> Lspsaga
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
lua << EOF
local keymap = vim.keymap.set
local saga = require('lspsaga')

saga.init_lsp_saga
{
    border_style = "rounded"
}

-- Lsp finder find the symbol definition implement reference
-- if there is no implement it will hide
-- when you use action in finder like open vsplit then you can
-- use <C-t> to jump back
keymap("n", "<leader>F", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })

-- Code action
keymap({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })

-- Rename
keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true })

-- Peek Definition
-- you can edit the definition file in this flaotwindow
-- also support open/vsplit/etc operation check definition_action_keys
-- support tagstack C-t jump back
keymap("n", "<leader>d", "<cmd>Lspsaga peek_definition<CR>", { silent = true })

-- Show line diagnostics
keymap("n", "<leader>a", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })

-- Show cursor diagnostic
keymap("n", "<leader>A", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })

-- Diagnsotic jump can use `<c-o>` to jump back
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })

-- Only jump to error
keymap("n", "[E", function()
  require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
keymap("n", "]E", function()
  require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })

-- Outline
keymap("n","<leader>o", "<cmd>LSoutlineToggle<CR>",{ silent = true })

-- Hover Doc
keymap("n", "<leader>h", "<cmd>Lspsaga hover_doc<CR>", { silent = true })

-- Float terminal
keymap("n", "<leader>i", "<cmd>Lspsaga open_floaterm<CR>", { silent = true })
-- if you want pass somc cli command into terminal you can do like this
-- open lazygit in lspsaga float terminal
keymap("n", "<leader>I", "<cmd>Lspsaga open_floaterm lazygit<CR>", { silent = true })
-- close floaterm
keymap("t", "<leader>i", [[<C-\><C-n><cmd>Lspsaga close_floaterm<CR>]], { silent = true })
EOF

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :> Snippets - Ultisnip
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :> Completion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" Autocompletion on every buffer, independent of lsp

set completeopt=menu,menuone,noselect

lua <<EOF
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
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
     documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      -- Accept currently selected item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      ['<Tab>'] = cmp.mapping.confirm({ select = true }),
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
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
         { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
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
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.
                                make_client_capabilities())
  -- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['clangd'].setup {
    capabilities = capabilities}
  require('lspconfig')['pyright'].setup {
    capabilities = capabilities}
  require('lspconfig')['vimls'].setup {
    capabilities = capabilities}
  require('lspconfig')['bashls'].setup {
    capabilities = capabilities}
  require('lspconfig')['sumneko_lua'].setup {
    capabilities = capabilities}
  require('lspconfig')['tsserver'].setup {
    capabilities = capabilities}
EOF
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :> Telescope
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fp <cmd>Telescope registers<cr>
nnoremap <leader>fr <cmd>Telescope lsp_references<cr>
nnoremap <leader>fd <cmd>Telescope lsp_definitions<cr>
""""""""""""za"""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :> Treesitter
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
exec "silent! TSUpdate"
" 1) Ensure that ordinary languages are installed
" 2) Install parsers synchronously (only applied to `ensure_installed`)
" 3) Automatically install missing parsers when entering buffer
" 4) Highlight: `false` will disable the whole extension
" 5) For rainbow (ts-rainbow plugin):
            " a) disable: list of languages you want to disable the plugin for
            " b) extended_mode: also highlight non-bracket delimiters like html
            " tags, boolean or table: lang -> boolean
            " c) max_file_lines: do not enable for files with more than n lines,
            " int
lua require'nvim-treesitter.configs'.setup {
            \ensure_installed = {"c", "cpp","c_sharp", "python", "html", "css",
            \"bash", "sql", "java", "javascript", "typescript", "lua","vim"},
            \sync_install = false,
            \auto_install = true,
            \highlight = {
                \enable = true, disable = {""},
                \additional_vim_regex_highlighting = false
                \},
            \rainbow = {
                \enable = true,
                \disable = {},
                \extended_mode = true,
                \max_file_lines = nil,
                \},
            \indent = {
                \enable = true,
                \disable = {'c','cpp','c_sharp', 'h', 'java', 'python'}
                \}
            \}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :> Black
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" Python starts faster:
let g:python3_host_prog = '/usr/local/bin/python3'

" Python Black format on save
""augroup Python
""    autocmd!BufWritePre *.py
""    au BufWritePre *.py exec ':Black'
""augroup END
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :> Lualine
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" Default config according to https://github.com/nvim-lualine/lualine.nvim
let g:cwd = 'cwd: ' . expand('%:~:h')
lua << END

-- Config for lualine
-- Credits: shadmansaleh, glepnir
local lualine = require('lualine')

-- Color table for highlights
-- stylua: ignore
local colors = {
  bg       = '#202328',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  gray     = 'gray',
  red      = '#ec5f67',
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = '',
    section_separators = '',
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } },
    },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
  extensions = {'quickfix'}
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left {
  function()
    return '▊'
  end,
  color = { fg = colors.blue }, -- Sets highlighting of component
  padding = { left = 0, right = 1 }, -- We don't need space before this
}

ins_left {
  -- mode component
  'mode',
  color = function()
    -- auto change color according to neovims mode
    local mode_color = {
      n = colors.gray,
      i = colors.green,
      v = colors.blue,
      [''] = colors.blue,
      V = colors.blue,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [''] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ['r?'] = colors.cyan,
      ['!'] = colors.red,
      t = colors.red,
    }
    return {bg = mode_color[vim.fn.mode()], fg = 'black', gui = 'bold' }
  end,
  padding = { left = 1, right = 1 },
}

ins_left {
  -- filesize component
  'filesize',
  cond = conditions.buffer_not_empty,
}

ins_left {
  'o:encoding', -- option component same as &encoding in viml
  fmt = string.upper, -- I'm not sure why it's upper case either ;)
  cond = conditions.hide_in_width,
  color = { fg = colors.green, gui = 'bold' },
}

ins_left {
  'filetype',
  icons_enabled = true,
  colored = true,   -- Displays filetype icon in color if set to true
  icon_only = false, -- Display only an icon for filetype
  icon = { align = 'right' }, -- Display filetype icon on the right hand side
  -- icon =    {'X', align='right'}
  -- Icon string ^ in table is ignored in filetype component
  cond = conditions.buffer_not_empty,
}

ins_left {
  'filename',
  cond = conditions.buffer_not_empty,
  color = { fg = colors.magenta, gui = 'bold' },
}

ins_left {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = ' ', warn = ' ', info = ' ' },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.cyan },
  },
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left {
  function()
    return '%='
  end,
}

ins_left {
  -- Lsp server name .
  function()
    local msg = 'No Active Lsp'
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  icon = ' LSP:',
  color = { fg = '#ffffff', gui = 'bold' },
}

-- Add components to right sections

-- ins_right {
--   'fileformat',
--   fmt = string.upper,
--   icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
--   color = { fg = colors.green, gui = 'bold' },
-- }

ins_right {
  'g:cwd',
  cond = conditions.buffer_not_empty,
  color = { bg = colors.gray},
}

ins_right {
  'branch',
  icon = '',
  color = { fg = colors.violet, gui = 'bold' },
}

ins_right {
  'diff',
  -- Is it me or the symbol for modified us really weird
  symbols = { added = ' ', modified = '柳 ', removed = ' ' },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
}

local lin = '%L'
lin2 = string.format("[%s]",lin)

ins_right {
    'lin2',
    color = { bg = colors.blue, fg = 'darkblue'},
}

ins_right { 'progress', color = { bg = colors.blue, fg = 'black', gui = 'bold' } }

ins_right { 'location',
color = { bg = colors.blue, fg = 'black'},
}

ins_right {
  function()
    return '▊'
  end,
  color = { fg = colors.blue },
  padding = { left = 1 },
}
-- Now don't forget to initialize lualine
lualine.setup(config)
END
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :> nvim-tree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" Following changes in config acc. https://github.com/kyazdani42/nvim-tree.lua
lua << END
    require("nvim-tree").setup {
      disable_netrw = true,
      hijack_netrw = true,
      open_on_tab = true,
      sort_by = "case_sensitive",
      view = {
        adaptive_size = true,
        mappings = {
          list = {
            { key = "u", action = "dir_up" },
          },
        },
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
     diagnostics = { enable = true },
     view = {
        mappings = {
          list = {
            { key = "<CR>", action = "tabnew" },
            { key = "<C-b>", action = "edit" },
          }
        },
        number = true,
        relativenumber = true,
      },
  system_open = {cmd = 'silent toggle_replace'},
}
     local function toggle_replace()
       local view = require"nvim-tree.view"
       if view.is_visible() then
         view.close()
       else
         require"nvim-tree".open_replacing_current_buffer()
       end
     end
     vim.keymap.set('n', '<C-;>', toggle_replace)
END
" Mappings
noremap <leader>. :NvimTreeToggle<cr>
noremap <leader>/ :NvimTreeFindFile<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
