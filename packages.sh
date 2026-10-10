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

trap 'printf "\n"; warn "Installation cancelled by user"; print_summary; exit 130' INT

# ─────────────────────────────────────────────────────────────────────────────
#  Package lists  (name → package)
# ─────────────────────────────────────────────────────────────────────────────
declare -a PACMAN_PKGS=(
  # Core tools
  "Git|git"
  "Git Delta|git-delta"
  "LazyGit|lazygit"
  "Serie|serie"
  "LazyDocker|lazydocker"
  "Docker|docker"
  "OpenSSH|openssh"
  "NetworkManager|networkmanager"
  "Pacman Contrib|pacman-contrib"
  "OpenDoas|opendoas"

  # Shell & CLI
  "Zsh|zsh"
  "Foot|foot"
  "Tmux|tmux"
  "Zoxide|zoxide"
  "Bat|bat"
  "Eza|eza"
  "Fd|fd"
  "Ripgrep|ripgrep"
  "Fzf|fzf"
  "Hyperfine|hyperfine"
  "Dust|dust"
  "Tldr|tealdeer"
  "Trash CLI|trash-cli"
  "postgres CLI|pgcli"
  "ATAC|atac"
  "Duf|duf"
  "Pass|pass"

  # Editors & dev
  "Neovim|neovim"
  "LibreOffice|libreoffice-fresh"

  # Audio / Video / Media
  "PipeWire|pipewire"
  "PipeWire Pulse|pipewire-pulse"
  "FFmpeg|ffmpeg"
  "MPV|mpv"
  "Imv|imv"
  "Cava|cava"

  # Desktop / Wayland
  "Sway|sway"
  "Sway idle|swayidle"
  "swaylock|swaylock"
  "Hyprpicker|hyprpicker"
  "Slurp|slurp"
  "Grim|grim"
  "Awww|awww"
  "Mako|mako"
  "Fuzzel|fuzzel"
  "wl-clipboard|wl-clipboard"
  "Gammastep|gammastep"

  # File management
  "Yazi|yazi"
  "Zathura|zathura"
  "Zathura PDF Backend|zathura-pdf-poppler"

  # Fonts
  "Cascadia Code Font|ttf-cascadia-code"
  "JetBrains Mono|ttf-jetbrains-mono"
  "JetBrains Mono Nerd Font|ttf-jetbrains-mono-nerd"
  "Noto Fonts|noto-fonts"
  "Noto Emoji Fonts|noto-fonts-emoji"
  "Noto CJK Fonts|noto-fonts-cjk"
  "Liberation|ttf-liberation"
  "Dejavu|ttf-dejavu"

  # Utilities
  "Brightness Control|brightnessctl"
  "Bluetooth Manager|blueman"
  "Bluetooth Utils|bluez-utils"
  "xdg-desktop-portal-wlr|xdg-desktop-portal-wlr"
  "xdg-desktop-portal-gtk|xdg-desktop-portal-gtk"
  "btop|btop"
  "Man|man-pages"
  "Rofimoji|rofimoji"
  "Fastfetch|fastfetch"
  "Cliphist|cliphist"
  "MPD|mpd"
  "Powertop|powertop"
  "Mesa Utils|mesa-utils"

  # Filesystems & archives
  "7zip|7zip"
  "Unzip|unzip"
  "Zip|zip"
  "DOS Filesystem Tools|dosfstools"
  "exFAT Tools|exfatprogs"

  # Gaming / Wine
  "Steam|steam"
  "Wine|wine"
  "Wine Gecko|wine-gecko"
  "Wine Mono|wine-mono"
  "Winetricks|winetricks"

  # Misc
  "GIMP|gimp"
  "Telegram Desktop|telegram-desktop"
  "qBittorrent|qbittorrent"
  "Playerctl|playerctl"
  "rmpc|rmpc"
  "Stow|stow"
  "TTYper|ttyper"
  "Quickshell|quickshell"
)

declare -a AUR_PKGS=(
  "Zen|zen-browser-bin"
  "Waybar|waybar-git"
  "Fast Node Manager|fnm"
  "Spotify|spotify"
  "Tree-sitter|tree-sitter-cli-github-bin"
  "bibata cursor|bibata-cursor-theme"
  "ghgrab-bin|ghgrab-bin"
  "Diffnav|diffnav"
  "Lazysql|lazysql"
  "Mycli|mycli"
  "Maple Mono NF|maplemono-nf"
  "Dislocker|dislocker-mbedtls3"
  "Doas-sudo-shim|doas-sudo-shim"
)

