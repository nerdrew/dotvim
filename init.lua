require("lsp")
local functions = require("functions")

vim.g.bufExplorerDisableDefaultKeyMapping = 1
vim.g.bufExplorerShowRelativePath = 1
vim.g.omni_sql_no_default_maps = 1
vim.g.rooter_manual_only = 1
vim.g.rooter_patterns = {"Gemfile", "Cargo.toml", ".git", ".git/", "_darcs/", ".hg/", ".bzr/", ".svn/"}
vim.g.rooter_resolve_links = 1
vim.g.rooter_cd_cmd = "lcd"
vim.g.ruby_indent_assignment_style = "variable"
vim.g.ruby_indent_block_style = "do"
vim.g.yankring_clipboard_monitor = 0
vim.g.yankring_history_file = ".cache/nvim/yankring_history"
vim.g.python_host_prog = vim.env.HOMEBREW_PREFIX .. "/bin/python"
vim.g.python3_host_prog = vim.env.HOMEBREW_PREFIX .. "/bin/python3"
vim.g.mundo_prefer_python3 = 1
vim.g.grep_cmd_opts = "--vimgrep --no-column"
vim.g.tagbar_autofocus = 1
vim.g.tagbar_type_dart = { ctagsbin = vim.env.HOME.."/.pub-cache/bin/dart_ctags" }
vim.g.tagbar_type_ruby = {
  ctagsbin = "ripper-tags",
  ctagsargs = {"--tag-file", "-"},
  kinds = { "c:classes", "f:methods", "m:modules", "F:singleton methods", "C:constants", "a:aliases" },
}
vim.g.tagbar_type_rust = {
  ctagstype = "rust",
  kinds = {
    "n:module",
    "s:structural type",
    "i:trait interface",
    "c:implementation",
    "f:Function",
    "g:Enum",
    "t:Type Alias",
    "v:Global variable",
    "M:Macro Definition",
    "m:A struct field",
    "e:An enum variant",
    "P:A method",
  },
}
vim.g.go_highlight_build_constraints = 1
vim.g.go_highlight_extra_types = 1
vim.g.go_highlight_fields = 1
vim.g.go_highlight_functions = 1
vim.g.go_highlight_methods = 1
vim.g.go_highlight_operators = 1
vim.g.go_highlight_structs = 1
vim.g.go_highlight_types = 1

vim.g.ale_linters = { rust = {"cargo"} }
vim.g.ale_linters_ignore = { ruby = {"solargraph"} }
vim.g.ale_fixers = { ruby = {"rubocop"}, javascript = {"eslint", "importjs", "prettier"}, rust = {"rustfmt"} }
vim.g.ale_rust_cargo_avoid_whole_workspace = 0
vim.g.ale_rust_cargo_check_all_targets = 1
vim.g.ale_rust_cargo_check_examples = 1
vim.g.ale_rust_cargo_use_clippy = 1
vim.g.ale_rust_rls_config = { rust = {clippy_preference = "on"}}
vim.g.ale_rust_rls_toolchain = "nightly"

vim.g.rust_use_custom_ctags_defs = 1
vim.g.rust_fold = 1
vim.g.rustfmt_options = "--edition 2018"
vim.g.surround_no_insert_mappings = 1

if vim.fn.has('macunix') ~= 0 then
  vim.g.yankring_replace_n_pkey = "π" -- option-p
  vim.g.yankring_replace_n_nkey = "ø" -- option-o
else
  vim.g.yankring_replace_n_pkey = "<A-p>" -- option-p
  vim.g.yankring_replace_n_nkey = "<A-o>" -- option-o
end

vim.g.multi_cursor_use_default_mapping = 0
vim.g.multi_cursor_start_word_key      = "≥"  -- option->
vim.g.multi_cursor_select_all_word_key = "µ"  -- option-m
vim.g.multi_cursor_start_key           = "g≥" -- g option->
vim.g.multi_cursor_select_all_key      = "gµ" -- g option-m
vim.g.multi_cursor_next_key            = "≥"  -- option->
vim.g.multi_cursor_prev_key            = "≤"  -- option-<
vim.g.multi_cursor_skip_key            = "÷"  -- option-/
vim.g.multi_cursor_quit_key            = "<Esc>"

vim.g.markdown_fenced_languages = {"html", "python", "ruby", "vim", "mermaid"}

