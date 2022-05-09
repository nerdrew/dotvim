-- nvim --headless -u NONE -c 'lua require("bootstrap.paq").bootstrap()'

local plugin_dir = vim.fn.stdpath("data") .. "/site/pack/paqs/"
local forked_plugin_dir = plugin_dir .. "start/"

local function clone_paq()
  local path = plugin_dir .. "opt/paq-nvim"
  if vim.fn.empty(vim.fn.glob(path)) > 0 then
    vim.fn.system {
      "git",
      "clone",
      "--depth=1",
      "https://github.com/savq/paq-nvim.git",
      path
    }
  end
end

local PKGS = {
  "savq/paq-nvim";
  "chrisbra/Colorizer";
  "vim-scripts/YankRing.vim";
  "skywind3000/asyncrun.vim";
  "jlanzarotta/bufexplorer";
  "chrisbra/csv.vim";
  "skwp/greplace.vim";
  "udalov/kotlin-vim";
  { "iamcco/markdown-preview.nvim", run = "cd app && yarn install"  };
  "mracos/mermaid.vim";
  "neomake/neomake";
  "scrooloose/nerdtree";
  "chr4/nginx.vim";
  "neovim/nvim-lspconfig";
  "keith/rspec.vim";
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
  "tpope/vim-endwise";
  "tpope/vim-eunuch";
  "zchee/vim-flatbuffers";
  "fatih/vim-go";
  "michaeljsmith/vim-indent-object";
  "pangloss/vim-javascript";
  "tpope/vim-markdown";
  "terryma/vim-multiple-cursors";
  "simnalamburt/vim-mundo";
  "mustache/vim-mustache-handlebars";
  { "prettier/vim-prettier", run = "yarn install" };
  "racer-rust/vim-racer";
  "tpope/vim-repeat";
  "airblade/vim-rooter";
  "tpope/vim-surround";
  "wellle/targets.vim";
  "kana/vim-textobj-user";
  "nelstrom/vim-textobj-rubyblock";
  "christoomey/vim-tmux-navigator";
  "cespare/vim-toml";
  "tpope/vim-unimpaired";
  "HerringtonDarkholme/yats.vim";
  { "nvim-treesitter/nvim-treesitter", run=function() vim.cmd('TSUpdate') end };
  "nvim-lua/popup.nvim";
  "nvim-lua/plenary.nvim";
  "nvim-telescope/telescope.nvim";
  "nvim-telescope/telescope-fzy-native.nvim";
  "hrsh7th/nvim-compe";
  "lifepillar/vim-solarized8";
  {
    url = "git@github.com:nerdrew/ale.git",
    upstream = "https://github.com/w0rp/ale.git",
  };
  {
    url = "git@github.com:nerdrew/dart-vim-plugin.git",
    upstream = "https://github.com/dart-lang/dart-vim-plugin.git",
  };
  {
    url = "git@github.com:nerdrew/rust.vim.git",
    upstream = "https://github.com/rust-lang/rust.vim.git",
  };
  {
    url = "git@github.com:nerdrew/vim-fugitive.git",
    upstream = "https://github.com/tpope/vim-fugitive.git",
  };
  {
    url = "git@github.com:nerdrew/vim-rails.git",
    upstream = "https://github.com/tpope/vim-rails.git",
  };
  {
    url = "git@github.com:nerdrew/vim-ruby.git",
    upstream = "https://github.com/vim-ruby/vim-ruby.git",
  };
  {
    url = "git@github.com:nerdrew/vim-sh-indent.git",
    upstream = "https://github.com/chrisbra/vim-sh-indent.git",
  };
  -- 'norcalli/nvim-colorizer.lua';
  -- 'rust-lang/rust.vim';
  -- 'ervandew/supertab';
  -- 'tpope/vim-fugitive';
  -- 'lifepillar/vim-mucomplete';
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

local function update_forked_plugin(upstream)
  local name = string.match(upstream, "/([^/]+).git")
  local dir = forked_plugin_dir .. name

  vim.fn.system({ "git", "-C", dir, "remote", "get-url", "upstream" })
  if vim.v.shell_error ~= 0 then
    system({ "git", "-C", dir, "remote", "add", "upstream", upstream })
    system({ "git", "-C", dir, "fetch", "--unshallow", "origin" })
  end
  system({ "git", "-C", dir, "fetch", "upstream" })
  system({ "git", "-C", dir, "pull", "origin", "master" })
  vim.fn.system({ "git", "-C", dir, "fresh", "upstream/master" })
  if vim.v.shell_error == 0 then
  -- system({ "git", "-C", dir, "push", "-f", "origin" })
  else
    vim.fn.system({ "git", "-C", dir, "rebase", "--abort" })
  end
end


local function update_forked_plugins()
  for _, v in ipairs(PKGS) do
    if type(v) == "table" and v.upstream ~= nil then
      update_forked_plugin(v.upstream)
    end
  end

  vim.cmd("quit")
end

local function bootstrap()
  if vim.fn.isdirectory(forked_plugin_dir) == 0 then
    vim.fn.mkdir(forked_plugin_dir, "p")
  end

  clone_paq()
  -- Load Paq
  vim.cmd('packadd paq-nvim')
  local paq = require('paq')
  -- Exit nvim after installing plugins + updating forks
  vim.cmd('autocmd User PaqDoneSync lua require("bootstrap").updated_forked_plugins()')
  -- vim.api.nvim_create_autocmd({"PaqDoneSync"}, { callback = update_forked_plugins })
  -- Read and install packages
  paq(PKGS)
  paq:sync()
end

return { bootstrap = bootstrap, updated_forked_plugins = update_forked_plugins }
