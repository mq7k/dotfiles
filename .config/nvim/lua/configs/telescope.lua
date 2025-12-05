local M = {}

-- Load NvChad's default Telescope config
local config = require("nvchad.configs.telescope")

-- Function to read .telescopeignore and return ignore patterns
local function load_telescope_ignore()
    local ignore_patterns = {
        "%.git/",  -- Always ignore .git directory
        "build/",  -- Always ignore build folder
        "%.o",     -- Always ignore object files
        "%.a",     -- Always ignore archive files
    }
    local ignore_file = vim.fn.getcwd() .. "/.telescopeignore"

    -- Check if the file exists
    if vim.fn.filereadable(ignore_file) == 1 then
        for line in io.lines(ignore_file) do
            if line ~= "" then
                table.insert(ignore_patterns, line)
            end
        end
    end

    return ignore_patterns
end

-- Ensure `config.defaults` exists
config.defaults = config.defaults or {}

-- Merge ignore patterns with the default configuration
config.defaults.file_ignore_patterns = vim.tbl_deep_extend(
    "force",
    config.defaults.file_ignore_patterns or {},
    load_telescope_ignore()
)

M.setup = function()
    require("telescope").setup(config)
end

return M
