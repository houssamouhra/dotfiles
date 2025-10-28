Invoke-Expression (&starship init powershell)

function touch {
    param (
        [string]$Path
    )
    if (!(Test-Path $Path)) {
        New-Item -ItemType File -Path $Path | Out-Null
    } else {
        (Get-Item $Path).LastWriteTime = Get-Date
    }
}