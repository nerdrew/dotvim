if vim.b.lazarus_java then
  return
end

vim.b.lazarus_java = true

vim.keymap.set("", "<leader>r", function() BazelTest(true, false, false) end, { unique = true, buffer = true })
vim.keymap.set("", "<leader>R", function() BazelTest(true, true, false) end, { unique = true, buffer = true })
vim.keymap.set("", "<leader>e", function() BazelTest(true, false, true) end, { unique = true, buffer = true })
vim.keymap.set("", "<leader>E", function() BazelTest(true, true, true) end, { unique = true, buffer = true })

if vim.g.lazarus_java then
  return
end

vim.g.lazarus_java = true

local current_file =  {};
local current_test = { test = false }
local junit_output_converter = vim.fn.expand('<sfile>:p:h') .. '/junit_output_converter.rb'

local function get_current(path)
  local relative, package = path:match("^(.*)/src/test/java/(.+)%.java$")

  if relative == nil then
    print("path="..path.." current_file="..vim.inspect(current_file))
    return current_file
  end

  current_file = {
    root = vim.fn.fnamemodify(vim.fn.getcwd(), ':s?'.. vim.g.java_bazel_workspace ..'/??') .. '/',
    relative = relative:gsub("^%./", '', 1),
    test = true,
    file = path,
    package = package,
  }

  print(vim.inspect(current_file))

  return current_file
end

function GetCurrentTest(path)
  if path == nil then
    path = vim.fn.expand("%")
  end

  local file = get_current(path)
  local test_function

  if not file.test then
    if current_test.test then
      return current_test
    end

    local test_file = file.root .. file.relative .. '/src/test/java' .. file.package:gsub("%.", "/") .. "Test.java"

    if vim.fn.filereadable(test_file) then
      file = get_current(test_file)
      test_function = nil
    else
      error("could not find the test")
    end
  else
    test_function = vim.fn["tagbar#currenttag"]("%s", "", ""):gsub("%(%)$", "", 1)
  end

  current_test = file
  current_test.test_function = test_function

  return current_test
end

function RunJavaTest(args)
  local single_test = args.args ~= ""
  local debug = args.bang

  if vim.g.java_bazel then
    BazelTest(true, single_test, debug)
  else
  end
end
vim.api.nvim_create_user_command("RunJavaTest", RunJavaTest, { nargs = "?", complete = "command", bang = true })

function BazelTest(single_file, single_test, debug)
  local test = GetCurrentTest()

  local cmd = "bazel test"

  if single_file then
    cmd = cmd .. " //" .. test.root .. test.relative .. "/src/test/java:" .. test.package:gsub("%.", "/")

    if single_test then
      if test.test_function == nil or test.test_function == "" then
        error("no test_function")
      end

      cmd = cmd .. " --test_filter="..test.test_function
    end
  else
    cmd = cmd .. " ..."
  end

  if debug then
    cmd = cmd .. " --verbose_failures"
  end

  cmd = cmd .. " 2>&1 | ruby " .. junit_output_converter .. " -- " .. test.relative

  local opts = {
    mode = "async",
    errorformat = 'java error %f:%l: %m',
    strip = true,
    cwd = test.root,
    save = 1,
  }
  vim.fn["asyncrun#run"]("", opts, cmd)
  print("running: "..cmd)
end

local Job = require('plenary/job')

-- local function run_job(cmd)
--   local list
--   Job:new({
--     command = cmd[1],
--     args = cmd[2]
--   })
-- end
