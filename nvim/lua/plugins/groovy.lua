-- Reads `<root>/.groovy-lsp-classpath` (produced by :GroovyClasspath /
-- scripts/gen-groovy-classpath.sh) into a list of jar paths.
local function read_classpath(root)
  if not root then
    return nil
  end
  local fd = io.open(root .. "/.groovy-lsp-classpath", "r")
  if not fd then
    return nil
  end
  local cp = {}
  for line in fd:lines() do
    line = vim.trim(line)
    if line ~= "" then
      cp[#cp + 1] = line
    end
  end
  fd:close()
  return cp
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- groovy-language-server. Mason installs the jar and mason-lspconfig
        -- points `cmd` at it, so an empty table is enough to enable it.
        --
        -- groovyls has NO build-tool integration: it compiles every .groovy
        -- file under the workspace root as one unit, but only resolves imports
        -- for jars listed in `groovy.classpath`. Without that, Spring/library/
        -- sibling-module symbols fail to resolve, compilation errors out, and
        -- go-to-declaration/implementation stop working. So we load the jar
        -- list from `<root>/.groovy-lsp-classpath` and push it to the server.
        groovyls = {
          filetypes = { "groovy" },
          settings = { groovy = {} },
          on_init = function(client)
            local root = client.config.root_dir or vim.fn.getcwd()
            local cp = read_classpath(root)
            if cp and #cp > 0 then
              client.config.settings = vim.tbl_deep_extend("force", client.config.settings or {}, {
                groovy = { classpath = cp },
              })
              -- groovyls only ingests the classpath via didChangeConfiguration.
              client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            else
              vim.schedule(function()
                vim.notify(
                  "groovyls: no .groovy-lsp-classpath in "
                    .. root
                    .. "\nRun :GroovyClasspath to resolve imports and enable go-to-declaration.",
                  vim.log.levels.WARN
                )
              end)
            end
            return true
          end,
        },
      },
    },
  },

  -- :GroovyClasspath — (re)generate the dependency jar list from Gradle and
  -- restart groovyls so it picks up the new classpath.
  {
    "neovim/nvim-lspconfig",
    optional = true,
    init = function()
      vim.api.nvim_create_user_command("GroovyClasspath", function()
        local script = vim.fn.stdpath("config") .. "/scripts/gen-groovy-classpath.sh"
        local root = vim.fs.root(0, { "settings.gradle", "settings.gradle.kts", ".git" }) or vim.fn.getcwd()
        vim.notify("groovyls: generating classpath for " .. root .. " ...", vim.log.levels.INFO)
        vim.system({ "bash", script, root }, { text = true }, function(res)
          vim.schedule(function()
            if res.code == 0 then
              vim.notify("groovyls: classpath ready, restarting server...", vim.log.levels.INFO)
              for _, c in ipairs(vim.lsp.get_clients({ name = "groovyls" })) do
                c:stop()
              end
              vim.defer_fn(function()
                vim.cmd("edit")
              end, 200)
            else
              vim.notify(
                "groovyls: classpath generation failed\n" .. (res.stderr or res.stdout or ""),
                vim.log.levels.ERROR
              )
            end
          end)
        end)
      end, { desc = "Generate/refresh groovyls classpath from Gradle" })
    end,
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
