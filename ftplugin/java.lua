if vim.b.lazarus_java then
  return
end

local BazelParser = {}
BazelParser.__index = BazelParser
local BazelLastCompileError = {}
BazelLastCompileError.__index = BazelLastCompileError
local BazelLastTestFailure = {}
BazelLastTestFailure.__index = BazelLastTestFailure

vim.b.lazarus_java = true

vim.keymap.set("", "<leader>r", function() BazelTest(true, false, false) end, { unique = true, buffer = true })
vim.keymap.set("", "<leader>R", function() BazelTest(true, true, false) end, { unique = true, buffer = true })
vim.keymap.set("", "<leader>e", function() BazelTest(true, false, true) end, { unique = true, buffer = true })
vim.keymap.set("", "<leader>E", function() BazelTest(true, true, true) end, { unique = true, buffer = true })
vim.keymap.set("", "gb", function() BreakpointToggle() end, { unique = true, buffer = true })
vim.keymap.set("", "gB", function() BreakpointClear() end, { unique = true, buffer = true })

if vim.g.lazarus_java then
  return
end

local functions = require("functions")

vim.g.lazarus_java = true

local M = {}
local current_file =  {};
local current_test = { test = false }

function M.get_current_file(path)
  if path == nil then
    path = vim.fn.expand("%")
  end

  local relative, package = path:match("^(.*)/src/test/java/(.+)%.java$")

  if relative == nil then
    return current_file
  end

  current_file = {
    root = vim.fn.fnamemodify(vim.fn.getcwd(), ':s?'.. vim.g.java_bazel_workspace ..'/??') .. '/',
    relative = relative:gsub("^%./", '', 1),
    test = true,
    path = path,
    package = package:gsub("/", "."),
  }

  -- print(vim.inspect(current_file))

  return current_file
end

function M.get_current_test(path)
  local file = M.get_current_file(path)
  local test_function

  if not file.test then
    if current_test.test then
      return current_test
    end

    local test_file = file.root .. file.relative .. '/src/test/java' .. file.package:gsub("%.", "/") .. "Test.java"

    if vim.fn.filereadable(test_file) then
      file = M.get_current_file(test_file)
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
    error("only bazel tests supported right now")
  end
end
vim.api.nvim_create_user_command("RunJavaTest", RunJavaTest, { nargs = "?", complete = "command", bang = true })

function BazelTest(single_file, single_test, debug)
  local test = M.get_current_test()
  local args = { "test" }

  if single_file then
    table.insert(args, "//" .. test.root .. test.relative .. "/src/test/java:" .. test.package:gsub("%.", "/"))

    if single_test then
      if test.test_function == nil or test.test_function == "" then
        error("no test_function")
      end

      table.insert(args, "--test_filter="..test.test_function)
    end
  else
    table.insert(args, "...")
  end

  if debug then
    table.insert(args, "--verbose_failures")
    table.insert(args, "--java_debug")
  else
    table.insert(args, "--test_output=all")
  end

  local cmd = "bazel " .. table.concat(args, " ")

  vim.cmd("update")

  local parser = BazelParser:new(test.relative, test.root, cmd)
  local waiting_for_debugger = true

  functions.job_start({
    command = "bazel",
    args = args,
    on_stdout = function(_, data)
      -- print("out="..data)
      parser:add(data)

      if waiting_for_debugger and data:match("Listening for transport dt_socket at address: 5005") then
        waiting_for_debugger = false
        vim.schedule(M.debug_test)
      end
    end,
    on_stderr = function(_, data)
      -- print("err="..data)
      parser:add(data)
    end,
    on_exit = function(_, code, _)
      parser:validate()

      if code == 0 then
        vim.schedule(function()
          print("Test passed: "..cmd)
          vim.cmd('cclose')
        end)
        return
      end

      vim.schedule(function()
        vim.fn.setqflist({}, ' ', parser:qflist())
        vim.cmd('copen')
      end)
    end,
  })
  print("running: "..cmd)
end

-- Debugger
local breakpoints = {}
vim.fn.sign_define("breakpoint", { text = "●", texthl= "WarningMsg" })
vim.api.nvim_create_autocmd("VimLeave", { callback = function() M.delete_debug_files() end })

function M.delete_debug_files()
  vim.fn.delete("pjdb.breakpoint")
  vim.fn.delete("pjdb.sourcepath")
end

function M.debug_test()
  M.delete_debug_files()
  M.reset_breakpoints()

  local breakpoint_file = {}
  for _, b in ipairs(breakpoints) do
    table.insert(breakpoint_file, b.breakpoint)
  end

  vim.fn.writefile(breakpoint_file, "pjdb.breakpoint")
  local sourcepath = {}
  for _, dir in ipairs(vim.fn.glob("**/src/{main,test}/java", false, true)) do
    table.insert(sourcepath, dir)
  end
  vim.fn.writefile(sourcepath, "pjdb.sourcepath")

  if vim.fn.winnr("$") == 2 then
    vim.cmd("topleft vnew")
  else
    vim.cmd("cclose")
    vim.cmd("lclose")
    vim.cmd("botright new")
  end

  local cmd = "pjdb -attach localhost:5005 -launch"
  print("running: "..cmd.." breakpoints: "..vim.inspect(breakpoints))
  vim.fn.termopen(cmd)
