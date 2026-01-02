# NetMusic 依赖下载脚本
# 用于手动下载 NetMusic 模组依赖

$ErrorActionPreference = "Stop"

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "NetMusicList - Dependency Downloader" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Create libs directory
$libsDir = "libs"
if (-not (Test-Path $libsDir)) {
    Write-Host "[*] Creating libs directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $libsDir | Out-Null
}

# Check if file already exists
$existingFiles = Get-ChildItem -Path $libsDir -Filter "*.jar" -ErrorAction SilentlyContinue
if ($existingFiles) {
    Write-Host "[OK] NetMusic dependency already exists:" -ForegroundColor Green
    foreach ($file in $existingFiles) {
        Write-Host "   - $($file.Name) ($([math]::Round($file.Length/1MB, 2)) MB)" -ForegroundColor Gray
    }
    Write-Host ""
    $overwrite = Read-Host "Re-download? (y/N)"
    if ($overwrite -ne 'y' -and $overwrite -ne 'Y') {
        Write-Host "[OK] Keeping existing files" -ForegroundColor Green
        exit 0
    }
    Write-Host ""
}

$versionSlug = "1.2.1-fabric+mc1.21.1"
$encodedSlug = [System.Uri]::EscapeDataString($versionSlug)
$apiUrl = "https://api.modrinth.com/v2/project/net-music/version/$encodedSlug"
$versionPage = "https://modrinth.com/mod/net-music/version/$encodedSlug"

$targetFile = $null
$downloaded = $false

try {
    Write-Host "[*] Fetching version metadata from Modrinth..." -ForegroundColor Yellow
    Write-Host "    $apiUrl" -ForegroundColor Gray
    $json = Invoke-RestMethod -Uri $apiUrl -Method Get -Headers @{ "User-Agent" = "NetMusicList-Downloader" }
    if (-not $json.files -or $json.files.Count -eq 0) {
        throw "No files listed in Modrinth version metadata."
    }

    $fileEntry = $json.files | Where-Object { $_.primary } | Select-Object -First 1
    if (-not $fileEntry) {
        $fileEntry = $json.files | Select-Object -First 1
    }

    $fileName = $fileEntry.filename
    $downloadUrl = $fileEntry.url

    if (-not $fileName -or -not $downloadUrl) {
        throw "Missing filename or download url in Modrinth response."
    }

    $targetFile = Join-Path $libsDir $fileName
    Write-Host "[*] Downloading $fileName ..." -ForegroundColor Yellow
    Write-Host "    $downloadUrl" -ForegroundColor Gray

    Invoke-WebRequest -Uri $downloadUrl -OutFile $targetFile -UseBasicParsing

    if (Test-Path $targetFile) {
        $fileInfo = Get-Item $targetFile
        Write-Host "[OK] Download successful!" -ForegroundColor Green
        Write-Host "   File: $($fileInfo.Name)" -ForegroundColor Gray
        Write-Host "   Size: $([math]::Round($fileInfo.Length/1MB, 2)) MB" -ForegroundColor Gray
        Write-Host "   Path: $($fileInfo.FullName)" -ForegroundColor Gray
        $downloaded = $true
    }
}
catch {
    Write-Host "[!] Download failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($targetFile -and (Test-Path $targetFile)) {
        Remove-Item $targetFile -Force
    }
}

if (-not $downloaded) {
    Write-Host "[X] Automatic download failed." -ForegroundColor Red
    Write-Host ""
    Write-Host "Please manually download NetMusic 1.2.1 (Fabric 1.21.1):" -ForegroundColor Yellow
    Write-Host "   1. Visit: $versionPage" -ForegroundColor Gray
    Write-Host "   2. Or visit: https://www.mcmod.cn/class/2335.html" -ForegroundColor Gray
    Write-Host "   3. Download the jar file" -ForegroundColor Gray
    Write-Host "   4. Place in: $(Resolve-Path $libsDir)" -ForegroundColor Gray
    Write-Host ""
    exit 1
}

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "[OK] Dependency ready!" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Now run: .\gradlew.bat build" -ForegroundColor Cyan
