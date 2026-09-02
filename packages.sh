#!/usr/bin/env bash

set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────
#  Colors & Utilities
# ─────────────────────────────────────────────────────────────────────────────

if [ -t 1 ]; then
  RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
  BLUE='\033[0;34m' CYAN='\033[0;36m' BOLD='\033[1m' DIM='\033[2m' NC='\033[0m'
else
  RED='' GREEN='' YELLOW='' BLUE='' CYAN='' BOLD='' DIM='' NC=''
fi

info() { echo -e "${BLUE}::${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1" >&2; }
skip() { echo -e "${DIM}○${NC} $1 ${DIM}(already installed)${NC}"; }
timing() { echo -e "${GREEN}✓${NC} $1 ${DIM}($2s)${NC}"; }

# Graceful exit on Ctrl+C
trap 'printf "\n"; warn "Installation cancelled by user"; print_summary; exit 130' INT

TOTAL=$(grep -E 'install_(pacman|aur) "' "$0" | wc -l)
CURRENT=0
FAILED=()
SUCCEEDED=()
SKIPPED=()
INSTALL_TIMES=()
START_TIME=$(date +%s)
AVG_TIME=8 # Initial estimate: 8 seconds per package

show_progress() {
  local current=$1 total=$2 name=$3
  local percent=$((current * 100 / total))
  local filled=$((percent / 5))
  local empty=$((20 - filled))

  # Calculate ETA
  local remaining=$((total - current))
  local eta=$((remaining * AVG_TIME))
  local eta_str=""
  if [ $eta -ge 60 ]; then
    eta_str="~$((eta / 60))m"
  else
    eta_str="~${eta}s"
  fi

  printf "\r\033[K[${CYAN}"
  printf "%${filled}s" | tr ' ' '█'
  printf "${NC}"
  printf "%${empty}s" | tr ' ' '░'
  printf "] %3d%% (%d/%d) ${BOLD}%s${NC} ${DIM}%s left${NC}" "$percent" "$current" "$total" "$name" "$eta_str"
}

