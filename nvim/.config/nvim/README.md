# nvim-config

A clean, modern, and modular Neovim configuration focused on web development and general-purpose programming.

Built with [lazy.nvim](https://github.com/folke/lazy.nvim) and the [Tokyo Night](https://github.com/folke/tokyonight.nvim) theme.

## Features

- **Plugin manager** — [lazy.nvim](https://github.com/folke/lazy.nvim)
- **Theme** — [Tokyo Night](https://github.com/folke/tokyonight.nvim) (transparent)
- **File explorer** — [Neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) + [Oil.nvim](https://github.com/stevearc/oil.nvim)
- **Fuzzy finder** — [Telescope](https://github.com/nvim-telescope/telescope.nvim) + [fzf-native](https://github.com/nvim-telescope/telescope-fzf-native.nvim)
- **LSP** — [Mason](https://github.com/mason-org/mason.nvim) + [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- **Completion** — [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) + [LuaSnip](https://github.com/L3MON4D3/LuaSnip) + [friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
- **Formatting** — [conform.nvim](https://github.com/stevearc/conform.nvim)
- **Linting** — [nvim-lint](https://github.com/mfussenegger/nvim-lint)
- **Git** — [Gitsigns](https://github.com/lewis6991/gitsigns.nvim) + [Diffview](https://github.com/sindrets/diffview.nvim) + [Lazygit](https://github.com/jesseduffield/lazygit)
- **Syntax** — [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- **Debugging** — [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- **UI** — [Lualine](https://github.com/nvim-lualine/lualine.nvim), [bufferline](https://github.com/akinsho/bufferline.nvim), [Noice](https://github.com/folke/noice.nvim), [Which-Key](https://github.com/folke/which-key.nvim), [Snacks](https://github.com/folke/snacks.nvim), [Dashboard](https://github.com/nvimdev/dashboard-nvim), [mini.icons](https://github.com/nvim-mini/mini.icons)
- **Editing** — [Comment.nvim](https://github.com/numToStr/Comment.nvim), [Undotree](https://github.com/mbbill/undotree), [Zen Mode](https://github.com/folke/zen-mode.nvim), [Colorizer](https://github.com/norcalli/nvim-colorizer.lua), [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim)
- **Web stack** — JavaScript, TypeScript, HTML, CSS, Vue, Tailwind, JSON, etc.
- **Other** — Lua, Python, Docker, Prisma, YAML, and more

## Requirements

### Required

- [Neovim](https://neovim.io/) ≥ 0.10
- Git
- A [Nerd Font](https://www.nerdfonts.com/)

### Recommended

- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fd](https://github.com/sharkdp/fd)
- [lazygit](https://github.com/jesseduffield/lazygit)
- Clipboard provider (`wl-clipboard`, `xclip`, or `xsel`)

Most language servers and development tools are managed through Mason.

## Installation

This configuration is designed to work with [GNU Stow](https://www.gnu.org/software/stow/) and is included as a submodule in my [dotfiles](https://github.com/houssamouhra/dotfiles).

If you're using the full dotfiles repo, install it from there instead. The steps below are for standalone use.

### 1. Back up your existing configuration

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
```

### 2. Clone the repository

```bash
git clone https://github.com/houssamouhra/nvim-config.git ~/nvim-config
```

### 3. Install and stow

```bash
sudo pacman -S stow

cd ~/nvim-config
stow .
```

This creates the symlink:
```text
~/.config/nvim → ~/nvim-config/.config/nvim
```

### 4. Start Neovim

```bash
nvim
```

`lazy.nvim` will install the plugins on first launch. Mason will handle LSP servers and tools.

## Keybindings

**Leader key:** `Space`

### General

| Key           | Action                  |
|---------------|-------------------------|
| `Ctrl + s`    | Save file               |
| `Ctrl + q`    | Quit                    |
| `<leader>sn`  | Save without formatting |
| `<leader>x`   | Close buffer            |
| `<leader>b`   | New buffer              |
| `Tab`         | Next buffer             |
| `Shift + Tab` | Previous buffer         |

### Windows & Tabs

| Key          | Action               |
|--------------|----------------------|
| `<leader>v`  | Vertical split       |
| `<leader>h`  | Horizontal split     |
| `<leader>se` | Equalize splits      |
| `<leader>m`  | Maximize window      |
| `<leader>xs` | Close split          |
| `Ctrl + h/j/k/l` | Navigate windows |
| `<leader>to` | New tab              |
| `<leader>tx` | Close tab            |
| `<leader>tn` | Next tab             |
| `<leader>tp` | Previous tab         |

### File Navigation

| Key                | Action                          |
|--------------------|---------------------------------|
| `Ctrl + n`         | Toggle Neo-tree                 |
| `\`                | Reveal current file in Neo-tree |
| `-`                | Open Oil                        |
| `<leader>sf`       | Find files                      |
| `<leader>sg`       | Live grep                       |
| `<leader>sw`       | Grep word under cursor          |
| `<leader><leader>` | Find buffers                    |
| `<leader>s.`       | Recent files                    |
| `<leader>/`        | Search current buffer           |

### LSP

| Key          | Action               |
|--------------|----------------------|
| `gd`         | Go to definition     |
| `gr`         | Find references      |
| `gI`         | Go to implementation |
| `K`          | Hover                |
| `<leader>rn` | Rename               |
| `<leader>ca` | Code action          |
| `<leader>ds` | Document symbols     |
| `<leader>ws` | Workspace symbols    |
| `<leader>th` | Toggle inlay hints   |

### Git

| Key          | Action               |
|--------------|----------------------|
| `<leader>gg` | Lazygit              |
| `<leader>gp` | Preview hunk         |
| `<leader>gt` | Toggle line blame    |
| `<leader>dd` | Diffview             |
| `<leader>ds` | Diffview (staged)    |
| `<leader>dc` | Close Diffview       |

### Editing & Utilities

| Key          | Action                            |
|--------------|-----------------------------------|
| `Ctrl + /`   | Toggle comment                    |
| `<leader>u`  | Toggle Undotree                   |
| `<leader>xx` | Trouble diagnostics               |
| `<leader>z`  | Zen Mode                          |
| `<leader>s`  | Scratch buffer                    |
| `<leader>o`  | Open current HTML file in browser |

## Plugin Management

```vim
:Lazy          " open plugin manager
:Lazy update   " update all plugins
:Mason         " open Mason
```

## Starting Fresh

To completely reset everything:

```bash
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
```

Then clone again:

```bash
git clone https://github.com/houssamouhra/nvim-config.git ~/.config/nvim
```

> **Warning:** This deletes your configuration, plugins, state, and cache.

## License

[MIT](./LICENSE)
