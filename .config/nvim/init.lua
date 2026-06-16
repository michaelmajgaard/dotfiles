-- Required tools:
--
-- Homebrew:
--   brew install tree-sitter-cli
--   brew install stylua
--
-- .NET:
--   dotnet tool install -g roslyn-language-server --prerelease
--   dotnet tool install -g csharpier
--
-- Ensure ~/.dotnet/tools is on PATH:
--   export PATH="$HOME/.dotnet/tools:$PATH"
--
-- First-time Neovim setup:
--   :lua vim.pack.update()
--   :TSInstall c_sharp
--
-- Useful commands:
--   ;ff  Find files
--   ;f   Format file
--   gd   Go to definition
--   gr   Find references
--   gi   Go to implementation
--   K    Hover documentation
--   ;rn  Rename symbol
--   ;ca  Code action
--   ;e   Show diagnostic
--   [d   Previous diagnostic
--   ]d   Next diagnostic

vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

vim.cmd.colorscheme("habamax")

-- Options
vim.o.number = true
vim.o.wrap = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Plugins
vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/seblyng/roslyn.nvim" },

	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },

	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },

	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

-- Telescope
vim.keymap.set("n", "<leader>ff", function()
	require("telescope.builtin").find_files()
end)

-- Formatting
vim.keymap.set("n", "<leader>f", function()
	local ft = vim.bo.filetype

	if ft == "cs" then
		vim.cmd("silent !csharpier format %")
		vim.cmd("edit")
	elseif ft == "lua" then
		vim.cmd("silent !stylua %")
		vim.cmd("edit")
	else
		vim.lsp.buf.format({ async = true })
	end
end)

-- Completion
local cmp = require("cmp")

cmp.setup({
	mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
	}),

	sources = {
		{ name = "nvim_lsp" },
	},
})

-- Diagnostics
vim.diagnostic.config({
	virtual_text = true,
})

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

-- Workaround for roslyn.nvim calling removed/internal Nvim API
vim.lsp.diagnostic = vim.lsp.diagnostic or {}
vim.lsp.diagnostic._refresh = vim.lsp.diagnostic._refresh or function() end

-- Roslyn
require("roslyn").setup({
	config = {
		cmd = { "roslyn-language-server", "--stdio" },
		capabilities = require("cmp_nvim_lsp").default_capabilities(),

		root_dir = function(bufnr, on_dir)
			local fname = vim.api.nvim_buf_get_name(bufnr)
			local root = vim.fs.root(fname, { "*.sln", "*.csproj", ".git" })

			if root then
				on_dir(root)
			end
		end,
	},
})

-- Treesitter
require("nvim-treesitter").setup()

vim.api.nvim_create_autocmd("FileType", {
	pattern = "cs",
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf }

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	end,
})

-- Transparent background
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
