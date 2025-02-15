local M = {}

-- -- Helpers for Tab / S-Tab completion
-- local function t(str)
--   return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end

-- local function check_back_space()
--   local col = vim.fn.col('.') - 1
--   if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
--     return true
--   else
--     return false
--   end
-- end

-- -- Use (s-)tab to:
-- --- move to prev/next item in completion menuone
-- --- jump to prev/next snippet's placeholder
-- function TabComplete()
--   if vim.fn.pumvisible() == 1 then
--     return t("<C-n>")
--   elseif check_back_space() then
--     return t("<Tab>")
--   else
--     return vim.fn['compe#complete']()
--   end
-- end

-- function STabComplete()
--   if vim.fn.pumvisible() == 1 then
--     return t "<C-p>"
--   else
--     -- If <S-Tab> is not working in your terminal, change it to <C-h>
--     return t "<S-Tab>"
--   end
-- end

local function visual_selection_range()
  local _, csrow, cscol, _ = unpack(vim.fn.getpos "'<")
  local _, cerow, cecol, _ = unpack(vim.fn.getpos "'>")

  local start_row, start_col, end_row, end_col

  if csrow < cerow or (csrow == cerow and cscol <= cecol) then
    start_row = csrow - 1
    start_col = cscol - 1
    end_row = cerow - 1
    end_col = cecol
  else
    start_row = cerow - 1
    start_col = cecol - 1
    end_row = csrow - 1
    end_col = cscol
  end

  -- The last char in ts is equivalent to the EOF in another line.
  local last_row = vim.fn.line "$"
  local last_col = vim.fn.col { last_row, "$" }
  last_row = last_row - 1
  last_col = last_col - 1
  if end_row == last_row and end_col == last_col then
    end_row = end_row + 1
    end_col = 0
  end

  local selected_lines = vim.api.nvim_buf_get_lines(0, start_row, end_row+1, true)
  selected_lines[1] = string.sub(selected_lines[1], start_col)
  selected_lines[#selected_lines] = string.sub(selected_lines[#selected_lines], 0, end_col - 1)
  return selected_lines
end

function M.rg(args)
  local needle
  if not args.range or args.range == 0 then
    if args.args ~= "" then
      needle = args.args
    else
      needle = vim.fn.expand("<cword>")
    end
  elseif args.range == 1 then
    print("line range not implemented yet")
  elseif args.range == 2 then
    needle = "'"..table.concat(visual_selection_range(), "\n").."'"
  end
  local rg_args = " --vimgrep "
  local search_reg
  if args.bang then
    rg_args = rg_args.."--word-regexp "
    search_reg = "\\v<"..needle..">"
  else
    search_reg = "\\v"..needle
  end
  local cmd = "rg"..rg_args..needle.. " <&-"

  local opts = {
    mode = "async",
    errorformat = "%f:%l:%c:%m",
    strip = true,
  }
  vim.fn["asyncrun#run"]("", opts, cmd)
  print("running: "..cmd)
  vim.fn.setreg("/", search_reg)
  vim.opt.hls = true
end

function M.rg_files_containing(args)
  print("rg_files_containing="..vim.inspect(args))
  local cmd = "rg -l "..args.args.. " <&-"

  local opts = {
    mode = "async",
    errorformat = "%f",
    strip = true,
  }
  vim.fn["asyncrun#run"]("", opts, cmd)
  print("running: "..cmd)
end

function M.rg_files(args)
  print("rg_files="..vim.inspect(args))
  local cmd = "rg --files -g '"..args.args.. "' <&-"

  local opts = {
    mode = "async",
    errorformat = "%f",
    strip = true,
  }
  vim.fn["asyncrun#run"]("", opts, cmd)
  print("running: "..cmd)
end

function M.xml_lint(args)
  print("xml_lint="..vim.inspect(args))
  vim.cmd(string.format("%d,%d !xmllint --format --recover -", args.line1, args.line2))
end

function M.json_lint(args)
  print("json_lint="..vim.inspect(args))
  vim.cmd(string.format("%d,%d !json_reformat", args.line1, args.line2))
end

function M.tabs(args)
  if args.args then
    vim.opt.tabstop = tonumber(args.args)
    vim.opt.shiftwidth = tonumber(args.args)
    vim.opt.softtabstop = tonumber(args.args)
  end
  print(string.format("ts=%d sw=%d sts=%d", vim.opt.tabstop:get(), vim.opt.shiftwidth:get(), vim.opt.softtabstop:get()))
end

function M.large_file(_)
  vim.opt.filetype = "text"
  vim.opt.inccommand = ""
  vim.opt.incsearch = false
  vim.opt.number = false
  print(string.format(
    "ft=%s inccommand=%s incsearch=%s number=%s",
    vim.opt.filetype:get(), vim.opt.inccommand:get(), vim.opt.incsearch:get(), vim.opt.number:get()))
end

function M.large_file_off(_)
  vim.cmd("filetype on")
  vim.cmd("filetype detect")
  vim.opt.inccommand = "nosplit"
  vim.opt.incsearch = true
  vim.opt.number = true
  print(string.format(
    "ft=%s inccommand=%s incsearch=%s number=%s",
    vim.opt.filetype:get(), vim.opt.inccommand:get(), vim.opt.incsearch:get(), vim.opt.number:get()))
end

local show_syn_stack = false

function StatusLine()
  local status = "%f%-m%-r %p%%:%l/%L Col:%vBuf:#%n Char:%b,0x%B"

  -- local mode = vim.fn.mode()
  -- if mode ~= "n" and mode ~= "i" then
  --   status = status.." "..mode
  -- end

  -- if vim.v.hlsearch == 1 then
  --   local searchcount = vim.fn.searchcount({maxcount = 98})
  --   local total = searchcount.incomplete > 0 and ">"..searchcount.total or searchcount.total
  --   local current = searchcount.current > 98 and  ">"..searchcount.current or searchcount.current
  --   local slash = vim.fn.getreg("/")
  --   if slash:sub(1, 2) == "\\v" then
  --     slash = slash:sub(3)
  --   end
  --   status = status.." ["..slash.."="..current.."/"..total.."]"
  -- end

  -- local recording = vim.fn.reg_recording()
  -- if recording ~= "" then
  --   status = status.." @"..recording
  -- end

  local bufnr = vim.fn.winbufnr(vim.g.statusline_winid)
  for _, v in ipairs({
    { "E", #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR }) },
    { "W", #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN }) },
    { "I", #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.INFO }) },
    { "H", #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.HINT }) },
  }) do
    if v[2] > 0 then
      status = status .. " "..v[1].."="..v[2]
    end
  end

  if show_syn_stack then
    local syn_stack = ""
    for _, id in ipairs(vim.fn.synstack(vim.fn.line("."), vim.fn.col("."))) do
      syn_stack = syn_stack .. " > " .. vim.fn.synIDattr(id, "name")
    end
    print(vim.inspect(syn_stack))
    status = status .. " " .. syn_stack
  end

  -- treesitter-context already shows this pretty well on the screen
  -- if bufnr == vim.fn.bufnr("%") and vim.opt.filetype ~= "text" then
  --   local tag = require("nvim-treesitter").statusline({
  --     separator = "->",
  --     indicator_size = vim.fn.winwidth(0) - status:len() - 10,
  --   }) or ""
  --   if tag ~= "" then
  --     status = status.." "..tag
  --   end
  -- end

  return status
end

function M.show_syn_stack()
  show_syn_stack = true
  vim.o.laststatus = 2
end

function M.hide_syn_stack()
  show_syn_stack = false
end

function M.run_command(args)
  local lines = vim.api.nvim_buf_get_lines(0, args.line1 - 1, args.line2, true)
  local cmd = table.concat(lines, "\n")
  local opts = {
    mode = "async",
    strip = true,
    errorformat = "%m",
    raw = true,
  }
  vim.fn["asyncrun#run"]("", opts, cmd)
end

function M.toggle_diff_ignore_whitespace()
  if vim.tbl_contains(vim.opt.diffopt:get(), "iwhite") then
    vim.opt.diffopt:remove("iwhite")
  else
    vim.opt.diffopt:append("iwhite")
  end
  print("diffopt="..table.concat(vim.opt.diffopt:get(), ","))
end

function M.strip_trailing_whitespace(args)
  local target
  if not args.range or args.range == 0 or args.target == 1 then
    target = "%"
  elseif args.range == 2 then
    target = "'<,'>"
  end

  local search_reg = vim.fn.getreg("@")
  M.keep_jumps(target.."s/\\s\\+$//e")
  vim.fn.setreg("@", search_reg)
  vim.cmd("nohl")
end

local next_error_loclist = false

function M.next_error()
  if next_error_loclist then
    pcall(vim.cmd, "lbelow")
  elseif not pcall(vim.cmd, "cbelow") then
    pcall(vim.cmd, "cnext")
  end
end

function M.previous_error()
  if next_error_loclist then
    pcall(vim.cmd, "labove")
  else
    -- cabove doesn't seem to throw an error when there are no errors above
    pcall(vim.cmd, "cprevious")
  end
end

function M.toggle_error_loclist()
  next_error_loclist = not next_error_loclist
  print("C-n, C-p use "..(next_error_loclist and "loclist" or "qflist"))
end

function M.last_position_jump(args)
  local ft = vim.opt.filetype:get():lower()
  if ft:match("^git") or ft:match("fugitive") or args.file:match("COMMIT_EDITMSG$") then
    return
  end

  local line = vim.fn.line("'\"")
  if line > 0 and line < vim.fn.line("$") then
    vim.cmd('normal! g`\"')
  end
end

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local lga_actions = require("telescope-live-grep-args.actions")

function M.telescope_live_grep(args)
  local current_word
  local current_WORD
  if args then
    if not args.range or args.range == 0 then
      if args.args ~= "" then
        current_word = args.args
      else
         current_word = vim.fn.expand("<cword>")
         current_WORD = vim.fn.expand("<cWORD>")
      end
    elseif args.range == 1 then
      print("line range not implemented yet")
      return
    elseif args.range == 2 then
      current_word = table.concat(visual_selection_range(), "\n")
    end
  end

  local replace_prompt = function(new_prompt, prompt_bufnr)
    if new_prompt == nil or vim.trim(new_prompt) == "" then
      return
    end
    action_state.get_current_picker(prompt_bufnr):set_prompt(new_prompt)
  end

  local insert_current_word = function(prompt_bufnr)
    replace_prompt(current_word or current_WORD, prompt_bufnr)
  end

  local insert_current_WORD = function(prompt_bufnr)
    replace_prompt(current_WORD or current_word, prompt_bufnr)
  end

  local quote_boundary = function(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local prompt = vim.trim(picker:_get_prompt())
    prompt = prompt:gsub('"', "\\" .. '"')
    prompt = '"\\b' .. prompt .. '\\b"'
    picker:set_prompt(prompt)
  end

  local mappings = {
    i = {
      ["<C-w>"] = insert_current_word,
      ["<C-a>"] = insert_current_WORD,
      ["<C-b>"] = quote_boundary,
      ["<C-k>"] = lga_actions.quote_prompt(),
    }
  }
  local attach_mappings = function(prompt_bufnr, map)
    local picker = action_state.get_current_picker(prompt_bufnr)
    actions.select_default:enhance({
      post = function()
        if picker.default_text == nil then
          return
        end
        vim.fn.setreg("/", "\\v"..picker.default_text)
        vim.opt.hls = true
      end,
    })
    actions.send_to_qflist:enhance({
      post = function()
        if picker.default_text == nil then
          return
        end
        vim.fn.setreg("/", "\\v"..picker.default_text)
        vim.opt.hls = true
      end,
    })
    actions.close:enhance({
      post = function()
        if picker.default_text == nil then
          return
        end
        action_state.get_current_history():append(action_state.get_current_line(), picker)
      end,
    })
    return true
  end
  -- require("telescope.builtin").live_grep({ attach_mappings = attach_mappings, default_text = default })
  -- require("telescope").extensions.live_grep_args.live_grep_args({ attach_mappings = attach_mappings, default_text = needle })
  require("telescope").extensions.live_grep_args.live_grep_args({
    attach_mappings = attach_mappings,
    mappings = mappings,
    -- additional_args = { "--sort=path" },
  })
end

function M.telescope_delete_buffer(prompt_bufnr, force)
  local picker = action_state.get_current_picker(prompt_bufnr)
  picker:delete_selection(function(selection)
    if vim.fn.bufnr("#") == selection.bufnr then
      actions.close(picker.prompt_bufnr)
    end
    local success, err = pcall(vim.api.nvim_buf_delete, selection.bufnr, { force = force })
    local opts = { initial_mode = "normal" }
    if not success then
      opts.prompt_title = string.format("Buffers (bdelete error='%s', use X to bdelete!)", err)
    end
    require("telescope.builtin").buffers(opts)
  end)
end

function M.telescope_force_delete_buffer(prompt_bufnr)
  M.telescope_delete_buffer(prompt_bufnr, true)
end

function M.telescope_send_and_open_qflist(prompt_bufnr)
  actions.smart_send_to_qflist(prompt_bufnr)
  actions.open_qflist(prompt_bufnr)
end

function M.keep_jumps(cmd)
  vim.cmd("keepjumps normal! msHmt")
  vim.cmd("keepjumps "..cmd)
  vim.cmd("keepjumps normal! 'tzt`s")
end

local Job = require('plenary/job')
local jobs = {}

local function clear_dead_job(j)
  jobs[j.pid] = nil
end

function M.job_start(args)
  local on_exit = args.on_exit
  args.on_exit = function(j, code, signal)
    clear_dead_job(j)
    local _ = on_exit and on_exit(j, code, signal)
  end
  local job = Job:new(args)
  job:start()
  jobs[job.pid] = job
end

function M.list_jobs()
  local out = { "Jobs:" }
  for pid, job in pairs(jobs) do
    table.insert(out, pid..": "..job.command.." "..table.concat(job.args, " "))
  end

  print(table.concat(out, "\n"))
end

function M.kill_job(args)
  if args.args and args.args ~= "" then
    local pid = tonumber(args.args)
    if pid == nil then
      error("Pid must be a number: "..vim.inspect(args.args))
    end

    local job = jobs[pid]

    if job == nil then
      error("Cannot find job with pid="..vim.inspect(pid))
    end

    print("Killing "..pid.."="..job.command.." "..table.concat(job.args, " "))
    vim.loop.process_kill(job.handle, "sigterm")
  else
    for _, job in pairs(jobs) do
      print("Killing "..job.pid.."="..job.command.." "..table.concat(job.args, " "))
      vim.loop.process_kill(job.handle, "sigterm")
    end
  end
end

return M
