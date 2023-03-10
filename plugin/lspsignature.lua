local cfg = {
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      hint_enable = false,
      hint_prefix = "💡 ",
      handler_opts = {
        border = "rounded"
      },
    }
require "lsp_signature".setup(cfg)
