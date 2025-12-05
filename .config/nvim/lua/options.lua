require "nvchad.options"

-- Show absolute line numbers
vim.o.number = true

-- Show relative line numbers
vim.o.relativenumber = true

-- Show a vertical line at column 80
vim.o.colorcolumn = "80"

-- Highlight line under the cursor
vim.opt.cursorlineopt = "both"

-- Show existing tabs with 4 spaces
vim.o.tabstop = 2

-- Use 4 spaces when indenting with << or >>
vim.o.shiftwidth = 2

-- When pressing tab, insert "shiftwidth" spaces instead
vim.o.expandtab = true

-- Keep indentation when line breaks
vim.o.breakindent = true

-- Minimum number of lines to keep above and below the cursor
vim.o.scrolloff = 15

-- 
vim.opt.clipboard = "unnamed"

-- Enable 24-bit RGB colors in the terminal
vim.o.termguicolors = true
