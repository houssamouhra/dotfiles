-- Wayland / Electron forcing
hl.env('ELECTRON_OZONE_PLATFORM_HINT', 'auto')

-- Session identification
hl.env('XDG_CURRENT_DESKTOP', 'Hyprland')
hl.env('XDG_SESSION_DESKTOP', 'Hyprland')
hl.env('XDG_SESSION_TYPE', 'wayland')

-- Qt
hl.env('QT_QPA_PLATFORMTHEME', 'qt6ct')
hl.env('QT_QPA_PLATFORM', 'wayland')

-- Firefox
hl.env('MOZ_ENABLE_WAYLAND', 1)

-- Cursor
hl.env('XCURSOR_THEME', 'Bibata-Modern-Classic')
hl.env('XCURSOR_SIZE', 22)
