local lspconfig = require("lspconfig")
local lsputil = require("lspconfig/util")

local on_attach = function(_, _bufnr)
  local method = 'textDocument/publishDiagnostics'

  local default_handler = vim.lsp.handlers[method]
  vim.lsp.handlers[method] = function(err, meth, result, client_id)
    default_handler(err, meth, result, client_id)
    if result and result.diagnostics then
      for _, v in ipairs(result.diagnostics) do
        v.uri = v.uri or result.uri
      end
    end
  end
end

-- local servers = {'gopls', 'tsserver', 'vimls', 'jsonls'}
local servers = {'ts_ls', 'vimls', 'jsonls', 'lua_ls', 'bashls', 'ruby_lsp' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
  }
end

-- lspconfig.rust_analyzer.setup {
--   on_attach = on_attach,
--   settings = {
--     ["rust-analyzer"] = {
--       cargo = {
--         loadOutDirsFromCheck = true,
--       },
--       checkOnSave = {
--         command = 'clippy',
--       },
--       completion = {
--         addCallArgumentSnippets = false,
--         addCallParenthesis = false,
--       },
--       diagnostics = {
--         disabled = {'unresolved-import'},
--       },
--       procMacro = { enable = true },
--     },
--   }
-- }

local version
if vim.fn.getcwd():match("nvim") then
  version = "Lua 5.1"
else
  version = "Lua 5.4"
end
lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        version = version,
      },
      diagnostics = {
        globals = { 'vim', 'hs', 'spoon' },
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
          ['/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/'] = true,
        }
      }
    }
  }
}

-- lspconfig.solargraph.setup {
--   on_attach = on_attach,
--   init_options = { formatting = false },
--   root_dir = lsputil.root_pattern(".git", "."),
-- }

lspconfig.syntax_tree.setup {
  -- cmd = { vim.env.HOME.."/dev/ruby-syntax_tree/exe/stree", "lsp", "--print-width=120", "--plugins=plugin/trailing_comma" }
  cmd = { "stree", "lsp", "--print-width=120", "--plugins=plugin/trailing_comma" },
  root_dir = lsputil.root_pattern(".git", "."),
  on_attach = on_attach,
}

lspconfig.steep.setup {
  root_dir = lsputil.root_pattern("Steepfile"),
  on_attach = on_attach,
}

lspconfig.java_language_server.setup {
  on_attach = on_attach,
  cmd = {"/Users/lazarus/dev/java-language-server/dist/lang_server_mac.sh"},
  -- cmd = {"/Users/lazarus/dev/java-language-server/dist/lang_server_mac.sh", "--verbose"},
  filetypes = {"java"},
  root_dir = lsputil.root_pattern("BUILD", ".git"),
  -- autostart = false,
}

local rt = require("rust-tools")
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp_attach = function(_client, buf)
  local success, err = pcall(vim.keymap.del, "", "<leader>h", { buffer = buf })
  if not success then
    print("Could not delete <leader>h=rt.hover_actions.hover_actions map, err="..vim.inspect(err))
  end
  success, err = pcall(vim.keymap.set, "", "<leader>h", rt.hover_actions.hover_actions, { unique = true, buffer = buf })
  if not success then
    print("Could not set <leader>h=rt.hover_actions.hover_actions map, err="..vim.inspect(err))
  end
  vim.api.nvim_set_option_value("formatexpr", "v:lua.vim.lsp.formatexpr()", { buf = 0 })
  vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = 0 })
  vim.api.nvim_set_option_value("tagfunc", "v:lua.vim.lsp.tagfunc", { buf = 0 })
end

-- Setup rust_analyzer via rust-tools.nvim
rt.setup({
  server = {
    capabilities = capabilities,
    on_attach = lsp_attach,
  }
})

