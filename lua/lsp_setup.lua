local lspconfig = require('lspconfig')

local on_attach_no_omnifunc = function(_, bufnr)
  local method = 'textDocument/publishDiagnostics'

  local default_handler = vim.lsp.handlers[method]
  vim.lsp.handlers[method] = function(err, method, result, client_id)
    default_handler(err, method, result, client_id)
    if result and result.diagnostics then
      for _, v in ipairs(result.diagnostics) do
        v.uri = v.uri or result.uri
      end
      -- vim.lsp.util.set_loclist(vim.lsp.util.locations_to_items(result.diagnostics))
    end
  end
end

local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.api.nvim_buf_set_var(bufnr, 'mucomplete_chain', {'path', 'omni'})
  local method = 'textDocument/publishDiagnostics'

  local default_handler = vim.lsp.handlers[method]
  vim.lsp.handlers[method] = function(err, method, result, client_id)
    default_handler(err, method, result, client_id)
    if result and result.diagnostics then
      for _, v in ipairs(result.diagnostics) do
        v.uri = v.uri or result.uri
      end
      -- vim.lsp.util.set_loclist(vim.lsp.util.locations_to_items(result.diagnostics))
    end
  end

  -- Mappings.
  -- local opts = { noremap=true, silent=true, unique=true}
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>h', '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', opts)
end

-- local servers = {'gopls', 'tsserver', 'vimls', 'jsonls'}
local servers = {'tsserver', 'vimls', 'jsonls'}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
  }
end

lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = 'clippy',
      },
      diagnostics = {
        disabled = {'unresolved-import'},
      },
      completion = {
        addCallArgumentSnippets = false,
        addCallParenthesis = false,
      },
    },
  }
}

lspconfig.solargraph.setup {
  on_attach = on_attach_no_omnifunc,
}

local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.java_lsp = {
  default_config = {
    cmd = {"/Users/lazarus/dev/java-language-server/dist/lang_server_mac.sh", "--verbose"};
    filetypes = {"java"};
    root_dir = util.root_pattern("BUILD", ".git");
  };
};

lspconfig.java_lsp.setup{
  on_attach = on_attach,
}
