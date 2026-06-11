return {
  "folke/zen-mode.nvim",
  keys = {
    { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
  },
  opts = {
    window = { backdrop = 1 },
    on_open = function()
      vim.cmd("hi ZenBg guibg=NONE ctermbg=NONE")
      if Snacks and Snacks.picker then
        for _, p in ipairs(Snacks.picker.get({ source = "explorer" })) do
          p:close()
        end
      end
    end,
  },
}
