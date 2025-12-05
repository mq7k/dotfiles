require("nvchad.configs.lspconfig").defaults()

local servers = { 
    "html", "cssls", "cmake", "ts_ls", "lua_ls", "clangd", "pyright" 
}

vim.lsp.enable(servers)
