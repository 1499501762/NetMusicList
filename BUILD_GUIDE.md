# 构建指南

## ✨ 自动依赖下载

**好消息！** 本项目支持自动从 Modrinth CDN 下载 NetMusic 依赖！

## 快速开始

### 1️⃣ 确保环境

- **Java 21** - 必需
- **网络连接** - 首次构建时下载依赖

### 2️⃣ 一键构建

```bash
# Windows
.\gradlew.bat build

# Linux/Mac  
./gradlew build
```

就这么简单！首次运行时会自动：
- 从 Modrinth 下载 NetMusic 1.2.1-fabric+mc1.21.1
- 保存到 `libs/` 目录
- 后续构建直接使用已下载的文件

### 3️⃣ 手动下载（可选）

如果需要单独下载依赖：

```bash
./gradlew downloadDependencies
```

## 🔧 高级配置

### 使用本地 jar 文件

如果你有本地的 NetMusic jar 文件（例如开发版本）：

1. 将 jar 文件放入 `libs/` 目录
2. 已存在的文件不会被自动下载覆盖
3. 删除 `libs/` 中的文件可触发重新下载

### 自动下载任务

项目包含自定义 Gradle 任务 `downloadDependencies`：

- **自动检测**: 如果 `libs/` 已有 jar 文件，跳过下载
- **自动下载**: 从 Modrinth CDN 获取最新版本
- **错误处理**: 下载失败时提供手动下载链接

查看任务详情：
```bash
./gradlew tasks --group dependencies
```

### 依赖版本更新

要更新 NetMusic 版本，请修改 [build.gradle](build.gradle) 中的 `downloadDependencies` 任务：
- 调整 `versionSlug` (当前为 `1.2.1-fabric+mc1.21.1`)
- Modrinth API URL 会随之自动更新

## 🚀 GitHub Actions

GitHub Actions 工作流已配置自动下载依赖：

- ✅ **自动构建** - 推送代码时自动编译
- ✅ **自动发布** - 推送 tag 时自动创建 Release  
- ✅ **自动依赖** - 使用 `downloadDependencies` 任务获取 NetMusic

工作流步骤：
1. Checkout 代码
2. 设置 Java 21
3. 下载 NetMusic 依赖
4. 构建项目
5. 上传构建产物

## 📝 注意事项

- **NetMusic 不会被打包** - 使用 `modCompileOnly` 配置
- **玩家需要安装** - 使用本模组的玩家需要同时安装 NetMusic
- **版本兼容** - NetMusic 1.2.1 for Minecraft 1.21.1
- **自动下载** - 仅在 `libs/` 目录为空时触发

## 🔍 故障排除

### 自动下载失败

如果自动下载失败，请手动下载：

**方法 1: 从 Modrinth 下载**
1. 访问: https://modrinth.com/mod/net-music/versions （作者 TartaricAcid，选择 1.2.1 / Fabric 1.21.1）
2. 点击下载按钮
3. 将下载的 jar 文件移动到项目的 `libs/` 目录
4. 重新运行 `./gradlew build`

**方法 2: 从 MC百科下载**
1. 访问: https://www.mcmod.cn/class/2335.html
2. 找到 Minecraft 1.21.1 的版本
3. 下载对应的 jar 文件
4. 放入项目 `libs/` 目录

**方法 3: 使用脚本下载**
- Windows: `./download-dependency.ps1`
- Linux/Mac: `./download-dependency.sh`

### 清理重新下载

```bash
# 删除已下载的依赖
rm -rf libs/*.jar  # Linux/Mac
del libs\*.jar     # Windows

# 重新下载
./gradlew downloadDependencies

# 或直接构建（会自动下载）
./gradlew build
```

### Gradle 缓存问题

```bash
./gradlew clean --refresh-dependencies
./gradlew build
```

## 🔗 相关链接

- **NetMusic Modrinth**: https://modrinth.com/mod/net-music/versions
- **NetMusic 版本**: https://modrinth.com/mod/net-music/versions
- **Fabric 文档**: https://fabricmc.net/develop/
- **Gradle 文档**: https://docs.gradle.org/