vim.opt.termguicolors = true
vim.opt.background = "light"
vim.opt.autoread = true
vim.opt.backspace = "indent,eol,start"
vim.opt.backupdir = { ".", vim.env.TMPDIR }
vim.opt.completeopt = "menuone,noinsert"
vim.opt.copyindent = true
vim.opt.cscopequickfix = "s-,c-,d-,i-,t-,e-"
vim.opt.cst = true
vim.opt.expandtab = true
vim.opt.sw = 2
vim.opt.ts = 2
vim.opt.sts = 2
vim.opt.formatoptions:remove("t")
vim.opt.grepprg = "rg"
vim.opt.hidden = true
vim.opt.history = 1000
vim.opt.inccommand = "nosplit"
vim.opt.lazyredraw = true
vim.opt.listchars = "tab:> ,trail:·,nbsp:·,extends:>,precedes:<"
vim.opt.mouse = "a"
vim.opt.joinspaces = false
vim.opt.list = false
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.numberwidth = 3
vim.opt.ruler = true
vim.opt.scrolloff = 3
vim.opt.shell = "zsh"
vim.opt.shortmess:append("c") -- Shut off completion messages
vim.opt.showcmd = true
vim.opt.showmatch = true -- show matching parentheses
vim.opt.smarttab = true
vim.opt.ssop:remove("folds")
vim.opt.ssop:remove("options")
vim.opt.textwidth = 120
vim.opt.tildeop = true
vim.opt.title = true
vim.opt.undodir = vim.env.HOME.."/.cache/nvim/undo"
vim.opt.undofile = true
vim.opt.wildignore = "*.swp,*.bak,*.pyc,*.class,*.png,*.o,*.jpg"
vim.opt.wildmenu = true -- better tab completion for files
vim.opt.wildmode = "list:longest"

vim.opt.statusline = "%!v:lua.StatusLine()"

local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[0]
if git_root ~= nil and git_root ~= "" then
  vim.opt.tags:append(git_root .. "/.git/tags")
end

vim.cmd("colorscheme solarized8_flat")

vim.g.mapleader = " "

vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { unique = true })
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { unique = true })
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { unique = true })
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { unique = true })
-- insert from register
vim.keymap.set("t", "<C-r>", "'<C-\\><C-N><C-w>l\"'.nr2char(getchar()).'pi'", { unique = true, expr = true })

vim.keymap.set("", "/", "/\\v", { unique = true })
vim.keymap.set("", "?", "/\\v\\c", { unique = true })
vim.keymap.set("", "-", "<C-W>-", { unique = true })
vim.keymap.set("", "+", "<C-W>+", { unique = true })
vim.keymap.set("", "<bar>", "<C-W><", { unique = true })
vim.keymap.set("", "\\", "<C-W>>", { unique = true })
-- option-[
vim.keymap.set("", "“", ":tabp<cr>", { unique = true })
vim.keymap.set("i", "“", "<ESC>:tabp<cr>", { unique = true })
vim.keymap.set("t", "“", "<C-\\><C-N>:tabp<cr>", { unique = true })
vim.keymap.set("", "<A-[>", ":tabp<cr>", { unique = true })
vim.keymap.set("i", "<A-[>", "<ESC>:tabp<cr>", { unique = true })
vim.keymap.set("t", "<A-[>", "<C-\\><C-N>:tabp<cr>", { unique = true })
vim.keymap.set("", "[w", ":tabp<cr>", { unique = true })
-- option-]
vim.keymap.set("", "‘", ":tabn<cr>", { unique = true })
vim.keymap.set("i", "‘", "<ESC>:tabn<cr>", { unique = true })
vim.keymap.set("t", "‘", "<C-\\><C-N>:tabn<cr>", { unique = true })
vim.keymap.set("", "<A-]>", ":tabn<cr>", { unique = true })
vim.keymap.set("i", "<A-]>", "<ESC>:tabn<cr>", { unique = true })
vim.keymap.set("t", "<A-]>", "<C-\\><C-N>:tabn<cr>", { unique = true })
vim.keymap.set("", "]w", ":tabn<cr>", { unique = true })
-- option-shift-[
vim.keymap.set("", "”", ":tabm -1<cr>", { unique = true })
vim.keymap.set("i", "”", "<ESC>:tabm -1<cr>", { unique = true })
vim.keymap.set("t", "”", "<C-\\><C-N>:tabm -1<cr>", { unique = true })
vim.keymap.set("", "<A-{>", ":tabm -1<cr>", { unique = true })
vim.keymap.set("i", "<A-{>", "<ESC>:tabm -1<cr>", { unique = true })
vim.keymap.set("t", "<A-{>", "<C-\\><C-N>:tabm -1<cr>", { unique = true })
-- option-shift-]
vim.keymap.set("", "’", ":tabm +1<cr>", { unique = true })
vim.keymap.set("i", "’", "<ESC>:tabm +1<cr>", { unique = true })
vim.keymap.set("t", "’", "<C-\\><C-N>:tabm +1<cr>", { unique = true })
vim.keymap.set("", "<A-}>", ":tabm +1<cr>", { unique = true })
vim.keymap.set("i", "<A-}>", "<ESC>:tabm +1<cr>", { unique = true })
vim.keymap.set("t", "<A-}>", "<C-\\><C-N>:tabm +1<cr>", { unique = true })

