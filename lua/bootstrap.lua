-- nvim --headless -u NONE -c 'lua require("bootstrap.paq").bootstrap()'

local PKGS = {
  { upstream = "https://github.com/savq/paq-nvim.git", opt = true };

  -- "rickhowe/diffchar.vim";
  -- "tpope/vim-commentary";
  -- "keith/rspec.vim";
  -- "mracos/mermaid.vim";
  -- "nelstrom/vim-textobj-rubyblock";
  -- "nvim-treesitter/playground";
  -- "folke/noice.nvim"; "MunifTanjim/nui.nvim";

  "skywind3000/asyncrun.vim";
  "chrisbra/csv.vim";
  "skwp/greplace.vim";
  "udalov/kotlin-vim";
  { "iamcco/markdown-preview.nvim", build = "cd app && yarn install"  };
  "scrooloose/nerdtree";
  "chr4/nginx.vim";
  "neovim/nvim-lspconfig";
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
  "NeogitOrg/neogit"; "sindrets/diffview.nvim";
  { "prettier/vim-prettier", build = "yarn install" };
  "tpope/vim-repeat";
  "airblade/vim-rooter";
  "tpope/vim-surround";
  "wellle/targets.vim";
  "kana/vim-textobj-user";
  "christoomey/vim-tmux-navigator";
  "cespare/vim-toml";
  "tpope/vim-unimpaired";
  "HerringtonDarkholme/yats.vim";
  "pedrohdz/vim-yaml-folds";
  { "nvim-treesitter/nvim-treesitter", build=function() vim.cmd('TSUpdate') end };
  "nvim-treesitter/nvim-treesitter-context";
  "RRethy/nvim-treesitter-endwise";
  "nvim-lua/popup.nvim";
  "nvim-lua/plenary.nvim";
  "nvim-telescope/telescope.nvim";
  "nvim-telescope/telescope-fzy-native.nvim";
  -- "nvim-telescope/telescope-rg.nvim";
  "nvim-telescope/telescope-live-grep-args.nvim";
  "hrsh7th/nvim-cmp"; "hrsh7th/cmp-buffer"; "hrsh7th/cmp-nvim-lua"; "hrsh7th/cmp-nvim-lsp"; "hrsh7th/cmp-nvim-lsp-signature-help"; "hrsh7th/cmp-path"; "simrat39/rust-tools.nvim"; "L3MON4D3/LuaSnip"; "saadparwaiz1/cmp_luasnip"; "hrsh7th/cmp-cmdline";
  -- "hrsh7th/cmp-nvim-lua"; "hrsh7th/cmp-nvim-lsp-signature-help"; "simrat39/rust-tools.nvim";
  "rcarriga/nvim-notify";
  { "j-hui/fidget.nvim", branch = "legacy" };
  "gbprod/yanky.nvim";
  'norcalli/nvim-colorizer.lua';
  -- { upstream = "https://github.com/w0rp/ale.git" };
  { upstream = "https://github.com/dart-lang/dart-vim-plugin.git" };
  -- { upstream = "https://github.com/rust-lang/rust.vim.git" };
  { upstream = "https://github.com/tpope/vim-fugitive.git" };
  { upstream = "https://github.com/tpope/vim-rails.git" };
  -- { upstream = "https://github.com/vim-ruby/vim-ruby.git" };
  { upstream = "https://github.com/chrisbra/vim-sh-indent.git" };
  { upstream = "https://github.com/ishan9299/nvim-solarized-lua.git" };
  -- "shaunsingh/solarized.nvim";
  "sainnhe/sonokai";
  "sainnhe/everforest";
  "sainnhe/edge";
  "ellisonleao/gruvbox.nvim";
  "savq/melange-nvim";
  "marko-cerovac/material.nvim";
  "RRethy/nvim-base16";

  -- { "rest-nvim/rest.nvim", ref = "91badd46c60df6bd9800c809056af2d80d33da4c" };
  -- "vhyrro/luarocks.nvim"; "squareup/sq-connect-repl.nvim";

  -- 'rust-lang/rust.vim';
  -- 'tpope/vim-fugitive';
  -- 'tpope/vim-rails';
  -- 'jlcrochet/vim-ruby';
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
