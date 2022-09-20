"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Author:
"       Alessandro Alle
"
"    => Plugins
"      -> Installation with vim plug
"      -> Configuration and mapping
"    => Settings
"        -> NeoVIM user interface
"        -> Colors and Fonts
"        -> Files and backups
"        -> Text, tab and indent related
"    => Mappings
"       -> All
"           :> Buffers
"           :> Tabs
"           :> Windows
"       -> Insert mode
"       -> Visual mode
"       -> Command line
"       -> Spell checking
"    => Status line
"    => Helper functions
"    => Development tools
"       -> LSP
"    => Compilation with F5
"    => Misc
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" With a map leader it's possible to do extra key combinations
let mapleader = ","

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" -> Installation with vim plug
call plug#begin()
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'tpope/vim-fugitive'
    Plug 'preservim/nerdtree'
    Plug 'tpope/vim-surround'
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-treesitter/nvim-treesitter'
    Plug 'glepnir/lspsaga.nvim'
    Plug 'p00f/nvim-ts-rainbow'
    Plug 'python/black'
    " Cmp: all plugins required
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    " Ultisnip: Track the engine.
    Plug 'SirVer/ultisnips'
    " Ultisnip: Snippets are separated from the engine. Add this if you want them:
    Plug 'honza/vim-snippets'
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'kyazdani42/nvim-tree.lua'
    Plug 'kyazdani42/nvim-web-devicons'
call plug#end()
" User defined plugins
" call plug#begin('~/.config/nvim/my_plugins')
"    Plug './grep-operator'
" call plug#end()
" -> Configuration and mapping

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :> Nerd Tree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden=1
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" :> LSP-config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
"
" -> Language servers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
lua << EOF
local nvim_lsp = require('lspconfig')
local protocol = require('vim.lsp.protocol')
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
    -- vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr(#{timeout_ms:250})')
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
         vim.api.nvim_command[[augroup END]]
         vim.api.nvim_command[[echom "formatted"]]
    else
         vim.api.nvim_command[[echom "client's does not support formatting"]]
    end
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
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
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
                \disable = {'c','cpp','c_sharp', 'h', 'java'}
                \}
            \}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :> Black
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" Python starts faster:
let g:python3_host_prog = '/usr/local/bin/python3'

" Python Black save on format
augroup Python
    autocmd!
    au BufWritePost *.py exec ':Black'
augroup END
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :> Lualine
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" Default config according to https://github.com/nvim-lualine/lualine.nvim
lua << END
require('lualine').setup()
END
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :> nvim-tree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" Following changes in config acc. https://github.com/kyazdani42/nvim-tree.lua
lua << END
    -- disable netrw at the very start of your init.lua (strongly advised)
    vim.g.loaded = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup({
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
    })
END
" Mappings
noremap <leader>. :NvimTreeToggle<cr>
noremap <leader>/ :NvimTreeFindFile<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
"-> NeoVim user interface
" Sets how many lines of history has to remember
set history=500

" Always show current position
set ruler

" Set number
set relativenumber
set nu

" Ignore case when searching
" set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

"Enable incremental command: see live effects of substitutions in a split window
set icm=split

" Don't redraw while executing macros good performance config
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=700

" Command line height
set cmdheight=2

" Add a bit extra margin to the left
set foldcolumn=1

" Set fold options for all files
set foldlevelstart=0
set foldmethod=marker
" To be tried: tree-sitter expr folding
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()

" Add a sign column to facilitate Lint signaling syntax errors etc
set signcolumn=yes

" Alert if editing goes further column 80
set colorcolumn=80

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Set to auto read when a file is changed from the outside
set autoread
augroup ChekTime
    autocmd!
    au FocusGained,BufEnter * checktime
augroup END

" A buffer becomes hidden when it is abandoned
set hidden

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" -> Colors and Fonts
"Syntax theme: use true color and winblend if available
if exists("&termguicolors") && exists("&winblend")
    " Enable syntax highlighting
    syntax enable
    set termguicolors
    set winblend=0
    set wildoptions=pum
    set pumblend=5
endif

" Use gruvbox colors
colorscheme gruvbox
set background=dark

"' Set cursor to bar in insert modee
let &t_SI="\e[6 q"
let &t_EI="\e[2 q"

" Set highlight line when in insert mode
augroup InsertLine
    :autocmd!
    :autocmd InsertEnter * set cul
    :autocmd InsertLeave * set nocul
augroup END

" -> Files, backups and undo

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile

" Turn persistent undo on means that you can undo even when you close a buffer/VIM
try
    set undodir=~/.config/nvim/undo-dir
    set undofile
