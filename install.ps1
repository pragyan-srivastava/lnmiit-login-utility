<#
.SYNOPSIS
    LNMIIT Login Utility - PowerShell Interactive Setup & Launcher for Windows
.DESCRIPTION
    Instantly copies extension path to clipboard, detects installed Chromium browsers,
    and guides or launches the extension directly.
#>

[CmdletBinding()]
param()

$extDir = $PSScriptRoot

Clear-Host
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "          LNMIIT LOGIN UTILITY - ONE-CLICK INSTALLER (POWERSHELL)     " -ForegroundColor Yellow
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host " [i] Extension Path: " -NoNewline
Write-Host "$extDir" -ForegroundColor Green

# Automatically copy path to clipboard
try {
    Set-Clipboard -Value $extDir
    Write-Host " [✔] Path successfully copied to your clipboard!" -ForegroundColor Green
} catch {
    Write-Host " [!] Could not access clipboard automatically." -ForegroundColor Yellow
}

Write-Host ""

# Detect installed browsers
$browsers = @{}

$chromePaths = @(
    "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe",
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
    "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
)
foreach ($p in $chromePaths) {
    if (Test-Path $p) { $browsers["Chrome"] = $p; break }
}

$bravePaths = @(
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\Application\brave.exe",
    "$env:ProgramFiles\BraveSoftware\Brave-Browser\Application\brave.exe"
)
foreach ($p in $bravePaths) {
    if (Test-Path $p) { $browsers["Brave"] = $p; break }
}

$edgePaths = @(
    "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
    "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
)
foreach ($p in $edgePaths) {
    if (Test-Path $p) { $browsers["Edge"] = $p; break }
}

Write-Host "Detected Browsers:" -ForegroundColor White
if ($browsers.ContainsKey("Chrome")) { Write-Host "  - Google Chrome: Found ($($browsers['Chrome']))" -ForegroundColor Gray }
if ($browsers.ContainsKey("Brave"))  { Write-Host "  - Brave Browser: Found ($($browsers['Brave']))" -ForegroundColor Gray }
if ($browsers.ContainsKey("Edge"))   { Write-Host "  - Microsoft Edge: Found ($($browsers['Edge']))" -ForegroundColor Gray }
if ($browsers.Count -eq 0)           { Write-Host "  - No standard browser paths detected." -ForegroundColor DarkYellow }

Write-Host ""
Write-Host "Choose an option:" -ForegroundColor Cyan
Write-Host " [1] " -NoNewline -ForegroundColor Yellow; Write-Host "Guided Install: Open Extensions Page in default browser (Recommended)"
Write-Host " [2] " -NoNewline -ForegroundColor Yellow; Write-Host "Direct Run: Launch Chrome with extension preloaded"
Write-Host " [3] " -NoNewline -ForegroundColor Yellow; Write-Host "Direct Run: Launch Brave with extension preloaded"
Write-Host " [4] " -NoNewline -ForegroundColor Yellow; Write-Host "Direct Run: Launch Edge with extension preloaded"
Write-Host " [5] " -NoNewline -ForegroundColor Yellow; Write-Host "Package Extension into a clean .zip release"
Write-Host " [6] " -NoNewline -ForegroundColor Yellow; Write-Host "Exit"
Write-Host ""

$choice = Read-Host "Enter option number (1-6) [default: 1]"
if ([string]::IsNullOrWhiteSpace($choice)) { $choice = "1" }

switch ($choice) {
    "1" {
        Clear-Host
        Write-Host "=====================================================================" -ForegroundColor Cyan
        Write-Host "               PERMANENT INSTALLATION (3 QUICK STEPS)                " -ForegroundColor Yellow
        Write-Host "=====================================================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " 1. Your browser extensions page is opening now..." -ForegroundColor White
        Write-Host " 2. Toggle " -NoNewline; Write-Host "Developer mode" -ForegroundColor Yellow -NoNewline; Write-Host " ON (top-right corner switch)."
        Write-Host " 3. Click " -NoNewline; Write-Host "Load unpacked" -ForegroundColor Yellow -NoNewline; Write-Host " (top-left button)."
        Write-Host " 4. Press " -NoNewline; Write-Host "Ctrl + V" -ForegroundColor Green -NoNewline; Write-Host " into the folder dialog & press Enter!"
        Write-Host ""
        Write-Host " [i] The path is already on your clipboard:" -ForegroundColor DarkGray
        Write-Host "     $extDir" -ForegroundColor DarkGray
        Write-Host "=====================================================================" -ForegroundColor Cyan
        Write-Host ""

        if ($browsers.ContainsKey("Chrome")) {
            Start-Process -FilePath $browsers["Chrome"] -ArgumentList "chrome://extensions"
        } elseif ($browsers.ContainsKey("Brave")) {
            Start-Process -FilePath $browsers["Brave"] -ArgumentList "brave://extensions"
        } elseif ($browsers.ContainsKey("Edge")) {
            Start-Process -FilePath $browsers["Edge"] -ArgumentList "edge://extensions"
        } else {
            Start-Process "chrome://extensions"
        }
    }
    "2" {
        if ($browsers.ContainsKey("Chrome")) {
            Write-Host "Starting Chrome..." -ForegroundColor Green
            Start-Process -FilePath $browsers["Chrome"] -ArgumentList "--load-extension=`"$extDir`"", "https://172.22.2.6/connect/PortalMain"
        } else {
            Write-Host "Google Chrome not found at standard paths." -ForegroundColor Red
        }
    }
    "3" {
        if ($browsers.ContainsKey("Brave")) {
            Write-Host "Starting Brave..." -ForegroundColor Green
            Start-Process -FilePath $browsers["Brave"] -ArgumentList "--load-extension=`"$extDir`"", "https://172.22.2.6/connect/PortalMain"
        } else {
            Write-Host "Brave Browser not found at standard paths." -ForegroundColor Red
        }
    }
    "4" {
        if ($browsers.ContainsKey("Edge")) {
            Write-Host "Starting Edge..." -ForegroundColor Green
            Start-Process -FilePath $browsers["Edge"] -ArgumentList "--load-extension=`"$extDir`"", "https://172.22.2.6/connect/PortalMain"
        } else {
            Write-Host "Microsoft Edge not found at standard paths." -ForegroundColor Red
        }
    }
    "5" {
        $packageScript = Join-Path $extDir "scripts\package.ps1"
        & $packageScript
    }
    Default {
        Write-Host "Exiting." -ForegroundColor Gray
    }
}
