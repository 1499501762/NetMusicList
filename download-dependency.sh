#!/bin/bash
# NetMusic 依赖下载脚本
# 用于手动下载 NetMusic 模组依赖

set -e

echo "=================================="
echo "NetMusicList - 依赖下载脚本"
echo "=================================="
echo ""

# 创建 libs 目录
LIBS_DIR="libs"
if [ ! -d "$LIBS_DIR" ]; then
    echo "📁 创建 libs 目录..."
    mkdir -p "$LIBS_DIR"
fi

# 检查是否已存在
if [ -n "$(ls -A $LIBS_DIR/*.jar 2>/dev/null)" ]; then
    echo "✅ 已存在依赖文件:"
    ls -lh $LIBS_DIR/*.jar | awk '{print "   - " $9 " (" $5 ")"}'
    echo ""
    read -p "是否重新下载? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "✅ 保留现有文件，退出"
        exit 0
    fi
    echo ""
fi

# 版本信息
VERSION_SLUG="1.2.1-fabric+mc1.21.1"
ENCODED_SLUG=$(python - <<'PY'
import urllib.parse, os
slug = os.environ.get('VERSION_SLUG','')
print(urllib.parse.quote(slug, safe=''))
PY
)
API_URL="https://api.modrinth.com/v2/project/net-music/version/$ENCODED_SLUG"
VERSION_PAGE="https://modrinth.com/mod/net-music/version/$ENCODED_SLUG"

TARGET_FILE=""
DOWNLOADED=false

echo "📥 正在从 Modrinth 获取版本信息..."
if JSON=$(curl -sSfL "$API_URL"); then
    read -r DOWNLOAD_URL FILENAME <<< "$(echo "$JSON" | python - <<'PY'
import sys, json
data = json.load(sys.stdin)
files = data.get('files') or []
if not files:
    raise SystemExit(1)
primary = next((f for f in files if f.get('primary')), files[0])
print(primary.get('url',''))
print(primary.get('filename',''))
PY
    )"
    if [ -n "$DOWNLOAD_URL" ] && [ -n "$FILENAME" ]; then
        TARGET_FILE="$LIBS_DIR/$FILENAME"
        echo "📥 下载: $FILENAME"
        echo "    $DOWNLOAD_URL"
        if curl -L -f -o "$TARGET_FILE" "$DOWNLOAD_URL" 2>/dev/null; then
            if [ -f "$TARGET_FILE" ]; then
                FILE_SIZE=$(du -h "$TARGET_FILE" | cut -f1)
                echo "✅ 下载成功!"
                echo "   文件: $(basename $TARGET_FILE)"
                echo "   大小: $FILE_SIZE"
                echo "   路径: $(readlink -f $TARGET_FILE 2>/dev/null || realpath $TARGET_FILE 2>/dev/null || echo $TARGET_FILE)"
                DOWNLOADED=true
            fi
        else
            echo "⚠️  下载失败"
            [ -f "$TARGET_FILE" ] && rm -f "$TARGET_FILE"
        fi
    fi
else
    echo "⚠️  获取版本信息失败"
fi

if [ "$DOWNLOADED" = false ]; then
    echo "❌ 自动下载失败!"
    echo ""
    echo "📝 请手动下载 NetMusic 1.2.1 (Fabric 1.21.1):"
    echo "   1. 访问: $VERSION_PAGE"
    echo "   2. 或访问: https://www.mcmod.cn/class/2335.html"
    echo "   3. 下载 jar 文件"
    echo "   4. 放入: $(pwd)/$LIBS_DIR"
    echo ""
    exit 1
fi

echo "=================================="
echo "✅ 依赖准备完成!"
echo "=================================="
echo ""
echo "现在可以运行: ./gradlew build"
