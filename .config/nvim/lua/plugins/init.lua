return {
    -- {
    --     "stevearc/conform.nvim",
    --     -- event = 'BufWritePre', -- uncomment for format on save
    --     opts = require "configs.conform",
    -- },
    {
          "stevearc/conform.nvim",
          -- event = { "BufReadPre", "BufNewFile" },         -- load when you open/edit files
          cmd = { "ConformInfo" },                        -- also load when you run :ConformInfo
          config = function()
            require("conform").setup(require("configs.conform"))
          end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "configs.lspconfig"
        end,
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            dashboard = { enabled = true },
            explorer = { enabled = true },
            indent = { enabled = true },
            input = { enabled = true },
            picker = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
        }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "vim", "lua", "vimdoc",
                "html", "css", "cpp", "c", "cmake",
            },
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = function()
            -- Load NvChad's default Telescope config
            local config = require("nvchad.configs.telescope")

            config.defaults.file_ignore_patterns = {
                "node_modules",
                "build",
                "%.vscode",
                "%.git",
                "%.cache",
                "%.idea",
            }

            return config
        end,
    },
}