catch /Cannot open/
    echo "Unable to open undo-dir!!!"
endtry

" Writes buffer when new buffer opened and in other cases
" where some distration may result in data loss - seen
set autowrite

" -> Text, tab and indent related
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
filetype indent on "automatically triggers C indent
set nowrap "nowrap lines

" Let scroll off when close to end of lines to keep view more centered
set scrolloff=8

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" -> All modes
" Remap VIM 0 to first non-blank character
nnoremap 0 ^
" Disable highlight when <leader><cr> is pressed
nnoremap <silent> <leader><cr> :noh<cr>

" :> Buffers
" Close the current buffer
nnoremap <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
nnoremap <leader>ba :bufdo bd<cr>

noremap <leader>bn :bnext<cr>
noremap <leader>bp :bprevious<cr>
noremap <leader>B :buffers<cr>
noremap <leader>bm :buffer<space>

let i = 1
while i <= 9
    execute "nnoremap <leader>bg" . i . " :" . i . "buffer<cr>"
    let i = i + 1
endwhile

" Switch CWD to the directory of the open buffer
nnoremap <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
    set switchbuf=useopen,usetab,newtab
    set stal=2
catch
endtry

" :> Tabs
" Useful mappings for managing tabs
noremap <leader>tn :tabnew<cr>
noremap <leader>to :tabonly<cr>
noremap <leader>tc :tabclose<cr>
noremap <leader>tm :tabmove<cr>
noremap <leader>tn :tabnext<cr>
noremap <leader>tp :tabp<cr>
noremap <S-TAB> gT

let i = 1
while i <= 9
            execute "nnoremap <ESC>" . i  "> " . i . "gt"
    let i = i + 1
endwhile

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nnoremap <Leader>tl :exe "tabn ".g:lasttab<CR>
augroup LastTab
    au!
    au TabLeave * let g:lasttab = tabpagenr()
augroup end

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
nnoremap <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" :> Windows
" Smart way to move between windows
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" Move around windows using numbers
let i =1
while i <= 9
    execute "nnoremap <C-W>" . i . " :" . i . "wincmd w<cr>"
    let i = i + 1
endwhile

" -> Normal mode
" Fast saving
nnoremap <leader>w :w!<cr>
nnoremap <leader>wa :wa!<cr>

"Always perform very magic search
nnoremap / /\v
nnoremap <leader>:s :%s /\v//g<left><left><left>

" Make sure that enter is never overriden in the quickfix window
autocmd! BufReadPost quickfix nnoremap <buffer> <CR> <CR>

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <leader>mj mz:m+<cr>`z
nmap <leader>mk mz:m-2<cr>`z
vmap <leader>mj :m'>+<cr>`<my`>mzgv`yo`z
vmap <leader>mk :m'<-2<cr>`>my`<mzgv`yo`z

" Or, simpler shortcuts:
nnoremap - ddp
nnoremap _ dd2kp

" Insert date
noremap <leader>D :put =strftime('%Y-%m-%d %H:%M:%S%z')

" Edit init.vim
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" Source init.vim
nnoremap <leader>sv :source $MYVIMRC<cr>

nnoremap <leader>;; :silent!<cr>:execute 'set nohlsearch'<cr>
" Open register list and pass specific register
nnoremap "p :reg <bar> exec 'normal! "' . input('>').'p'<cr>