end

function M.reset_breakpoints()
  vim.fn.sign_unplace("breakpoints")

  local signs = {}
  local good_breakpoints = {}
  for _, b in ipairs(breakpoints) do
    local bufnr = vim.fn.bufnr(b.path)
    if bufnr then
      table.insert(good_breakpoints, b)
      table.insert(
        signs,
        {
          buffer = b.path,
          group = "breakpoints",
          name = "breakpoint",
          lnum = b.line,
        }
      )
    end
  end

  breakpoints = good_breakpoints
  -- print("breakpoints="..vim.inspect(breakpoints))
  vim.fn.sign_placelist(signs)
end

function BreakpointToggle()
  local file = M.get_current_file()
  local line = vim.fn.line(".")
  local breakpoint = file.package..":"..line

  -- local i, _ = vim.iter(ipairs(breakpoints)):find(function(_, b) return b == breakpoint end )
  local existing_breakpoint
  for i, b in ipairs(breakpoints) do
    if b.package == file.package and b.line == line then
      existing_breakpoint = i
    end
  end

  if existing_breakpoint then
    table.remove(breakpoints, existing_breakpoint)
  else
    table.insert(
      breakpoints,
      {
        breakpoint = breakpoint,
        package = file.package,
        path = file.path,
        line = line,
      }
    )
  end

  M.reset_breakpoints()
end
vim.api.nvim_create_user_command("BreakpointToggle", BreakpointToggle, {})

function BreakpointClear()
  breakpoints = {}
  M.reset_breakpoints()
end
vim.api.nvim_create_user_command("BreakpointClear", BreakpointClear, {})

-- function MvnTest(single_file, debug)
--   local test = M.get_current_test()
--   local args = { "test" }

--   if single_file then
--     table.insert(args, "-Dtest="..test.file)
--   end

--   local cmd = "bazel " .. table.concat(args, " ")

--   vim.cmd("update")

--   local parser = MvnParser:new(test.relative, test.root, cmd)
--   Job:new({
--     command = "mvn",
--     args = args,
--     on_stdout = function(_, data)
--       parser:add(data)
--     end,
--     on_stderr = function(_, data)
--       parser:add(data)
--     end,
--     on_exit = function(_, code, _)
--       parser:validate()

--       if code == 0 then
--         vim.schedule(function()
--           print("Test passed: "..cmd)
--           vim.cmd('cclose')
--         end)
--         return
--       end

--       vim.schedule(function()
--         vim.fn.setqflist({}, ' ', parser:qflist())
--         vim.cmd('copen')
--       end)
--     end,
--   }):start()
--   print("NOT ACTUALLY running: "..cmd)
-- end

function BazelParser:new(relative_root, root, title)
  local o = {
    relative_root = relative_root,
    root = root,
    last_compile_error = nil,
    last_test_failure = nil,
    list = {},
    title = title,
    found_error = false,
  }

  return setmetatable(o, self)
end

function BazelParser:add(line)
  table.insert(self.list, { text = line })

  if self.last_compile_error then
    if self.last_compile_error:add(line) then
      table.insert(self.list, self.last_compile_error:qflist())
      self.last_compile_error = nil
    end
    return
  end

  if self.last_test_failure then
    if self.last_test_failure:add(line) then
      table.insert(self.list, self.last_test_failure:qflist())
      self.last_test_failure = nil
    end
    return
  end

  local path, lnum, message = line:match("^([^%s]+):(%d+): error: (.+)")

  if path then
    path = path:gsub("^"..self.root, "", 1)
    self.last_compile_error = BazelLastCompileError:new(path, lnum, message)
    self.found_error = true
    return
  end

  local meth, package = line:match("%d+%) (%w+)%((.+)%)")

  if meth then
    self.last_test_failure = BazelLastTestFailure:new(self.relative_root, package, meth)
    self.found_error = true
    return
  end
end

function BazelParser:qflist()
  return {
    items = self.list,
    title = self.title,
  }
end

function BazelParser:validate(code)
  if code == 0 then
    if self.found_error then
      print("WARNING: Test runner returned 0, but the parser found errors")
    end
    return
  end

  if not self.found_error then
    print("WARNING: Test runner returned 0, but the parser found errors")
  end

  if self.last_compile_error then
    print("WARNING: Test runner parser encountered unexpected output, last_compile_error="..vim.inspect(self.last_compile_error))
  end

  if self.last_test_failure then
    print("WARNING: Test runner parser encountered unexpected output, last_test_failure="..vim.inspect(self.last_test_failure))
  end
end

function BazelLastCompileError:new(filename, lnum, message)
  local o = {
    filename = filename,
    lnum = lnum,
    message = message,
    col = nil,
  }

  return setmetatable(o, self)
