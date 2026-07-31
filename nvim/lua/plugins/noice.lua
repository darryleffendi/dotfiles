return {
  "folke/noice.nvim",
  opts = function(_, opts)
    opts.routes = opts.routes or {}

    -- Neovim 0.12 emits a transient "Decoration provider" error from the
    -- built-in LSP inlay-hint provider when a buffer changes faster than the
    -- server re-sends hints (e.g. moving lines with alt+j/k, jumping with
    -- ctrl+o). The hint fails to draw for that one redraw and re-renders
    -- correctly on the next refresh, so the error is purely cosmetic.
    -- Drop it here instead of disabling inlay hints entirely.
    table.insert(opts.routes, {
      filter = { find = "ns=nvim.lsp.inlayhint" },
      opts = { skip = true },
    })

    return opts
  end,
}
