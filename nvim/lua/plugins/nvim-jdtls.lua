return {
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  config = function()
    local jdtls = require("jdtls")

    local function get_jdtls_cache_dir()
      return vim.fn.stdpath("cache") .. "/jdtls"
    end

    local function get_jdtls_workspace_dir()
      return get_jdtls_cache_dir() .. "/workspace"
    end

    local function get_jdtls_jvm_args()
      local env = os.getenv("JDTLS_JVM_ARGS")
      local args = {}
      for a in string.gmatch((env or ""), "%S+") do
        table.insert(args, a)
      end
      return args
    end

    local function get_workspace_name()
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      return project_name
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        local jdtls_path = vim.fn.expand("~/jdt-language-server-1.55.0-202511271007")
        local workspace_dir = get_jdtls_workspace_dir() .. "/" .. get_workspace_name()

        local root_markers = { "gradlew", "mvnw", ".git", "pom.xml", "build.gradle" }
        local root_dir = require("jdtls.setup").find_root(root_markers)

        local lombok_path = vim.fn.expand("~/.local/share/java/lombok.jar")
        local config = {
          cmd = {
            "java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xmx1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens", "java.base/java.util=ALL-UNNAMED",
            "--add-opens", "java.base/java.lang=ALL-UNNAMED",
            "-javaagent:" .. lombok_path,
          },
          root_dir = root_dir,
          settings = {
            java = {
              signatureHelp = { enabled = true },
              contentProvider = { preferred = "fernflower" },
              completion = {
                favoriteStaticMembers = {
                  "org.junit.jupiter.api.Assertions.*",
                  "org.junit.Assert.*",
                  "org.mockito.Mockito.*",
                },
                filteredTypes = {
                  "com.sun.*",
                  "io.micrometer.shaded.*",
                  "java.awt.*",
                  "jdk.*",
                  "sun.*",
                },
              },
              sources = {
                organizeImports = {
                  starThreshold = 9999,
                  staticStarThreshold = 9999,
                },
              },
              codeGeneration = {
                toString = {
                  template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                },
                useBlocks = true,
              },
              configuration = {
                runtimes = {},
                updateBuildConfiguration = "automatic",
              },
              import = {
                gradle = {
                  enabled = true,
                },
                maven = {
                  enabled = true,
                },
              },
            },
          },
          init_options = {
            bundles = {},
          },
          on_attach = function(client, bufnr)
            jdtls.setup_dap({ hotcodereplace = "auto" })
          end,
        }

        local extendedClientCapabilities = jdtls.extendedClientCapabilities
        extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
        config.init_options.extendedClientCapabilities = extendedClientCapabilities

        local jar = vim.fn.expand(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
        if jar == "" then
          vim.notify("Could not find JDTLS launcher jar", vim.log.levels.ERROR)
          return
        end

        table.insert(config.cmd, "-jar")
        table.insert(config.cmd, jar)
        table.insert(config.cmd, "-configuration")
        table.insert(config.cmd, jdtls_path .. "/config_mac")
        table.insert(config.cmd, "-data")
        table.insert(config.cmd, workspace_dir)

        for _, arg in ipairs(get_jdtls_jvm_args()) do
          table.insert(config.cmd, "--jvm-arg=" .. arg)
        end

        jdtls.start_or_attach(config)
      end,
    })
  end,
}
