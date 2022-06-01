local M = {}

-- Helpers for Tab / S-Tab completion
local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function check_back_space()
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
function TabComplete()
  if vim.fn.pumvisible() == 1 then
    return t("<C-n>")
  elseif check_back_space() then
    return t("<Tab>")
  else
    return vim.fn['compe#complete']()
  end
end

function STabComplete()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end


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
  vim.opt.tabstop = tonumber(args.args)
  vim.opt.shiftwidth = tonumber(args.args)
  vim.opt.softtabstop = tonumber(args.args)
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

function StatusLine()
  local bufnr = vim.fn.winbufnr(vim.g.statusline_winid)
  local diagnostics = ""
  for _, v in ipairs({
    { "E", #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR }) },
    { "W", #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN }) },
    { "I", #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.INFO }) },
    { "H", #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.HINT }) },
  }) do
    if v[2] > 0 then
      diagnostics = diagnostics .. " "..v[1].."="..v[2]
    end
  end

  local tag = ""
  if bufnr == vim.fn.bufnr("%") and vim.opt.filetype ~= "text" then
    tag = vim.fn["tagbar#currenttag"](' %s', '', 'f')
  end
  return "%f%-m%-r %p%%:%l/%L Col:%vBuf:#%n Char:%b,0x%B"..tag..diagnostics
end

function M.run_command(args)
  local lines = vim.api.nvim_buf_get_lines(0, args.line1 - 1, args.line2, true)
  local cmd = table.concat(lines, "\n")
  local opts = {
    mode = "async",
    strip = true,
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
    target = "."
  elseif args.range == 2 then
    target = "'<,'>"
  end

  local search_reg = vim.fn.getreg("@")
  vim.cmd("keepj normal! msHmt")
  vim.cmd("keepj "..target.."s/\\s\\+$//e")
  vim.fn.setreg("@", search_reg)
  vim.cmd("nohl")
  vim.cmd("keepj normal! 'tzt`s")
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

function M.last_position_jump()
  if vim.opt.filetype:get():lower():match("^git") then
    return
  end

  local line = vim.fn.line("'\"")
  if line > 0 and line < vim.fn.line("$") then
    vim.cmd('normal! g`\"')
  end
end

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

function M.telescope_live_grep(default)
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
    return true
  end
  -- require("telescope.builtin").live_grep({ attach_mappings = attach_mappings, default_text = default })
  require("telescope").extensions.live_grep_raw.live_grep_raw({ attach_mappings = attach_mappings, default_text = default })
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

return M
