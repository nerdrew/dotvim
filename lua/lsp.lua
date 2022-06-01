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
local servers = {'solargraph', 'tsserver', 'vimls', 'jsonls', 'sumneko_lua'}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
  }
end

lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        loadOutDirsFromCheck = true,
      },
      checkOnSave = {
        command = 'clippy',
      },
      completion = {
        addCallArgumentSnippets = false,
        addCallParenthesis = false,
      },
      diagnostics = {
        disabled = {'unresolved-import'},
      },
      procMacro = { enable = true },
    },
  }
}

lspconfig.sumneko_lua.setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
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

lspconfig.java_language_server.setup {
  on_attach = on_attach,
  cmd = {"/Users/lazarus/dev/java-language-server/dist/lang_server_mac.sh"},
  -- cmd = {"/Users/lazarus/dev/java-language-server/dist/lang_server_mac.sh", "--verbose"},
  filetypes = {"java"},
  root_dir = lsputil.root_pattern("BUILD", ".git"),
  -- autostart = false,
}