# Update average install time
update_avg_time() {
  local new_time=$1
  if [ ${#INSTALL_TIMES[@]} -eq 0 ]; then
    AVG_TIME=$new_time
  else
    local sum=$new_time
    for t in "${INSTALL_TIMES[@]}"; do
      sum=$((sum + t))
    done
    AVG_TIME=$((sum / (${#INSTALL_TIMES[@]} + 1)))
  fi
  INSTALL_TIMES+=($new_time)
}

# Safe command executor (no eval)
run_cmd() {
  "$@" 2>&1
}

# Network retry wrapper - uses run_cmd for safety
with_retry() {
  local max_attempts=3
  local attempt=1
  local delay=5

  while [ $attempt -le $max_attempts ]; do
    if output=$(run_cmd "$@"); then
      echo "$output"
      return 0
    fi

    # Check for network errors
    if echo "$output" | grep -qiE "network|connection|timeout|unreachable|resolve"; then
      if [ $attempt -lt $max_attempts ]; then
        warn "Network error, retrying in ${delay}s... (attempt $attempt/$max_attempts)"
        sleep $delay
        delay=$((delay * 2))
        attempt=$((attempt + 1))
        continue
      fi
    fi

    echo "$output"
    return 1
  done
  return 1
}

print_summary() {
  local end_time=$(date +%s)
  local duration=$((end_time - START_TIME))
  local mins=$((duration / 60))
  local secs=$((duration % 60))

  echo
  echo "─────────────────────────────────────────────────────────────────────────────"
  local installed=${#SUCCEEDED[@]}
  local skipped_count=${#SKIPPED[@]}
  local failed_count=${#FAILED[@]}

  if [ $failed_count -eq 0 ]; then
    if [ $skipped_count -gt 0 ]; then
      echo -e "${GREEN}✓${NC} Done! $installed installed, $skipped_count already installed ${DIM}(${mins}m ${secs}s)${NC}"
    else
      echo -e "${GREEN}✓${NC} All $TOTAL packages installed! ${DIM}(${mins}m ${secs}s)${NC}"
    fi
  else
    echo -e "${YELLOW}!${NC} $installed installed, $skipped_count skipped, $failed_count failed ${DIM}(${mins}m ${secs}s)${NC}"
    echo
    echo -e "${RED}Failed:${NC}"
    for pkg in "${FAILED[@]}"; do
      echo "  • $pkg"
    done
  fi
  echo "─────────────────────────────────────────────────────────────────────────────"
}

is_installed() { pacman -Qi "$1" &>/dev/null; }

install_pacman() {
  local name=$1 pkg=$2
  CURRENT=$((CURRENT + 1))

  if is_installed "$pkg"; then
    skip "$name"
    SKIPPED+=("$name")
    return 0
  fi

  show_progress $CURRENT $TOTAL "$name"
  local start=$(date +%s)

  local output
  if output=$(with_retry sudo pacman -S --needed --noconfirm "$pkg"); then
    local elapsed=$(($(date +%s) - start))
    update_avg_time $elapsed
    printf "\r\033[K"
    timing "$name" "$elapsed"
    SUCCEEDED+=("$name")
  else
    printf "\r\033[K${RED}✗${NC} %s\n" "$name"
    if echo "$output" | grep -q "target not found"; then
      echo -e "    ${DIM}Package not found${NC}"
    elif echo "$output" | grep -q "signature"; then
      echo -e "    ${DIM}GPG issue - try: sudo pacman-key --refresh-keys${NC}"
    fi
    FAILED+=("$name")
  fi
}

install_aur() {
  local name=$1 pkg=$2
  CURRENT=$((CURRENT + 1))

  if is_installed "$pkg"; then
    skip "$name"
    SKIPPED+=("$name")
    return 0
  fi

  show_progress $CURRENT $TOTAL "$name"
  local start=$(date +%s)

  local output
  if output=$(with_retry yay -S --needed --noconfirm "$pkg"); then
    local elapsed=$(($(date +%s) - start))
    update_avg_time $elapsed
    printf "\r\033[K"
    timing "$name" "$elapsed"
    SUCCEEDED+=("$name")
  else
    printf "\r\033[K${RED}✗${NC} %s\n" "$name"
    if echo "$output" | grep -q "target not found"; then
      echo -e "    ${DIM}Package not found in AUR${NC}"
    fi
    FAILED+=("$name")
  fi
}

# ─────────────────────────────────────────────────────────────────────────────

[ "$EUID" -eq 0 ] && {
  error "Run as regular user, not root."
  exit 1
}

while [ -f /var/lib/pacman/db.lck ]; do
  warn "Waiting for pacman lock..."
  sleep 2
done

info "Syncing databases..."
with_retry sudo pacman -Syu --noconfirm >/dev/null && success "Synced" || warn "Sync failed, continuing..."

if ! command -v yay &>/dev/null; then
  warn "Installing yay for AUR packages..."
  sudo pacman -S --needed --noconfirm git base-devel >/dev/null 2>&1
  tmp=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmp/yay" >/dev/null 2>&1
  (cd "$tmp/yay" && makepkg -si --noconfirm >/dev/null 2>&1)
  rm -rf "$tmp"
  command -v yay &>/dev/null && success "yay installed" || warn "yay install failed"
fi

echo
info "Installing $TOTAL packages"
echo

# --- Core tools ---
install_pacman "Git" "git"
install_pacman "Git Delta" "git-delta"
install_pacman "LazyGit" "lazygit"
install_pacman "Serie" "serie"
install_pacman "LazyDocker" "lazydocker"
install_pacman "Docker" "docker"
install_pacman "OpenSSH" "openssh"
install_pacman "NetworkManager" "networkmanager"
install_pacman "Pacman Contrib" "pacman-contrib"
install_pacman "Sudo" "sudo"

# --- Shell & CLI ---
install_pacman "Zsh" "zsh"
install_pacman "Foot" "foot"
install_pacman "Tmux" "tmux"
install_pacman "Zoxide" "zoxide"
install_pacman "Bat" "bat"
install_pacman "Eza" "eza"
install_pacman "Fd" "fd"
install_pacman "Ripgrep" "ripgrep"
install_pacman "Fzf" "fzf"
install_pacman "Hyperfine" "hyperfine"
install_pacman "Dust" "dust"
install_pacman "Tldr" "tealdeer"
install_pacman "Trash CLI" "trash-cli"
install_pacman "postgres CLI" "pgcli"
install_pacman "ATAC" "atac"

# --- Editors & dev ---
install_pacman "Neovim" "neovim"
install_pacman "Obsidian" "obsidian"
install_pacman "LibreOffice" "libreoffice-fresh"

# --- Audio / Video / Media ---
install_pacman "PipeWire" "pipewire"
install_pacman "PipeWire Pulse" "pipewire-pulse"
install_pacman "FFmpeg" "ffmpeg"
install_pacman "MPV" "mpv"
install_pacman "Discord" "discord"
install_pacman "OBS Studio" "obs-studio"
install_pacman "Cava" "cava"

# --- Desktop / Wayland ---
install_pacman "Hyprland" "hyprland"
install_pacman "Hypridle" "hypridle"
install_pacman "Hyprlock" "hyprlock"
install_pacman "Hyprpicker" "hyprpicker"
install_pacman "Hypershot" "hyprshot"
install_pacman "Awww" "awww"
install_pacman "Mako" "mako"
install_pacman "Rofi" "rofi"
install_pacman "Rofimoji" "rofimoji"
install_pacman "SDDM" "sddm"
install_pacman "XSettings Daemon" "xsettingsd"
install_pacman "wl-clipboard" "wl-clipboard"
install_pacman "Gammastep" "gammastep"

# --- File management ---
install_pacman "Yazi" "yazi"
install_pacman "Zathura" "zathura"
install_pacman "Zathura PDF Backend" "zathura-pdf-poppler"
install_pacman "Viewnior" "viewnior"

# --- Fonts ---
install_pacman "Cascadia Code Font" "ttf-cascadia-code"
install_pacman "JetBrains Mono" "ttf-jetbrains-mono"
install_pacman "JetBrains Mono Nerd Font" "ttf-jetbrains-mono-nerd"
install_pacman "Noto Fonts" "noto-fonts"
install_pacman "Noto Emoji Fonts" "noto-fonts-emoji"
install_pacman "Noto CJK Fonts" "noto-fonts-cjk"
install_pacman "Liberation" "ttf-liberation"
install_pacman "Dejavu" "ttf-dejavu"

# --- Utilities ---
install_pacman "Brightness Control" "brightnessctl"
install_pacman "Bluetooth Manager" "blueman"
install_pacman "Bluetooth Utils" "bluez-utils"
install_pacman "btop" "btop"
install_pacman "Man" "man-pages"
install_pacman "Fastfetch" "fastfetch"
install_pacman "Cliphist" "cliphist"
install_pacman "Powertop" "powertop"
install_pacman "Mesa Utils" "mesa-utils"
install_pacman "Wev" "wev"

# --- Filesystems & archives ---
install_pacman "7zip" "7zip"
install_pacman "Unzip" "unzip"
install_pacman "Zip" "zip"
install_pacman "DOS Filesystem Tools" "dosfstools"
install_pacman "exFAT Tools" "exfatprogs"
install_pacman "Dislocker" "dislocker"

# --- Gaming / Wine ---
install_pacman "Steam" "steam"
install_pacman "Wine" "wine"
install_pacman "Wine Gecko" "wine-gecko"
install_pacman "Wine Mono" "wine-mono"
install_pacman "Winetricks" "winetricks"

# --- Misc ---
install_pacman "GIMP" "gimp"
install_pacman "Telegram Desktop" "telegram-desktop"
install_pacman "qBittorrent" "qbittorrent"
install_pacman "Pywal" "python-pywal"
install_pacman "MPD" "mpd"
install_pacman "rmpc" "rmpc"
install_pacman "Stow" "stow"
install_pacman "TTYper" "ttyper"

if command -v yay &>/dev/null; then
  install_aur "Zen" "zen-browser-bin"
  install_aur "DXVK" "dxvk-bin"
  install_aur "Waybar" "waybar-git"
  install_aur "Docker Desktop" "docker-desktop"
  install_aur "Fast Node Manager" "fnm"
  install_aur "Grimblast" "grimblast-git"
  install_aur "ProtonUp-Qt" "protonup-qt"
  install_aur "Brillo" "brillo"
  install_aur "Spotify" "spotify"
  install_aur "SpotX" "spotx-git"
  install_aur "Spicetify CLI" "spicetify-cli"
  install_aur "Wofi Emoji" "wofi-emoji"
  install_aur "Tree-sitter" "tree-sitter-cli-github-bin"
  install_aur "bibata cursor" "bibata-cursor-theme"
  install_aur "Diffnav" "diffnav"
  install_aur "Lazysql" "lazysql"
  install_aur "Mycli" "mycli"
  install_aur "Maple Mono NF" "maplemono-nf-unhinted"
  install_aur "Hyprmoncfg" "hyprmoncfg"
  install_aur "Quickshell" "quickshell"
  install_aur "Rofi power menu" "rofi-power-menu"
fi

print_summary
