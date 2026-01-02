# NetMusic Dependency

## ✨ 自动下载（推荐）

**无需手动操作！** 项目会在首次编译时自动下载 NetMusic 依赖。

运行 `./gradlew build` 时会自动：
- 检查 `libs/` 目录是否有 jar 文件
- 如果没有，从 Modrinth CDN 下载
- 如果已有，直接使用现有文件

## 📦 本地文件（可选）

如果你需要使用本地的 NetMusic jar 文件：

### 使用场景

- 使用开发版本的 NetMusic
- 网络受限，无法访问 Maven 仓库
- 需要测试特定版本

### 使用方法

1. 下载 NetMusic 模组的 jar 文件（1.2.1 / Minecraft 1.21.1 版本，Modrinth 项目 net-music，作者 TartaricAcid）
2. 将 jar 文件放置在此目录（`libs/`）下
3. Gradle 会自动检测并优先使用本地文件

### 下载地址

- **Modrinth**: https://modrinth.com/mod/netmusic
- **MC百科**: https://www.mcmod.cn/class/2335.html
- **GitHub**: https://github.com/TartaricAcid/NetMusic

## 🔧 工作原理

项目的依赖配置：

1. **优先级 1**: 本地 `libs/` 目录中的 jar 文件
2. **优先级 2**: Modrinth Maven 仓库
3. **优先级 3**: CurseForge Maven 仓库（备用）

如果本地有 jar 文件，Gradle 会优先使用；否则自动从远程仓库下载。

## 📝 文件命名

文件名示例：
- `net-music-1.2.1-fabric+mc1.21.1.jar`
- 其他包含 `1.2.1` 且标注 Fabric 1.21.1 的文件名

确保文件扩展名为 `.jar`

## ⚙️ 依赖配置

在 [build.gradle](../build.gradle) 中的配置：

```gradle
// 自动从 Maven 仓库获取
modCompileOnly 'maven.modrinth:netmusic:1.2.1-fabric+mc1.21.1'
modLocalRuntime 'maven.modrinth:netmusic:1.2.1-fabric+mc1.21.1'

// 本地文件回退
modCompileOnly fileTree(dir: 'libs', include: '*.jar')
modLocalRuntime fileTree(dir: 'libs', include: '*.jar')
```

这样配置确保：
- 开发时可以编译和运行
- 发布时不会将 NetMusic 打包进模组
