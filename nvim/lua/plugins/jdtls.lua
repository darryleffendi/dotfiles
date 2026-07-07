return {
  "mfussenegger/nvim-jdtls",
  opts = function(_, opts)
    opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
      java = {
        configuration = {
          runtimes = {
            { name = "JavaSE-17", path = vim.fn.expand("~/.sdkman/candidates/java/17.0.11-tem") },
            { name = "JavaSE-21", path = vim.fn.expand("~/.sdkman/candidates/java/21.0.3-tem") },
          },
        },
      },
    })

    -- LazyVim's lang.java extra builds `init_options.bundles` from a local
    -- variable inside its own `config` function and ignores `opts.bundles`.
    -- The only supported way to extend the final jdtls config is `opts.jdtls`,
    -- which the extra applies via extend_or_override(config, opts.jdtls).
    opts.jdtls = function(config)
      local ok, spring_boot = pcall(require, "spring_boot")
      if ok then
        config.init_options = config.init_options or {}
        config.init_options.bundles = config.init_options.bundles or {}
        vim.list_extend(config.init_options.bundles, spring_boot.java_extensions())
      end
    end

    return opts
  end,
}