" -> Insert mode
" Closing parenthesis. escape it using ctrl + v before typing the mapped char like ( { etc
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
" Curly: inserts breakln in order to make cindent work properly when defining functions f(...){
inoremap { {}<left>
inoremap {<cr> {<cr>}<esc>O

" Bash like keys for the command line
inoremap <C-A>	<Home>
inoremap <C-E>	<End>

" Foward delete
inoremap <F2>  <C-o>x

" Delete all line
inoremap <C-l> <C-o>dd

" Delete all line until the cursor: use CTRL-u that is the system default
" Replace current line
inoremap <C-e> <esc>ddO

" Windows CRTL-Z
inoremap <F3> <C-o>u

"Re-map jk to go to normal mode
inoremap jk <esc>

" -> Visual mode related

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Move a line of text using ALT+[jk] or Command+[jk] on mac
vmap <leader>mj :m'>+<cr>`<my`>mzgv`yo`z
vmap <leader>mk :m'<-2<cr>`>my`<mzgv`yo`z

" -> Command mode
" $q is super useful when browsing on the command line
" it deletes everything until the last slash
cnoremap $q <C-\>eDeleteTillSlash()<cr>


" Bash like keys for the command line
cnoremap <C-A>	<Home>
cnoremap <C-E>	<End>

"cnoremap <C-P> <Up>
"cnoremap <C-N> <Down>

" Smart mappings on the command line
cnoremap $h e ~/
cnoremap $d e ~/Desktop/
cnoremap $j e ./
cnoremap $c e <C-\>eCurrentFileDir("e")<cr>

" -> Grep and Vimgrep searching and cope displaying

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with Ack, display your results in cope by doing:
"   <leader>cc
"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                               " To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>

nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand('<cWORD>')) . " ."<cr>:copen<cr>
nnoremap <leader>gw :silent execute "grep! -R " . shellescape(expand('<cword>')) . " ."<cr>:copen<cr>

" -> Spell checking
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status line: my initial configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" Always show the status line
" set laststatus=2
"
" " status bar colors
" augroup StatusBarCol
"     au!
"     au InsertEnter * hi statusline guibg=black guifg=#00d700 ctermfg=black ctermbg=green
"     au InsertLeave * hi statusline guibg=black guifg=#8fbfdc ctermfg=black ctermbg=cyan
"     au ModeChanged *:[vV\x16]* hi statusline guibg=black guifg=pink ctermfg=black ctermbg=magenta
"     au ModeChanged [vV\x16]*:* hi statusline guibg=black guifg=#8fbfdc ctermfg=black ctermbg=cyan
" augroup END
"
" hi statusline guibg=black guifg=#8fbfdc ctermfg=black ctermbg=cyan
"
" " Status Line Custom
" let g:currentmode={
"             \ 'n'  : 'Normal',
"             \ 'no' : 'Normal·Operator Pending',
"             \ 'v'  : 'Visual',
"             \ 'V'  : 'V·Line',
"             \ '^V' : 'V·Block',
"             \ 's'  : 'Select',
"             \ 'S'  : 'S·Line',
"             \ '^S' : 'S·Block',
"             \ 'i'  : 'Insert',
"             \ 'R'  : 'Replace',
"             \ 'Rv' : 'V·Replace',
"             \ 'c'  : 'Command',
"             \ 'cv' : 'Vim Ex',
"             \ 'ce' : 'Ex',
"             \ 'r'  : 'Prompt',
"             \ 'rm' : 'More',
"             \ 'r?' : 'Confirm',
"             \ '!'  : 'Shell',
"             \ 't'  : 'Terminal'
"             \}
" "
" " Format the status line
" set statusline=
" set statusline+=%0*\ %{toupper(g:currentmode[mode()])}\  " The current mode
" set statusline+=%1*%{StatuslineGit()}
" set statusline+=%2*\%{HasPaste()}
" set statusline+=%3*\%{expand('%:~:h')}/
" set statusline+=%4*\%t\%m%r%h%w\          " File name, modified, readonly, helpfile, preview
" set statusline+=%5*\ %y
" set statusline+=\%<\ %{&fileencoding?&fileencoding:&encoding}
" set statusline+=\%<\[%{&fileformat}\]
" set statusline+=%= " Switch to the right side
" set statusline+=%6*\ %<CWD>\ \%{expand('%:~:h')}\/
" set statusline+=%7*\ %3p%%\       " % of file
" set statusline+=%3*\ %4l/%L:%2c\      " Current line
" set statusline+=%8*\ %2n\         " Buffer number
"
" hi User1 ctermfg=black ctermbg=green guibg=#444444 guifg=#d78700
" hi User2 ctermfg=yellow ctermbg=black guibg=#ff8700 guifg=#444444
" hi User3 ctermfg=007 ctermbg=239 guibg=#4e4e4e guifg=#adadad
" hi User4 ctermfg=black ctermbg=yellow guifg=#444444 guibg=#af8700
" hi User5 ctermfg=yellow ctermbg=black guibg=#444444 guifg=#ffd700
" hi User6 ctermfg=cyan ctermbg=black guibg=#d7ffff guifg=#444444
" hi User7 ctermfg=007 ctermbg=236 guifg=#303030 guibg=#adadad
" hi User8 ctermfg=007 ctermbg=yellow guibg=#af8700 guifg=#444444
"
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE '
    endif
    return ''
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :silent! %s/\s\+$//g
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

function! GitBranch()
    return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
    let l:branchname = GitBranch()
    return strlen(l:branchname) > 0?'  '.l:branchname.' ':""
endfunction

func! DeleteTillSlash()
    let g:cmd = getcmdline()

    if has("win16") || has("win32")
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if g:cmd == g:cmd_edited
        if has("win16") || has("win32")
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif

    return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
    return a:cmd . " " . expand("%:p:h") . "/"
endfunc

" Don't close window, when deleting a buffer
autocmd! BufDelete call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Development tools
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" -> Create/ update tag files
augroup Tagging
    autocmd! BufWritePost
    au BufWritePost *.c,*.cpp,*.cs,*.h,*.py,*.sh,*.zsh,*.java,*.js,*.sql silent! !ctags -R &
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   => Compilation with F5
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
"
"   Following file contains the commands on how to run the currently open code.
"   The default mapping is set to F5 like most code editors.
"   Change it as you feel comfortable with, keeping in mind that it does not
"   clash with any other keymapping.
"
"   NOTE: Compilers for different systems may differ. For example, in the case
"   of C and C++, we have assumed it to be gcc and g++ respectively, but it may
"   not be the same. It is suggested to check first if the compilers are installed
"   before running the code, or maybe even switch to a different compiler.
"
"   NOTE: Adding support for more programming languages
"
"   Just add another elseif block before the 'endif' statement in the same
"   way it is done in each case. Take care to add tabbed spaces after each
"   elseif block (similar to python). For example:
"
"   elseif &filetype == '<your_file_extension>'
"       exec '!<your_compiler> %'
"
"   NOTE: The '%' sign indicates the name of the currently open file with extension.
"         The time command displays the time taken for execution. Remove the
"         time command if you dont want the system to display the time
"
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <F5> :call CompileRun()<CR>
imap <F5> <Esc>:call CompileRun()<CR>
vmap <F5> <Esc>:call CompileRun()<CR>

map <F8> :call Build()<CR>
imap <F8> <Esc>:call Build()<CR>
vmap <F8> <Esc>:call Build()<CR>

func! CompileRun()
    write
    if &filetype == 'c'
        set makeprg=make\ %<.o
        make
        exec "!time ./%<"
    elseif &filetype == 'cpp'
        set makeprg=make\ %<.o
        make
        exec "!time ./%<"
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!time java %"
    elseif &filetype == 'sh'
        exec "!time bash %"
    elseif &filetype == 'python'
        exec "terminal time python3 %"
        normal! a
    elseif &filetype == 'html'
        exec "!google-chrome % &"
    elseif &filetype == 'go'
        exec "!go build %<"
        exec "!time go run %"
    elseif &filetype == 'matlab'
        exec "!time octave %"
    endif
endfunc

func! Build()
    if !exists("current_compiler")
        if (&filetype == 'c')
            let current_compiler = "gcc"
            set makeprg=make\ %<.o
        elseif (&filetype == 'cpp')
            let current_compiler = "g++"
            set makeprg=make\ %<.o
        elseif &filetype == 'python'
            let current_compiler = "python"
            compiler pyunit
            set makeprg=python3\ %
        elseif &filetype == 'sh'
            let current_complier = "shellcheck"
            set makeprg=shellcheck\ -f\ gcc\ %
            set errorformat=%f:%l:%c:\ %trror:\ %m\ [SC%n],
               \%f:%l:%c:\ %tarning:\ %m\ [SC%n],
               \%f:%l:%c:\ %tote:\ %m\ [SC%n],
               \%-G%.%#
     endif
   endif

   write
   make
   copen

endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" -> Commenting
" For specific file types
"  :autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>
augroup CommentGroup
    autocmd! FileType
    autocmd FileType python nnoremap <buffer> <localleader>c I# <esc>$
    autocmd FileType javascript nnoremap <buffer> <localleader>c I// <esc>$
    autocmd FileType vim nnoremap <buffer> <localleader>c I<C-O>" <esc>
    autocmd FileType c nnoremap <buffer> <localleader>c I//<esc>$
    autocmd FileType html nnoremap <buffer> <localleader>c 0i<!<esc>$a/><esc>$
augroup END
" Command for all groups
augroup file_all
    autocmd!
    " Disable comment sign insertion in a new line after C-r in a comment line
    autocmd FileType * set formatoptions=jcql
augroup END

"-> Trailing spaces
" Delete trailing spaces for certain file types
if has("autocmd")
    autocmd!
    autocmd BufWritePre *.txt,*.js,*.py,*.c,*.cpp,*.cs,*.h,*.md,*.vim : call CleanExtraSpaces()
endif
" ,*.js,*.py,*.wiki,*.sh,*.coffee,*.vim,*.c,*.cpp,
"                \*.cs, *.dat,*.h, *.md

" -> Editing tips
" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Return to last edit position when opening files (You want this!)
augroup LastPosition
    au! BufReadPost
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
