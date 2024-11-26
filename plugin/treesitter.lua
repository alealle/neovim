local status, ts = pcall(require, "nvim-treesitter.configs")
if not status then
    return
end

ts.setup({
    sync_install = false,
    auto_install = true,
    ignore_install = {},
    modules = {},
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
        "terraform",
        "rust",
        "go",
    },
    -- enables auto closing html tags: https://github.com/windwp/nvim-ts-autotag
    autotag = {
        enable = true,
        disable = {},
    },
})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
