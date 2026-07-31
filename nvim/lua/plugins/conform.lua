return {
  "stevearc/conform.nvim",
  optional = true,
  dependencies = { "lewis6991/gitsigns.nvim" },
  opts = function(_, opts)
    -- Turn off LazyVim's default full-file format-on-save
    vim.g.autoformat = false

    local function format_changed(bufnr)
      local ok, gs = pcall(require, "gitsigns")
      local hunks = ok and gs.get_hunks(bufnr) or nil
      local conform = require("conform")

      -- Untracked / brand-new file → gitsigns has no hunks; format the whole thing
      if hunks == nil then
        conform.format({ bufnr = bufnr, lsp_format = "fallback", timeout_ms = 1000 })
        return
      end

      local ranges = {}
      for _, hunk in ipairs(hunks) do
        if hunk.type ~= "delete" then
          local start = hunk.added.start
          local last = start + hunk.added.count
          local last_line = vim.api.nvim_buf_get_lines(bufnr, last - 2, last - 1, true)[1] or ""
          -- prepend so we format the bottom-most hunk first,
          -- otherwise reformatting shifts line numbers of hunks below it
          table.insert(ranges, 1, {
            start = { start, 0 },
            ["end"] = { last - 1, #last_line },
          })
        end
      end

      for _, range in ipairs(ranges) do
        conform.format({ bufnr = bufnr, range = range, lsp_format = "fallback", timeout_ms = 1000 })
      end
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("format_git_hunks", { clear = true }),
      callback = function(args)
        format_changed(args.buf)
      end,
    })

    -- Escape hatch: format the entire file on demand
    vim.keymap.set({ "n", "v" }, "<leader>cF", function()
      require("conform").format({ lsp_format = "fallback", timeout_ms = 1000 })
    end, { desc = "Format whole file" })

    return opts
  end,
}
