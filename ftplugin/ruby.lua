if vim.b.lazarus_ruby then
  return
end

vim.b.lazarus_ruby = true

vim.keymap.set("", "<leader>r", function() RSpec(false, false) end, { unique = true, buffer = true })
vim.keymap.set("", "<leader>R", function() RSpec(true, false) end, { unique = true, buffer = true })
vim.keymap.set("", "<leader>e", function() RSpec(false, true) end, { unique = true, buffer = true })
vim.keymap.set("", "<leader>E", function() RSpec(true, true) end, { unique = true, buffer = true })

if vim.g.lazarus_ruby then
  return
end

vim.g.lazarus_ruby = true

local root = vim.g.ruby_project_root or vim.fn.FindRootDirectory()
local spec_file, spec_line
local rspec_cmd = vim.g.rspec
local rspec_args = vim.g.rspec_args or "-f p"

if rspec_cmd == nil then
  if vim.fn.glob("bin/rspec") == "bin/rspec" then
    rspec_cmd = "bin/rspec"
  else
    vim.fn.system("grep -q spring Gemfile.lock")
    if vim.v.shell_error == 0 then
      rspec_cmd = "spring rspec"
    else
      rspec_cmd = "rspec"
    end
  end
end

function RSpec(line, debug)
  if vim.fn.expand("%"):match("_spec%.rb$") then
    spec_file = vim.fn.fnamemodify(vim.fn.expand("%"), ":p:s?"..root.."/??")
    spec_line = vim.fn.line(".")
  end

  if spec_file == nil then
    print("doesn't look like a spec, skipping")
    return
  end

  local cmd = rspec_cmd.." "..rspec_args.." "..spec_file
  if not debug then
    cmd = "DISABLE_PRY=1 "..cmd
  end

  if line and spec_line then
    cmd = cmd..":"..spec_line
  end

  vim.cmd("update")

  if debug then
    if vim.fn.winnr("$") == 1 then
      vim.cmd("vnew")
    else
      vim.cmd("cclose")
      vim.cmd("lclose")
      vim.cmd("botright new")
    end

    if root then
      cmd = "cd "..root.." && "..cmd
    end
    vim.fn.termopen(cmd)

    print("running:"..cmd)
  else
    local opts = {
      mode = "async",
      errorformat = 'rspec %f:%l %m',
      strip = true,
      cwd = root,
    }
    vim.fn["asyncrun#run"]("", opts, cmd)
    print("running: "..cmd)
  end
end

local function rubocop(args)
  local cmd = "rubocop --format emacs "

  if args.bang then
    cmd = cmd.."--auto-correct "
  end

  local files = {}
  for _, file in ipairs(args.fargs) do
    table.insert(files, vim.fn.fnamemodify(file, ":p:s?"..root.."/??"))
  end

  cmd = cmd..table.concat(files, " ")
  local opts = {
    mode = "async",
    errorformat = '%f:%l:%c: %m',
    strip = true,
    cwd = root,
  }
  vim.cmd("update")
  vim.fn["asyncrun#run"]("", opts, cmd)
  print("running: "..cmd)
end

vim.api.nvim_create_user_command("Rubocop", rubocop, { nargs = "+", bang = true, complete = "file" })


-- local function format(args)
  --   local spaces = vim.fn.indent(args.line1)

  --   local pos
  --   if not args.range or args.range == 0 then
  --     print("no range specified, skipping")
  --     return
  --   elseif args.range == 1 then
  --     pos = args.line1
  --   else
  --     pos = "'<,'>"
  --   end
  --   vim.cmd("keepjumps " .. pos .. "! " .. formatter .. " | sed 's/^/" .. vim.fn["repeat"](' ', spaces) .. "/' | sed 's/^ +$//'")
  -- end

  -- vim.api.nvim_create_user_command("Format", format, { nargs = "?", range = "%", buffer = true })