vim.keymap.set("", "Q", "@@", { unique = true })
vim.keymap.set("", "<C-n>", functions.next_error, { unique = true, silent = true })
vim.keymap.set("", "<C-p>", functions.previous_error, { unique = true, silent = true })
vim.keymap.set("", "<leader>q", ":cope<cr>", { unique = true, silent = true })

-- option-y = ¥ yankring show
vim.keymap.set("", "¥", ":YRShow<CR>", { silent = true })
vim.keymap.set("", "<A-y>", ":YRShow<CR>", { silent = true })
-- option-shift-m = Â
vim.keymap.set("", "Â", ":MultipleCursorsFind <C-R>/<CR>", { silent = true })
vim.keymap.set("v", "Â", ":MultipleCursorsFind <C-R>/<CR>", { silent = true })
vim.keymap.set("", "<A-M>", ":MultipleCursorsFind <C-R>/<CR>", { silent = true })
vim.keymap.set("v", "<A-M>", ":MultipleCursorsFind <C-R>/<CR>", { silent = true })

vim.keymap.set("", "<leader>w", ":set wrap! wrap?<cr>", { unique = true })
vim.keymap.set("", "<leader>l", ":set list! list?<cr>", { unique = true })
vim.keymap.set("", "<leader>", ":nohls<cr>", { unique = true })
vim.keymap.set("", "<leader>ew", ":e <C-R>=expand('%:h').'/'<cr>", { unique = true })
vim.keymap.set("", "<leader>es", ":sp <C-R>=expand('%:h').'/'<cr>", { unique = true })
vim.keymap.set("", "<leader>ev", ":vsp <C-R>=expand('%:h').'/'<cr>", { unique = true })
vim.keymap.set("", "<leader>et", ":tabe <C-R>=expand('%:h').'/'<cr>", { unique = true })
vim.keymap.set("", "<leader>y", '"+y', { unique = true })
vim.keymap.set("", "<leader>p", '"+p', { unique = true })
vim.keymap.set("", "<leader>P", '"+P', { unique = true })
vim.keymap.set("", "<leader>o", '"*p', { unique = true })
vim.keymap.set("", "<leader>O", '"*P', { unique = true })
vim.keymap.set("", "gn", "<ESC>/\\v^[<=>|]{7}( .*|$)<cr>", { unique = true })

vim.keymap.set("", "<leader>t", ":TagbarToggle<cr>", { unique = true })
vim.keymap.set("", "<leader>u", ":MundoToggle<cr>", { unique = true })
vim.keymap.set("", "<leader>n", ":NERDTreeToggle<cr>", { unique = true })
vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<cr>", { unique = true })
vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<cr>", { unique = true })
vim.keymap.set("n", "<leader>g", "<cmd>Rg<cr>", { unique = true })
vim.keymap.set("n", "<leader>G", "<cmd>Rg!<cr>", { unique = true })
-- vim.keymap.set("n", "<leader>J", functions.telescope_live_grep, { unique = true })
vim.keymap.set("n", "<leader>J", "<cmd>RgLive<cr>", { unique = true })
-- vim.keymap.set("n", "<leader>K", "<cmd>RgLive!<cr>", { unique = true })
vim.keymap.set("n", "<leader>d", "<cmd>Telescope diagnostics<cr>", { unique = true })
vim.keymap.set("n", "<leader>?", "<cmd>Telescope help_tags<cr>", { unique = true })
vim.keymap.set("", "<leader>x", ":let @+ = expand('%')<cr>", { unique = true })
vim.keymap.set("", "<leader>X", ":let @+ = expand('%').':'.line('.')<cr>", { unique = true })

vim.keymap.set("", "gD", vim.lsp.buf.declaration, { unique = true })
vim.keymap.set("", "gd", vim.lsp.buf.definition, { unique = true })
vim.keymap.set("", "K",  vim.lsp.buf.hover, { unique = true })
vim.keymap.set("", "gi", vim.lsp.buf.implementation, { unique = true })
vim.keymap.set("", "gA", vim.lsp.buf.code_action, { unique = true })
vim.keymap.set("", "gk", vim.lsp.buf.signature_help, { unique = true })
vim.keymap.set("", "gt", vim.lsp.buf.type_definition, { unique = true })
vim.keymap.set("", "gR", vim.lsp.buf.rename, { unique = true })
vim.keymap.set("", "gr", vim.lsp.buf.references, { unique = true })
vim.keymap.set("", "gh", vim.diagnostic.open_float, { unique = true })
vim.keymap.set("", "]d", vim.diagnostic.goto_next, { unique = true })
vim.keymap.set("", "[d", vim.diagnostic.goto_prev, { unique = true })

