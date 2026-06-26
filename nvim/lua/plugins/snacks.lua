return {
  "folke/snacks.nvim",
  opts = {
    dashboard = { enabled = false },
    picker = {
      sources = {
        files = { hidden = true, ignored = false },
        grep = { hidden = true, ignored = false },
      },
    },
    zen = {
      toggles = {
        dim = false,
      },
    },
  },
  keys = {
    {
      "<leader>z",
      function()
        for _, p in ipairs(Snacks.picker.get({ source = "explorer" })) do
          p:close()
        end
        Snacks.zen()
      end,
      desc = "Zen Mode",
    },
  },
}
