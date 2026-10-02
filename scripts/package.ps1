# Packaging Script for LNMIIT Login Utility
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$rootDir = Split-Path -Parent $PSScriptRoot
$distDir = Join-Path $rootDir "dist"

if (!(Test-Path $distDir)) {
    New-Item -ItemType Directory -Path $distDir -Force | Out-Null
}

$zipPath = Join-Path $distDir "lnmiit-login-utility.zip"

Write-Host "Creating extension release package..." -ForegroundColor Cyan

if (Test-Path $zipPath) {
    try {
        Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
    } catch {}
}

$items = @(
    (Join-Path $rootDir "manifest.json"),
    (Join-Path $rootDir "popup.html"),
    (Join-Path $rootDir "popup.css"),
    (Join-Path $rootDir "popup.js"),
    (Join-Path $rootDir "background.js"),
    (Join-Path $rootDir "content.js"),
    (Join-Path $rootDir "images")
)

Compress-Archive -Path $items -DestinationPath $zipPath -Force

if (Test-Path $zipPath) {
    $size = (Get-Item $zipPath).Length
    Write-Host "Package successfully created!" -ForegroundColor Green
    Write-Host "File: $zipPath ($([math]::Round($size / 1KB, 2)) KB)" -ForegroundColor Yellow
} else {
    Write-Host "Failed to create archive." -ForegroundColor Red
}
