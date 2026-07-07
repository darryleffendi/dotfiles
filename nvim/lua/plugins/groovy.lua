return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- groovy-language-server. Mason installs the jar and mason-lspconfig
        -- points `cmd` at it, so an empty table is enough to enable it.
        groovyls = {
          filetypes = { "groovy" },
          settings = {
            groovy = {
              -- groovyls has no build-tool integration; it only sees the
              -- classpath entries listed here. Point at your Gradle/Maven
              -- dependency jars so Spring/third-party symbols resolve.
              -- classpath = {},
            },
          },
        },
      },
    },
  },
  -- Ensure the server is installed via Mason.
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "groovy-language-server" })
    end,
  },
  -- Treesitter parser for proper Groovy syntax highlighting.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "groovy" })
    end,
  },
}
