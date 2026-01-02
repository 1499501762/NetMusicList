# 网络音乐机：播放列表

[![Build and Test](https://github.com/gly091020/NetMusicList/actions/workflows/build.yml/badge.svg)](https://github.com/gly091020/NetMusicList/actions/workflows/build.yml)
[![Release](https://github.com/gly091020/NetMusicList/actions/workflows/release.yml/badge.svg)](https://github.com/gly091020/NetMusicList/actions/workflows/release.yml)
[![License](https://img.shields.io/github/license/gly091020/NetMusicList)](LICENSE.txt)

**✨ 已更新至 Minecraft 1.21.1！**

<!-- **由于作者精力有限，模组fabric版停更，请转到[forge版](https://gitee.com/gly091020/netMusicListForge)** -->

给网络音乐机添加了一个播放列表物品，可以方便的播放多首歌曲

## 版本信息

- **Minecraft 版本**: 1.21.1
- **Fabric API**: 0.107.0+1.21.1
- **Java 版本**: 21 (必需)
- **依赖**: NetMusic 模组 1.21.1 版本

## 构建说明

### 前置要求

1. **Java 21** - 必需
2. **NetMusic 模组** - 需手动下载到 `libs/` 目录

### 步骤 1: 下载 NetMusic 依赖

**⚠️ 请手动下载（自动下载暂不可用）**

1. 在浏览器中打开: **https://modrinth.com/mod/net-music/versions**
2. 找到并点击 **1.2.1 for Fabric 1.21.1** 版本（作者 TartaricAcid）
3. 点击下载按钮，保存 `net-music-1.2.1-fabric+mc1.21.1.jar`（或 Modrinth 提供的同名文件）
4. 将下载的 jar 文件移动到项目的 `libs/` 目录

**备用下载源**:
- MC百科: https://www.mcmod.cn/class/2335.html
- GitHub (如果有): https://github.com/TartaricAcid/NetMusic/releases

**验证**: 确保 `libs/` 目录中包含 NetMusic 1.2.1 (Fabric 1.21.1) 的 jar 文件

### 步骤 2: 构建项目

```bash
# Windows
.\gradlew.bat build

# Linux/Mac  
./gradlew build
```

### 本地开发

如果需要使用特定版本的 NetMusic：

1. 将 NetMusic jar 文件放入 `libs/` 目录
2. 重新运行构建

### 输出位置

编译完成的 mod 文件位于：`build/libs/`

详细说明请参阅 [BUILD_GUIDE.md](BUILD_GUIDE.md) 和 [UPGRADE_1.21.1.md](UPGRADE_1.21.1.md)

## 🚀 自动化构建与发布

本项目使用 GitHub Actions 进行自动化构建和发布：

- **自动构建**: 每次提交代码时自动编译和测试
- **自动发布**: 推送版本标签时自动创建 Release

详细说明请查看 [GitHub Actions 工作流文档](.github/WORKFLOWS.md)

### 快速发布

```bash
# 创建并推送版本标签
git tag -a v1.1.0 -m "Release 1.1.0"
git push origin v1.1.0
```

## 开发说明

开发坏境无法播放音乐（没有声音），正式坏境正常

万恶之源：https://www.mcmod.cn/post/4332.html
