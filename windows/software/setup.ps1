# setup.ps1 — Automated Software Installation

Write-Host "🚀 Setting up development environment..." -ForegroundColor Cyan

# --- Utilities ---
winget install --id 7zip.7zip -e
winget install --id voidtools.Everything -e
winget install --id FxSoundLLC.FxSound -e
winget install --id Flow-Launcher.Flow-Launcher -e

# --- Dev Tools ---
winget install --id Git.Git -e
winget install --id JesseDuffield.lazygit -e
winget install --id MarkText.MarkText -e
winget install --id Neovim.Neovim -e
winget install --id Microsoft.VisualStudioCode -e
winget install --id OpenJS.NodeJS -e
winget install --id pnpm.pnpm -e
winget install --id Postman.Postman -e
winget install --id Microsoft.PowerShell -e
winget install --id Microsoft.WSL -e

# --- Browsers & Communication ---
winget install --id Brave.Brave -e
winget install --id Discord.Discord -e
winget install --id Telegram.TelegramDesktop -e

# --- Media & File Tools ---
winget install --id VideoLAN.VLC -e
winget install --id FFmpeg.FFmpeg -e
winget install --id yt-dlp.yt-dlp -e
winget install --id qBittorrent.qBittorrent -e
winget install --id SumatraPDF.SumatraPDF -e
winget install --id QL-Win.QuickLook -e
winget install --id JPEGView.JPEGView -e

Write-Host "✅ All software installed successfully!" -ForegroundColor Green
