local status, colorizer = pcall(require, "colorizer")
if (not status) then return end

--  colorizer.setup({
--      'css';
--      'javascript';
--      'typescript';
--      'html';
--  })

colorizer.setup {
    '*'; css = { rgb_fn = true; }
}