vim.keymap.set("", "<leader>W", functions.toggle_diff_ignore_whitespace, { unique = true })
vim.cmd("cnoreabbrev <expr> GT ((getcmdtype() is# ':' && getcmdline() is# 'GT')?('Gtabedit :'):('GT'))")

vim.keymap.set("i", "<Tab>", "v:lua.TabComplete()", { silent = true, expr = true })
vim.keymap.set("i", "<S-Tab>", "v:lua.STabComplete()", { silent = true, expr = true })
vim.keymap.set("i", "<CR>", "compe#confirm('<CR>')", { silent = true, expr = true })
vim.keymap.set("", "<leader>!", ":RunCommand<cr>", { unique = true })


vim.api.nvim_create_user_command("Rg", functions.rg, { nargs = "*", complete = "file", range = true, bang = true })
vim.api.nvim_create_user_command("RgLive", functions.telescope_live_grep, { range = true })
vim.api.nvim_create_user_command("RgFilesContaining", functions.rg_files_containing, { nargs = "*", complete = "file" })
vim.api.nvim_create_user_command("RgFiles", functions.rg_files, { nargs = "*", complete = "file" })
vim.api.nvim_create_user_command("XMLLint", functions.xml_lint, { range = "%" })
vim.api.nvim_create_user_command("JSONLint", functions.json_lint, { range = "%" })
vim.api.nvim_create_user_command("Tabs", functions.tabs, { nargs = 1 })
vim.api.nvim_create_user_command("LargeFile", functions.large_file, {})
vim.api.nvim_create_user_command("LargeFileOff", functions.large_file_off, {})
vim.api.nvim_create_user_command("RunCommand", functions.run_command, { range = true })
vim.api.nvim_create_user_command("ToggleErrorLoclist", functions.toggle_error_loclist, {})
vim.api.nvim_create_user_command("CI", function() vim.cmd("!"..vim.env.CI_COMMAND) end, {})
vim.api.nvim_create_user_command("StripTrailingWhitespace", functions.strip_trailing_whitespace, { range = true })


vim.api.nvim_create_autocmd("User", { pattern = "AsyncRunStop", command = "cope" })
vim.api.nvim_create_autocmd("FileType", { pattern = "dirvish", command = "call fugitive#detect(@%)" })
vim.api.nvim_create_autocmd("FileType", { pattern = "python", command = "expandtab sw=4 ts=4 sts=4" })
vim.api.nvim_create_autocmd("BufRead", { callback = functions.last_position_jump, once = true, buffer = 0 })
vim.api.nvim_create_autocmd("TermOpen", { command = "startinsert" })
vim.api.nvim_create_autocmd("TermClose", { command = "if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif" })


vim.api.nvim_exec([[
" See yankring-custom-maps
function! YRRunAfterMaps()
  noremap Y :<C-U>YRYankCount 'y$'<cr>
endfunction

function! s:TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  tabnew
  silent put=message
  set nomodified
endfunction
command! -nargs=+ -complete=command TabMessage call s:TabMessage(<q-args>)
]], false)


require("compe").setup {
  enabled = true;
  autocomplete = false;
  debug = true;
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

-- require'nvim-treesitter.configs'.setup {
--   ensure_installed = "all", -- { "rust", "ruby", "bash", "lua", "vim" },
--   highlight = {
--     enable = true,              -- false will disable the whole extension
--   },
--   incremental_selection = {
--     enable = true,
--     keymaps = {
--       init_selection = "gss",
--       node_incremental = "gsn",
--       scope_incremental = "gss",
--       node_decremental = "gsd",
--     },
--   },
  -- indent = {
  --   enable = true,
  --   -- disable = { 'ruby' },
  -- },
-- }

local telescope = require("telescope")
telescope.setup{
  defaults = {
    mappings = {
      n = {
        ["<C-c>"] = require("telescope.actions").close,
      },
      i = {
        ["<C-f>"] = functions.telescope_send_and_open_qflist,
      }
    },
  },
  pickers = {
    buffers = {
      sort_mru = true,
      previewer = false,
      mappings = {
        n = {
          ["x"] = functions.telescope_delete_buffer,
          ["X"] = functions.telescope_force_delete_buffer,
        },
      },
    }
  },
}
telescope.load_extension("fzy_native")
telescope.load_extension("live_grep_args")
