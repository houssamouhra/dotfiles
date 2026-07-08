-- General
vim.o.clipboard = 'unnamedplus'
vim.o.mouse = 'a'
vim.opt.mousemoveevent = true
vim.o.encoding = 'utf-8'
vim.o.fileencoding = 'utf-8'
vim.opt.termguicolors = true
vim.o.showmode = false -- Statusline already shows the current mode
vim.o.cmdheight = 1
vim.o.timeoutlen = 300
vim.o.updatetime = 250

-- UI
vim.wo.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 4
vim.wo.signcolumn = 'yes'
vim.o.cursorline = true
vim.o.scrolloff = 4
vim.o.sidescrolloff = 8
vim.o.showtabline = 2

-- Editing
vim.o.wrap = false
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.whichwrap = 'bs<>[]hl'
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.backspace = 'indent,eol,start'

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false

-- Windows
vim.o.splitbelow = true
vim.o.splitright = true

-- Files
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = true
vim.opt.bomb = false

-- Completion
vim.o.completeopt = 'menuone,noselect'
vim.o.pumheight = 10
vim.opt.shortmess:append 'c' -- Suppress completion messages

-- Markdown
vim.o.conceallevel = 0 -- Show Markdown code fences normally

-- Text Formatting
vim.opt.formatoptions:remove { 'c', 'r', 'o' } -- Don't automatically continue comments when pressing <Enter> or using o/O.
vim.opt.iskeyword:append '-' -- Treat hyphenated words as a single word.

-- Runtime
vim.opt.runtimepath:remove '/usr/share/vim/vimfiles' -- Prevent Vim plugins from being loaded into Neovim.