TOTAL=$((${#PACMAN_PKGS[@]} + ${#AUR_PKGS[@]}))
CURRENT=0
FAILED=()
SUCCEEDED=()
SKIPPED=()
INSTALL_TIMES=()
START_TIME=$(date +%s)
AVG_TIME=8

# ─────────────────────────────────────────────────────────────────────────────
#  Helpers
# ─────────────────────────────────────────────────────────────────────────────
show_progress() {
  local current=$1 total=$2 name=$3
  local percent=$((current * 100 / total))
  local filled=$((percent / 5))
  local empty=$((20 - filled))
  local remaining=$((total - current))
  local eta=$((remaining * AVG_TIME))
  local eta_str

  if [ "$eta" -ge 60 ]; then
    eta_str="~$((eta / 60))m"
  else
    eta_str="~${eta}s"
  fi

  printf "\r\033[K[${CYAN}"
  printf "%${filled}s" | tr ' ' '#'
  printf "${NC}"
  printf "%${empty}s" | tr ' ' '-'
  printf "] %3d%% (%d/%d) ${BOLD}%s${NC} ${DIM}%s left${NC}" \
    "$percent" "$current" "$total" "$name" "$eta_str"
}

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
  INSTALL_TIMES+=("$new_time")
}

with_retry() {
  local max_attempts=3
  local attempt=1
  local delay=5
  local output

  while [ $attempt -le $max_attempts ]; do
    if output=$("$@" 2>&1); then
      echo "$output"
      return 0
    fi

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
  local end_time duration mins secs
  end_time=$(date +%s)
  duration=$((end_time - START_TIME))
  mins=$((duration / 60))
  secs=$((duration % 60))

  echo
  echo "─────────────────────────────────────────────────────────────────────────────"

  local installed=${#SUCCEEDED[@]}
  local skipped_count=${#SKIPPED[@]}
  local failed_count=${#FAILED[@]}

  if [ "$failed_count" -eq 0 ]; then
    if [ "$skipped_count" -gt 0 ]; then
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

is_installed() {
  pacman -Qi "$1" &>/dev/null
}

install_pacman() {
  local name=$1 pkg=$2
  CURRENT=$((CURRENT + 1))

  if is_installed "$pkg"; then
    skip "$name"
    SKIPPED+=("$name")
    return 0
  fi

  show_progress "$CURRENT" "$TOTAL" "$name"
  local start elapsed output
  start=$(date +%s)

  if output=$(with_retry sudo pacman -S --needed --noconfirm "$pkg"); then
    elapsed=$(($(date +%s) - start))
    update_avg_time "$elapsed"
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

  show_progress "$CURRENT" "$TOTAL" "$name"
  local start elapsed output
  start=$(date +%s)

  if output=$(with_retry paru -S --needed --noconfirm "$pkg"); then
    elapsed=$(($(date +%s) - start))
    update_avg_time "$elapsed"
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
#  Pre-flight
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
if ! with_retry sudo pacman -Syu --noconfirm >/dev/null; then
  error "Database sync failed. Aborting."
  exit 1
fi
success "Synced"

if ! command -v paru &>/dev/null; then
  warn "Installing paru for AUR packages..."
  sudo pacman -S --needed --noconfirm git base-devel >/dev/null 2>&1
  tmp=$(mktemp -d)
  git clone https://aur.archlinux.org/paru.git "$tmp/paru" >/dev/null 2>&1
  (cd "$tmp/paru" && makepkg -si --noconfirm >/dev/null 2>&1)
  rm -rf "$tmp"
  if command -v paru &>/dev/null; then
    success "paru installed"
  else
    warn "paru install failed — AUR packages will be skipped"
  fi
fi

echo
info "Installing $TOTAL packages"
echo

# ─────────────────────────────────────────────────────────────────────────────
#  Install
# ─────────────────────────────────────────────────────────────────────────────
for entry in "${PACMAN_PKGS[@]}"; do
  IFS='|' read -r name pkg <<<"$entry"
  install_pacman "$name" "$pkg"
done

if command -v paru &>/dev/null; then
  for entry in "${AUR_PKGS[@]}"; do
    IFS='|' read -r name pkg <<<"$entry"
    install_aur "$name" "$pkg"
  done
else
  warn "Skipping AUR packages (paru not available)"
fi

print_summary
