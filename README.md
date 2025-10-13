# 👾 My Developer Dotfiles

A curated collection of my personal configuration files — crafted for speed, focus, and aesthetics.  
This setup covers **VS Code** and **Windows Terminal ([PowerShell](https://github.com/PowerShell/PowerShell))**
for a clean, efficient dev workflow.

---

## ⚙️ VS Code Setup

### 🔸 1. Restore Settings

Copy all VS Code configs into:

```
%APPDATA%\Code\User\
```

### 🔸 2. Restore Extensions

```powershell
cat vscode/extensions.txt | % { code --install-extension $_ }
```

### 🔸 3. Restore Snippets (optional)

```
%APPDATA%\Code\User\snippets\
```

---

## PowerShell / Windows Terminal Setup

### 🔸 1. Restore Windows Terminal settings

Copy `powershell/settings.json` to:

```shell
%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\
```

### 🔸 2. Restore PowerShell profile

Copy `Microsoft.PowerShell_profile.ps1` to:

```
Documents\PowerShell\
```

This enables your custom prompt, aliases, and Starship initialization.

---

## 🧰 Tools & Themes Used

| Tool                                                           | Description                                     |
| -------------------------------------------------------------- | ----------------------------------------------- |
| [Starship](https://starship.rs/)                               | Cross-shell prompt with Git, Node, Python, etc. |
| [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads) | Developer font with ligatures and symbols       |
| [Dracula Red Reforged](https://draculatheme.com/)              | My preferred terminal color scheme              |
| [Prettier](https://prettier.io/)                               | Code formatter                                  |
| [VS Code](https://code.visualstudio.com/)                      | Main editor                                     |

---

## 🧭 Usage

```bash
# Clone your dotfiles anywhere
git clone https://github.com/houssamouhra/dotfiles.git

# Navigate into it
cd dotfiles

# Apply configs manually or through a setup script (coming soon)
```

> “Your setup defines your momentum.”
