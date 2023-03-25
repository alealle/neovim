vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")
	use("neovim/nvim-lspconfig")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("windwp/nvim-ts-autotag")
	use("p00f/nvim-ts-rainbow")
	use({
		"glepnir/lspsaga.nvim",
		branch = "main",
		config = function()
			require("lspsaga").setup({})
			-- your configuration
		end,
	})
	-- nvim-cmp and plugins required by it
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/nvim-cmp")
	use({ "L3MON4D3/LuaSnip", tag = "v<CurrentMajor>.*" })
	use("saadparwaiz1/cmp_luasnip")
	use("rafamadriz/friendly-snippets")
	use("jose-elias-alvarez/null-ls.nvim")
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("nvim-lua/plenary.nvim")
	use("nvim-telescope/telescope.nvim")
	use("tpope/vim-fugitive")
	use("tpope/vim-surround")
	use("python/black")
	use("vim-scripts/indentpython.vim")
	use("akinsho/bufferline.nvim", { tag = "v2.*" })
	use("folke/tokyonight.nvim", { branch = "main" })
	use("kyazdani42/nvim-tree.lua")
	use("norcalli/nvim-colorizer.lua")
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
	})
    use( "ray-x/lsp_signature.nvim")
    use({
    "ThePrimeagen/refactoring.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter" },
    -- colorscheme vscode
    use("Mofiqul/vscode.nvim")
    })
end)
