# NetMusicList 构建脚本
# 使用前请确保：
# 1. 已安装 Java 21
# 2. NetMusic 1.21.1 JAR 文件已放置在 libs 文件夹中

Write-Host "NetMusicList 1.21.1 构建脚本" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""

# 检查 Java 版本
Write-Host "检查 Java 版本..." -ForegroundColor Yellow
$javaVersion = & java -version 2>&1 | Select-String "version"
Write-Host $javaVersion
Write-Host ""

# 检查是否为 Java 21
if ($javaVersion -notmatch "21\.") {
    Write-Host "警告: 需要 Java 21！" -ForegroundColor Red
    Write-Host "请安装 Java 21 并设置 JAVA_HOME 环境变量" -ForegroundColor Red
    Write-Host ""
    $continue = Read-Host "是否继续构建？(y/n)"
    if ($continue -ne "y") {
        exit
    }
}

# 检查 libs 文件夹
Write-Host "检查依赖文件..." -ForegroundColor Yellow
if (-not (Test-Path "libs")) {
    Write-Host "警告: libs 文件夹不存在，正在创建..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path "libs" | Out-Null
}

$netmusicFiles = Get-ChildItem -Path "libs" -Filter "netmusic*.jar" -ErrorAction SilentlyContinue
if ($netmusicFiles.Count -eq 0) {
    Write-Host "警告: 未找到 NetMusic JAR 文件！" -ForegroundColor Red
    Write-Host "请将 NetMusic 1.21.1 的 JAR 文件放置在 libs 文件夹中" -ForegroundColor Red
    Write-Host ""
    $continue = Read-Host "是否继续构建？(y/n)"
    if ($continue -ne "y") {
        exit
    }
} else {
    Write-Host "找到 NetMusic 文件:" -ForegroundColor Green
    $netmusicFiles | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Green }
}
Write-Host ""

# 清理并构建
Write-Host "开始构建项目..." -ForegroundColor Yellow
Write-Host "执行: .\gradlew.bat clean build" -ForegroundColor Cyan
Write-Host ""

& .\gradlew.bat clean build

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "======================================" -ForegroundColor Green
    Write-Host "构建成功！" -ForegroundColor Green
    Write-Host "输出文件位置: build\libs\" -ForegroundColor Green
    Write-Host "======================================" -ForegroundColor Green
    
    # 列出构建的文件
    $buildFiles = Get-ChildItem -Path "build\libs" -Filter "*.jar" -ErrorAction SilentlyContinue
    if ($buildFiles.Count -gt 0) {
        Write-Host ""
        Write-Host "生成的文件:" -ForegroundColor Cyan
        $buildFiles | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Cyan }
    }
} else {
    Write-Host ""
    Write-Host "======================================" -ForegroundColor Red
    Write-Host "构建失败！" -ForegroundColor Red
    Write-Host "请检查上面的错误信息" -ForegroundColor Red
    Write-Host "======================================" -ForegroundColor Red
}

Write-Host ""
Write-Host "按任意键退出..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
