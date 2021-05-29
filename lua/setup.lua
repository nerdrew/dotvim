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
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- vim.api.nvim_buf_set_var(bufnr, 'mucomplete_chain', {'path', 'omni'})
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


require'compe'.setup {
  enabled = true;
  autocomplete = false;
  debug = false;
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    nvim_lsp = true;
    buffer = true;
  };
}

-- Helpers for Tab / S-Tab completion
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end


require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gss",
      node_incremental = "gsn",
      scope_incremental = "gss",
      node_decremental = "gsd",
    },
  },
  indent = {
    enable = true,
    disable = { 'ruby' },
  },
}

local telescope_actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = telescope_actions.close
      },
    },
  }
}
