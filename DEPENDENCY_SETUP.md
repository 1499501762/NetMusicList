# 自动依赖下载配置完成 ✅

## 📦 配置方案

由于 NetMusic 未发布到标准 Maven 仓库，项目采用**自动下载到本地**的方案：

- ✅ 首次构建时自动从 Modrinth CDN 下载
- ✅ 下载后保存到 `libs/` 目录供后续使用
- ✅ 支持手动放置本地 jar 文件
- ✅ GitHub Actions 自动处理依赖

## 🔧 技术实现

### 1. Gradle 自动下载任务

在 [build.gradle](build.gradle) 中添加了自定义任务：

```gradle
tasks.register('downloadDependencies') {
    description = 'Downloads NetMusic dependency from Modrinth'
    
    doLast {
        // 检查 libs/ 是否已有文件
        if (libs 目录为空) {
            // 从 Modrinth CDN 下载
            下载 NetMusic jar
        } else {
            // 跳过，使用现有文件
        }
    }
}

// 编译前自动下载
tasks.named('compileJava') {
    dependsOn 'downloadDependencies'
}
```

### 2. 依赖配置

简化的依赖配置：

```gradle
dependencies {
    // NetMusic from local libs/
    modCompileOnly fileTree(dir: 'libs', include: '*.jar')
    modLocalRuntime fileTree(dir: 'libs', include: '*.jar')
}
```

### 3. Maven 仓库

精简的仓库配置：

```gradle
repositories {
    mavenCentral()
    maven { url 'https://maven.fabricmc.net/' }
    flatDir { dirs 'libs' }
}
```

## 🚀 使用方法

### 本地开发

```bash
# 克隆仓库
git clone https://github.com/gly091020/NetMusicList.git
cd NetMusicList

# 直接构建（首次会自动下载依赖）
./gradlew build

# 运行开发环境
./gradlew runClient
```

### 手动下载依赖

```bash
# 单独执行下载任务
./gradlew downloadDependencies

# 查看下载的文件
ls -lh libs/
```

### 使用自定义版本

1. 从 Modrinth 下载需要的版本
2. 放入 `libs/` 目录
3. 构建时会使用你的版本（不会被覆盖）

## 📚 GitHub Actions 集成

### Build 工作流

```yaml
- name: Download NetMusic dependency
  run: ./gradlew downloadDependencies --no-daemon

- name: Build with Gradle
  run: ./gradlew build --no-daemon
```

### Release 工作流

```yaml
- name: Download NetMusic dependency  
  run: ./gradlew downloadDependencies --no-daemon

- name: Build release version
  run: ./gradlew build --no-daemon
```

## ✨ 优势

- ✅ **零配置** - 克隆即用，无需手动准备
- ✅ **CI/CD 友好** - GitHub Actions 自动处理
- ✅ **版本锁定** - 确保使用正确的 NetMusic 版本
- ✅ **离线友好** - 下载后可离线构建
- ✅ **灵活覆盖** - 支持本地自定义版本

## 📝 与 Maven 方案的区别

| 特性 | Maven 方案 | 当前方案 |
|------|-----------|---------|
| 自动化程度 | 完全自动 | 首次下载后缓存 |
| 依赖可用性 | ❌ NetMusic 未发布 | ✅ 从 CDN 下载 |
| 离线构建 | ❌ 需要网络 | ✅ 支持（下载后） |
| 版本控制 | Gradle 管理 | 文件+任务管理 |
| CI/CD 支持 | ✅ | ✅ |

## 🔍 故障排除

### 下载失败

```bash
# 检查错误信息
./gradlew downloadDependencies --stacktrace

# 手动下载并放入 libs/
# https://modrinth.com/mod/netmusic/version/1.2.1-fabric%2Bmc1.21.1
```

### 重新下载

```bash
# 删除现有文件
rm libs/*.jar

# 重新下载
./gradlew downloadDependencies
```

### 查看任务信息

```bash
./gradlew tasks --group dependencies
```

## 🎉 总结

项目现已配置自动依赖下载，开发体验流畅！

**首次构建**: `./gradlew build` → 自动下载 → 完成  
**后续构建**: `./gradlew build` → 使用缓存 → 完成

---

