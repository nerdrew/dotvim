-- nvim --headless -u NONE -c 'lua require("bootstrap.paq").bootstrap()'

local PKGS = {
  { upstream = "https://github.com/savq/paq-nvim.git", opt = true };
  "vim-scripts/YankRing.vim";
  "skywind3000/asyncrun.vim";
  "chrisbra/csv.vim";
  -- "rickhowe/diffchar.vim";
  "skwp/greplace.vim";
  "udalov/kotlin-vim";
  { "iamcco/markdown-preview.nvim", run = "cd app && yarn install"  };
  "mracos/mermaid.vim";
  "scrooloose/nerdtree";
  "chr4/nginx.vim";
  "neovim/nvim-lspconfig";
  -- "keith/rspec.vim";
  "ruby-formatter/rufo-vim";
  "ciaranm/securemodelines";
  "keith/swift.vim";
  "majutsushi/tagbar";
  "junegunn/vader.vim";
  "MarcWeber/vim-addon-local-vimrc";
  "bazelbuild/vim-bazel";
  "google/vim-maktaba";
  "cstrahan/vim-capnp";
  "kchmck/vim-coffee-script";
  "sebdah/vim-delve";
  "justinmk/vim-dirvish";
  "tpope/vim-abolish";
  "tpope/vim-commentary";
  "tpope/vim-eunuch";
  "zchee/vim-flatbuffers";
  "fatih/vim-go";
  "michaeljsmith/vim-indent-object";
  "pangloss/vim-javascript";
  "tpope/vim-markdown";
  "andymass/vim-matchup";
  "terryma/vim-multiple-cursors";
  "simnalamburt/vim-mundo";
  "mustache/vim-mustache-handlebars";
  { "prettier/vim-prettier", run = "yarn install" };
  "tpope/vim-repeat";
  "airblade/vim-rooter";
  "tpope/vim-surround";
  "wellle/targets.vim";
  "kana/vim-textobj-user";
  -- "nelstrom/vim-textobj-rubyblock";
  "christoomey/vim-tmux-navigator";
  "cespare/vim-toml";
  "tpope/vim-unimpaired";
  "HerringtonDarkholme/yats.vim";
  { "nvim-treesitter/nvim-treesitter", run=function() vim.cmd('TSUpdate') end };
  "nvim-treesitter/playground";
  "nvim-treesitter/nvim-treesitter-context";
  "RRethy/nvim-treesitter-endwise";
  "nvim-lua/popup.nvim";
  "nvim-lua/plenary.nvim";
  "nvim-telescope/telescope.nvim";
  "nvim-telescope/telescope-fzy-native.nvim";
  "nvim-telescope/telescope-rg.nvim";
  "hrsh7th/nvim-cmp"; "hrsh7th/cmp-buffer"; "hrsh7th/cmp-nvim-lua"; "hrsh7th/cmp-nvim-lsp"; "hrsh7th/cmp-nvim-lsp-signature-help"; "hrsh7th/cmp-path"; "simrat39/rust-tools.nvim"; "L3MON4D3/LuaSnip"; "saadparwaiz1/cmp_luasnip";
  "j-hui/fidget.nvim";
  "ishan9299/nvim-solarized-lua";
  "folke/noice.nvim"; "MunifTanjim/nui.nvim";
  { upstream = "https://github.com/w0rp/ale.git" };
  { upstream = "https://github.com/dart-lang/dart-vim-plugin.git" };
  { upstream = "https://github.com/rust-lang/rust.vim.git" };
  { upstream = "https://github.com/tpope/vim-fugitive.git" };
  { upstream = "https://github.com/tpope/vim-rails.git" };
  -- { upstream = "https://github.com/vim-ruby/vim-ruby.git" };
  { upstream = "https://github.com/chrisbra/vim-sh-indent.git" };
  'norcalli/nvim-colorizer.lua';
  -- 'rust-lang/rust.vim';
  -- 'tpope/vim-fugitive';
  -- 'tpope/vim-rails';
  -- 'jlcrochet/vim-ruby';
  -- 'iCyMind/NeoSolarized';
  -- 'ayu-theme/ayu-vim';
  -- 'joshdick/onedark.vim';
}

local function system(cmd)
  local output = vim.fn.system(cmd)
  print("running:\n"..table.concat(cmd, " ").."\n"..output)
  if vim.v.shell_error ~= 0 then
    print("code="..vim.v.shell_error.." output="..output)
    error("code="..vim.v.shell_error.." output="..output)
  end
  return output
end

local function clone_paq()
  local path = vim.fn.stdpath("data") .. "/site/pack/paqs/opt/paq-nvim"
  if vim.fn.empty(vim.fn.glob(path)) > 0 then
    system({ "git", "clone", "git@github.com:nerdrew/paq-nvim.git", path })
  end
end

local function bootstrap()
  clone_paq()
  -- Load Paq
  vim.cmd('packadd paq-nvim')
  local paq = require('paq')
  -- Exit nvim after installing plugins
  vim.api.nvim_create_autocmd("User", { pattern = "PaqDoneSync", command = "quit" })
  -- Read and install packages
  paq(PKGS)
  paq:sync()
end

return { bootstrap = bootstrap }
