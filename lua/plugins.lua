vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")
    -- LSP configuration helpers as per https://github.com
    -- /williamboman/mason-lspconfig.nvim#available-lsp-servers
    -- /jay-babu/mason-null-ls.nvim#readme
    -- nulls depends on plenary
    use("rafamadriz/friendly-snippets")
    use("nvim-lua/plenary.nvim")
    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
-- installing linter as per mason recommedation
        "mfussenegger/nvim-lint",
        "mhartington/formatter.nvim",
--        "jay-babu/mason-null-ls.nvim",
--        "jose-elias-alvarez/null-ls.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    }
    -- nvim-cmp and plugins required by it
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-cmdline")
    use("hrsh7th/nvim-cmp")
    -- Treesitter: syntax highlighting
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use("windwp/nvim-ts-autotag")
    use("HiPhish/nvim-ts-rainbow2")
    -- use LSPSaga for improving LSP experience
    use({
        "glepnir/lspsaga.nvim",
        -- opt = true,
        -- branch = "main",
        -- event = "LspAttach",
        requires = {
            { "nvim-tree/nvim-web-devicons" },
            --Please make sure you install markdown and markdown_inline parser
            { "nvim-treesitter/nvim-treesitter" }
        }
    })
    -- Snippetss
    use({ "L3MON4D3/LuaSnip", tag = "v<CurrentMajor>.*" })
    use("saadparwaiz1/cmp_luasnip")
    -- Function signature helper
    use("ray-x/lsp_signature.nvim")
    -- Search
    use("nvim-telescope/telescope.nvim")
    -- Git
    use("tpope/vim-fugitive")
    -- Typing
    use("tpope/vim-surround")
    -- formatting
    require('packer').use { 'mhartington/formatter.nvim' }
    -- use("python/black")
    use("psf/black", {branch = 'stable'})
    -- use("vim-scripts/indentpython.vim")
    -- GUI
    use("akinsho/bufferline.nvim", { tag = "v2.*" })
    use("kyazdani42/nvim-tree.lua")
    use("norcalli/nvim-colorizer.lua")
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons" },
    })
    -- Colorscheme vscode
    use("Mofiqul/vscode.nvim")
    -- Colorscheme
    use("folke/tokyonight.nvim", { branch = "main" })
    -- Refactoring
    use({
        "ThePrimeagen/refactoring.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter" },
    use({"mtdl9/vim-log-highlighting"}),
    use("lewis6991/gitsigns.nvim")
    })
end)
