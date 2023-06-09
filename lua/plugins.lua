-- Automatically run :PackerCompile whenever plugins.lua is updated with an autocommand:
vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("PACKER", { clear = true }),
	pattern = "plugins.lua",
	command = "source <afile> | PackerCompile",
})

return require("packer").startup(function(use)
	---------------------
	-- Package Manager --
	---------------------
	use("wbthomason/packer.nvim")

	----------------------
	-- Required plugins --
	----------------------
	use("nvim-lua/plenary.nvim")

	----------------------
	-- Theme plugins --
	----------------------
	use("EdenEast/nightfox.nvim")
	vim.cmd([[colorscheme nightfox]])

	-------------------------
	-- Shade --
	-- dim unactive buffers
	-------------------------
	use({
		"jghauser/shade.nvim",
		config = function()
			require("shade").setup({
				overlay_opacity = 50,
				opacity_step = 1,
				keys = {
					brightness_up = "<C-Up>",
					brightness_down = "<C-Down>",
					toggle = "<Leader>s",
				},
			})
		end,
	})

	---------------------------------
	-- Navigation and Fuzzy Search --
	---------------------------------
	use({
		"nvim-tree/nvim-tree.lua",
		event = "CursorHold",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional
		},
		config = function()
			require("plugins.nvim-tree")
		end,
	})

	use({
		{
			"nvim-telescope/telescope.nvim",
			requires = {
				{ "nvim-telescope/telescope-live-grep-args.nvim" },
			},
			event = "CursorHold",
			config = function()
				require("plugins.telescope_config")
				require("telescope").load_extension("live_grep_args")
			end,
		},
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			after = "telescope.nvim",
			run = "make",
			config = function()
				require("telescope").load_extension("fzf")
			end,
		},
	})
	-- Lua
	use({
		"folke/trouble.nvim",
		requires = "nvim-tree/nvim-web-devicons",
		config = function()
			require("trouble").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})

	use({
		"alvarosevilla95/luatab.nvim",
		requires = "nvim-tree/nvim-web-devicons",
		config = function()
			require("luatab").setup({
				-- remove anoying buffer numbers (2) file_name.ex
				windowCount = function()
					return ""
				end,
			})
		end,
	})

	local function branch_name()
		local branch = vim.fn.system("git branch --show-current | cut -c1-7 | tr -d '\n' ")

		if branch ~= "" then
			return branch
		else
			return ""
		end
	end

	vim.g.git_branch = branch_name()
	--
	-- Add info to status line
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
		config = function()
			require("lualine").setup({
				sections = {
					lualine_a = { "mode" },
					lualine_b = {
						"vim.g.git_branch",
						{ "diagnostics", symbols = { error = "E", warn = "W", info = "I", hint = "H" } },
					},
					lualine_c = { "filename" },
					lualine_x = { "encoding", "filetype" },
					lualine_y = { "progress" },
					lualine_z = {},
				},
			})
		end,
	})

	-----------------------
	-- Utilities plugins --
	-----------------------
	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup({})
		end,
	})

	use("AndrewRadev/switch.vim")

	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})

	use({
		"tpope/vim-surround",
		event = "BufRead",
		requires = {
			{
				"tpope/vim-repeat",
				event = "BufRead",
			},
		},
	})

	use("romainl/vim-qf")
	-----------------------------------
	-- Treesitter: Better Highlights --
	-----------------------------------
	use("pbrisbin/vim-syntax-shakespeare")
	use({
		{
			"nvim-treesitter/nvim-treesitter",
			event = "CursorHold",
			run = ":TSUpdate",
			config = function()
				require("plugins.treesitter")
			end,
		},
		{ "nvim-treesitter/nvim-treesitter-refactor", after = "nvim-treesitter" },
	})

	----------------------
	-- Language plugins --
	----------------------
	use("kchmck/vim-coffee-script")
	use("tpope/vim-rails")
	use("slim-template/vim-slim")

	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
	})
	----------------------
	-- Git plugins --
	----------------------
	--use tpope/vim-fugitive
	use({
		"tpope/vim-fugitive",
		config = function()
			vim.api.nvim_create_user_command("G", "Gtabedit :", {})
		end,
	})

	use("ponyesteves/vim-github-link")
	-----------------------------------
	-- LSP, Completions and Snippets --
	-----------------------------------

	use({
		"neovim/nvim-lspconfig",
		event = "BufRead",
		config = function()
			require("plugins.lsp.servers")
		end,
		requires = {
			{
				-- WARN: Unfortunately we won't be able to lazy load this
				"hrsh7th/cmp-nvim-lsp",
			},
		},
	})

	use({
		"jose-elias-alvarez/null-ls.nvim",
		event = "BufRead",
		config = function()
			require("plugins.lsp.null-ls")
		end,
	})

	use({
		{
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			config = function()
				require("plugins.lsp.nvim-cmp")
			end,
			requires = {
				{
					"L3MON4D3/LuaSnip",
					event = "InsertEnter",
					config = function()
						require("plugins.lsp.luasnip")
					end,
					requires = {
						{
							"rafamadriz/friendly-snippets",
							event = "CursorHold",
						},
					},
				},
			},
		},
		{ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
		{ "hrsh7th/cmp-path", after = "nvim-cmp" },
		{ "hrsh7th/cmp-buffer", after = "nvim-cmp" },
	})
end)
