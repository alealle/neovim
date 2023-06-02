local status, ts = pcall(require, "nvim-treesitter.configs")
if not status then
    return
end

ts.setup({
    highlight = {
        enable = true,
        disable = {},
    },
    indent = {
        enable = true,
        disable = { "c", "cpp" },
    },
    ensure_installed = {
        "python",
        "bash",
        "c",
        "cpp",
        "java",
        "javascript",
        "sql",
        "tsx",
        "toml",
        "fish",
        "php",
        "json",
        "yaml",
        "swift",
        "css",
        "html",
        "lua",
        "vim",
    },
    -- enables auto closing html tags: https://github.com/windwp/nvim-ts-autotag
    autotag = {
        enable = true,
        disable = {},
    },
    -- default setup for nvim-ts-rainbow2 for parentheses handling
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        -- which query to use to find parentheses
        query = 'rainbow-parens',
        -- Highlight the entire buffer all at once
        strategy = require('ts-rainbow').strategy.global,
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    },
})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