end

function BazelLastCompileError:add(out)
  local spaces = out:match("^(%s+)^")
  if spaces then
    self.col = #spaces + 1
    return true
  end

  if not self.col then
    self.message = self.message .. ": `" .. vim.trim(out).."'"
  end
end

function BazelLastCompileError:qflist()
  return {
    filename = self.filename,
    lnum = self.lnum,
    text = self.message,
    col = self.col,
  }
end

function BazelLastTestFailure:new(root, package, meth)
  local file_name = package:match("%.(%w+)$")
  local o = {
    root = root,
    package = package,
    meth = meth,
    file_regex = file_name .. "%.java:(%d+)",
    message = nil,
    lnum = nil
  }

  return setmetatable(o, self)
end

function BazelLastTestFailure:add(out)
  if not self.message then
    self.message = vim.trim(out)
    return false
  end

  local lnum = out:match(self.file_regex)
  if lnum then
    self.lnum = lnum
    return true
  end

  return false
end

function BazelLastTestFailure:qflist()
  return {
    filename = self.root.."/src/test/java/"..self.package:gsub("%.", "/")..".java",
    lnum = self.lnum,
    text = self.meth..": "..self.message,
  }
end

local google_java_formatter = vim.fn.expand('<sfile>:p:h')..'/google-java-format-1.17.0-all-deps.jar'

function Format(args)
  local target = "%"
  local lines_arg = " "
  local line1, line2

  if args.range == 1 then
    line1 = args.line1 or 1
    line2 = args.line2 or vim.fn.line("$")
  elseif args.range == 2 then
    line1 = vim.fn.line("'<")
    line2 = vim.fn.line("'>")
  end

  if line1 then
    target = line1..","..line2
    lines_arg = " --lines="..line1..":"..line2
  end

  local path = vim.fn.expand("%")

  local cmd = "java -jar "..google_java_formatter.." --assume-filename="..path..lines_arg.." -"

  functions.keep_jumps(target.."!"..cmd)
end
vim.api.nvim_create_user_command("Format", Format, { range = true })


return nil
-- Diagnostics based breakpoints, you can't have custom signs :(
-- local breakpoints = {}
-- local breakpoints_ns = vim.api.nvim_create_namespace("breakpoints")
-- 
-- function M.debug_test()
--   M.delete_debug_files()
-- 
--   local file = M.get_current_file()
-- 
--   vim.fn.writefile(breakpoints, "pjdb.breakpoint")
--   vim.fn.writefile({ file.root.."/src/main/java", file.root.."/src/test/java" }, "pjdb.sourcepath")
-- end
-- 
-- function ToggleBreakpoint()
--   local file = M.get_current_file()
--   local line = vim.fn.line(".")
--   local breakpoint = file.package..":"..line
-- 
--   -- local i, _ = vim.iter(ipairs(breakpoints)):find(function(_, b) return b == breakpoint end )
--   local existing_breakpoint
--   for i, b in ipairs(breakpoints) do
--     if b.package == file.package and b.line == line then
--       existing_breakpoint = i
--     end
--   end
-- 
--   if existing_breakpoint then
--     table.remove(breakpoints, existing_breakpoint)
--   else
--     table.insert(
--       breakpoints,
--       {
--         breakpoint = breakpoint,
--         package = file.package,
--         path = file.path,
--         line = line,
--       }
--     )
--   end
-- 
--   print("breakpoints="..vim.inspect(breakpoints))
-- 
--   M.reset_breakpoints()
-- end
-- vim.api.nvim_create_user_command("ToggleBreakpoint", ToggleBreakpoint, {})
-- 
-- function M.reset_breakpoints()
--   vim.diagnostic.reset(breakpoints_ns)
-- 
--   local diagnostics_by_bufnr = {}
--   for _, b in ipairs(breakpoints) do
--     local bufnr = M.bufnr_for_path(b.path)
--     if bufnr then
--       diagnostics_by_bufnr[bufnr] = diagnostics_by_bufnr[bufnr] or {}
--       table.insert(
--         diagnostics_by_bufnr[bufnr],
--         {
--           bufnr = bufnr,
--           lnum = b.line,
--           col = 0,
--           severity = vim.diagnostic.severity.HINT,
--           message = "Breakpoint",
--         }
--       )
--     end
--   end
-- 
--   for bufnr, diagnostics in ipairs(diagnostics_by_bufnr) do
--     vim.diagnostic.set(breakpoints_ns, bufnr, diagnostics, { virtual_text = false })
--   end
-- end
-- 
-- function M.bufnr_for_path(path)
--   local paths = {}
--   path = vim.fs.normalize(path)
--   for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
--     local bufpath = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
--     if path[0] ~= "/" then
--       path = vim.loop.cwd().."/"..path
--     end
--     if bufpath == path then
--       return bufnr
--     end
-- 
--     table.insert(paths, bufpath)
--   end
-- 
--   print("no buffer for path="..vim.inspect(path).." paths="..vim.inspect(paths))
-- end
