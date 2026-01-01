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

构建时将网络音乐机mod放在libs文件夹下

详细的升级和构建说明请参阅 [UPGRADE_1.21.1.md](UPGRADE_1.21.1.md)

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