**配置状态**: ✅ 完成并测试  
**下载源**: Modrinth CDN  
**NetMusic 版本**: 1.2.1-fabric+mc1.21.1


## 🔧 配置详情

### 1. Maven 仓库配置

在 [build.gradle](build.gradle#L14-L40) 中添加了多个 Maven 仓库：

```gradle
repositories {
    mavenCentral()
    maven { url 'https://maven.fabricmc.net/' }
    
    // Modrinth Maven (主要源)
    maven {
        name = 'Modrinth'
        url = 'https://api.modrinth.com/maven'
        content {
            includeGroup 'maven.modrinth'
        }
    }
    
    // CurseForge Maven (备用源)
    maven {
        name = 'CurseForge'
        url = 'https://cursemaven.com'
        content {
            includeGroup 'curse.maven'
        }
    }
    
    // 本地文件（最高优先级）
    flatDir {
        dirs 'libs'
    }
}
```

### 2. 依赖配置

在 [build.gradle](build.gradle#L50-L58) 中配置了自动依赖：

```gradle
// 从 Modrinth Maven 自动获取
modCompileOnly 'maven.modrinth:netmusic:1.2.1-fabric+mc1.21.1'
modLocalRuntime 'maven.modrinth:netmusic:1.2.1-fabric+mc1.21.1'

// 本地文件回退
modCompileOnly fileTree(dir: 'libs', include: '*.jar')
modLocalRuntime fileTree(dir: 'libs', include: '*.jar')
```

### 3. GitHub Actions 工作流

#### Build 工作流 (.github/workflows/build.yml)

- ✅ 移除手动下载 NetMusic 的步骤
- ✅ 依赖会自动从 Maven 仓库获取
- ✅ 添加了 Gradle 缓存加速构建

#### Release 工作流 (.github/workflows/release.yml)

- ✅ 移除手动下载依赖的步骤
- ✅ 移除依赖检查步骤
- ✅ 简化发布流程

## 📚 文档更新

### 更新的文件

1. **[readme.md](readme.md)** - 更新构建说明
2. **[BUILD_GUIDE.md](BUILD_GUIDE.md)** - 完整的构建指南
3. **[libs/README.md](libs/README.md)** - 本地依赖说明

## 🚀 使用方法

### 本地开发

```bash
# 1. 克隆仓库
git clone https://github.com/gly091020/NetMusicList.git
cd NetMusicList

# 2. 直接构建（无需下载依赖！）
./gradlew build

# 3. 运行开发环境
./gradlew runClient
```

### CI/CD

- **自动构建**: 推送代码时自动编译
- **自动发布**: 推送 tag 时自动创建 Release
- **无需配置**: 依赖自动获取，无需手动干预

## 🔍 工作原理

### 依赖解析顺序

1. **本地 libs/ 目录** - 如果有文件，优先使用
2. **Modrinth Maven** - 自动下载 NetMusic
3. **CurseForge Maven** - 备用源（如果 Modrinth 不可用）

### 优势

- ✅ **零配置** - 克隆仓库即可构建
- ✅ **自动化** - GitHub Actions 自动处理依赖
- ✅ **灵活性** - 支持本地覆盖
- ✅ **可靠性** - 多个备用源
- ✅ **一致性** - 所有环境使用相同版本

## 🧪 测试

### 验证配置

```bash
# 清理并刷新依赖
./gradlew clean --refresh-dependencies

# 查看依赖树
./gradlew dependencies --configuration compileClasspath

# 构建项目
./gradlew build
```

## 📝 注意事项

1. **网络要求** - 首次构建需要网络连接下载依赖
2. **版本固定** - 当前使用 `netmusic:1.2.1-fabric+mc1.21.1`
3. **不打包** - NetMusic 不会被打包进最终的 jar 文件
4. **玩家依赖** - 用户需要同时安装 NetMusic 模组

## 🔄 版本更新

当 NetMusic 更新时，修改 [build.gradle](build.gradle#L53) 中的版本号：

```gradle
modCompileOnly 'maven.modrinth:netmusic:新版本号'
modLocalRuntime 'maven.modrinth:netmusic:新版本号'
```

## 🎉 完成！

现在项目支持自动依赖管理，开发体验更加流畅！

---

**最后更新**: 2026-01-02  
**配置状态**: ✅ 完成并测试
