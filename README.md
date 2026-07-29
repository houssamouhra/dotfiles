# dotfiles

## Overview

My **Arch Linux** dotfiles for a clean, lightweight **Hyprland** desktop.
Managed with **GNU Stow** and optimized for a laptop + external monitor workflow.

## Features

- Hyprland-based Wayland desktop
- GNU Stow-managed configuration
- Modular package layout
- Laptop + external monitor support
- Waybar status bar
- Rofi application launcher
- Modern terminal workflow
- Neovim development environment
- MPD-based music setup
- Consistent [Tokyo Night theme](https://github.com/folke/tokyonight.nvim) across Ghostty and Neovim

## Dependencies

<details>
<summary>Core</summary>

- **[hyprland](https://hypr.land/)** – Wayland compositor
- **[GNU Stow](https://www.gnu.org/software/stow/)** – Symlink manager for dotfiles
- **[hyprmon](https://github.com/erans/hyprmon)** – TUI monitor configuration tool for Hyprland with profile management

</details>

<details>
<summary>UI / Desktop</summary>

- **[rofi](https://github.com/davatorium/rofi)** – application launcher
- **[hyprlock](https://github.com/hyprwm/hyprlock)** – screen locker
- **[swaync](https://github.com/ErikReider/SwayNotificationCenter)** – notification daemon
- **[pywal](https://github.com/dylanaraps/pywal)** – wallpaper-based color scheme generator

</details>

<details>
<summary>Terminal & Shell</summary>

- **[zsh](https://www.zsh.org/)** – shell
- **[ghostty](https://github.com/ghostty-org/ghostty)** – terminal emulator
- **[tmux](https://github.com/tmux/tmux)** – terminal multiplexer

</details>

<details>
<summary>Editor</summary>

- **[neovim](https://github.com/neovim/neovim)** – editor

</details>

<details>
<summary>CLI Tools</summary>

- **[yazi](https://github.com/sxyazi/yazi)** – terminal file manager
- **[atac](https://github.com/julien-cpsn/atac)** – terminal API client (Postman-like)
- **[bat](https://github.com/sharkdp/bat)** – cat clone with syntax highlighting
- **[btop](https://github.com/aristocratos/btop)** – system resource monitor
- **[cava](https://github.com/karlstav/cava)** – cross-platform audio visualizer
- **[delta](https://github.com/dandavison/delta)** – syntax-highlighting pager for Git
- **[diffnav](https://github.com/dlvhdr/diffnav)** – Git diff pager built on delta with file tree navigation
- **[eza](https://github.com/eza-community/eza)** – modern replacement for `ls`
- **[fzf](https://github.com/junegunn/fzf)** – command-line fuzzy finder
- **[fzf-git](https://github.com/junegunn/fzf-git.sh)** – shell key bindings for Git objects powered by fzf
- **[fastfetch](https://github.com/fastfetch-cli/fastfetch)** – system information tool
- **[lazygit](https://github.com/jesseduffield/lazygit)** – terminal UI for Git

</details>

<details>
<summary>Desktop Utilities</summary>

- **[gammastep](https://gitlab.com/chinstrap/gammastep)** – automatic screen color temperature adjustment
- **[mpd](https://www.musicpd.org/)** – music player daemon
- **[rmpc](https://github.com/mierak/rmpc)** – terminal MPD client
- **[mpv](https://github.com/mpv-player/mpv)** – media player
- **[spicetify](https://github.com/spicetify/cli)** – command-line tool to customize Spotify
- **[zathura](https://github.com/pwmt/zathura)** – PDF and document viewer

</details>

## Install

> [!WARNING]
> Back up your existing configs before installing.

#### 1. Clone the repository

```bash
git clone https://github.com/houssamouhra/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

#### 2. Install GNU Stow

Arch Linux:

```bash
sudo pacman -S stow
```

(Use your distro’s package manager if not on Arch.)

#### 3. Deploy the dotfiles

Install configs selectively, Stow creates symlinks into `$HOME`.

```bash
stow hypr nvim zshenv zsh ...
```

#### 4. Reload the configuration

Some configs require a reload or restart

```shell
hyprctl reload
source ~/.config/zsh/.zshrc
```

> [!NOTE]
>
> - Each directory represents a package managed by Stow
> - Files are symlinked into `$HOME` following the XDG layout (`~/.config/...`)
> - To remove a package: `stow -D <package-name>`

## Screenshots

<table>
  <tr>
    <td><img src="screenshots/workspace1.png" width="400"/></td>
    <td><img src="screenshots/workspace2.png" width="400"/></td>
  </tr>
  <tr>
    <td><img src="screenshots/cava.png" width="400"/></td>
    <td><img src="screenshots/nvim.png" width="400"/></td>
  </tr>
</table>

## Package Installer

For Arch Linux, you can install most required packages using the provided script:

> [!NOTE]
> The installer is optional. You can install the dependencies manually using your preferred package manager.
> It also includes a few packages that are part of my personal workflow, so you may not want to install everything.

```bash
curl -sL https://raw.githubusercontent.com/houssamouhra/dotfiles/refs/heads/master/packages.sh | sh
```

Or, run the script manually:

```bash
cd dotfiles
./packages.sh
```

## License

[MIT](./LICENSE)
