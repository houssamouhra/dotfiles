# dotfiles

A curated collection of my personal configuration files — crafted for **speed**, **focus**, and **aesthetics**.

> “Your setup defines your momentum.”

### Reinstall all VS Code extensions from the list

Run the following command in **PowerShell**:

```powershell
Get-Content extensions.txt | ForEach-Object { code --install-extension $_ }
```

This will read each extension ID from `extensions.txt` and automatically install it in VS Code.
