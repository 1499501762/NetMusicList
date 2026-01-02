# NetMusicList 升级到 Minecraft 1.21.1 说明

## 已完成的更新

### 1. 版本配置更新
- **Minecraft 版本**: 1.20.1 → 1.21.1
- **Yarn Mappings**: 1.20.1+build.10 → 1.21.1+build.3
- **Fabric API**: 0.92.6+1.20.1 → 0.107.0+1.21.1
- **Fabric Loader**: 0.16.14 (保持不变)
- **Fabric Loom**: 1.10-SNAPSHOT → 1.11-SNAPSHOT
- **Java 版本**: 17 → 21 (Minecraft 1.21.1 需要 Java 21)
- **模组版本**: 1.0 → 1.1

### 2. API 更新
已修复 Minecraft 1.21.1 的 API 变更：
- `net.minecraft.client.item.TooltipContext` → `net.minecraft.item.tooltip.TooltipType`
- 更新了 `appendTooltip` 方法签名以匹配新的 API

### 3. Gradle 配置
- Gradle Wrapper 版本: 8.14.1 (已支持 Java 21)

## 待完成的步骤

### 重要：NetMusic 模组依赖

由于本模组依赖于 NetMusic 模组，您需要完成以下步骤：

#### 方案 1：使用本地 NetMusic JAR 文件（推荐）

1. 获取 NetMusic 1.21.1 版本的 JAR 文件
   - 从 NetMusic 的发布页面下载 1.21.1 版本
   - 或者从本地模组文件夹复制

2. 创建 `libs` 文件夹并放置文件：
   ```
   mkdir libs
   # 将 netmusic-1.21.1-x.x.x.jar 文件复制到 libs 文件夹
   ```

3. 取消注释 `build.gradle` 中的依赖行：
   ```gradle
   modImplementation "blank:netmusic-1.21.1:1.2.1"
   ```
   根据实际的 NetMusic 版本调整版本号。

#### 方案 2：等待 NetMusic 更新

如果 NetMusic 模组尚未发布 1.21.1 版本：
- 关注 NetMusic 的更新
- 或者联系 NetMusic 作者询问 1.21.1 支持计划

## 构建项目

确保您已安装 Java 21：

```powershell
# 检查 Java 版本
java -version

# 应该显示类似 "openjdk version "21.x.x" 的信息
```

构建项目：

```powershell
.\gradlew.bat clean build
```

## 测试建议

1. 测试音乐列表的基本功能
2. 测试播放模式切换（循环、顺序、随机）
3. 测试与音乐播放器方块的交互
4. 测试 CD 刻录机的兼容性
5. 验证所有 Mixin 正常工作

## 已知问题

目前没有已知的重大问题，但由于依赖 NetMusic 模组，需要确保：
- NetMusic 1.21.1 版本与本模组兼容
- NetMusic 的 API 没有重大变更

## 回滚到 1.20.1

如果需要回滚到 1.20.1 版本，可以使用 Git 恢复更改：

```powershell
git checkout HEAD -- gradle.properties build.gradle
git checkout HEAD -- src/main/java/com/gly091020/NetMusicListItem.java
```

## 联系与支持

如果在升级过程中遇到问题，请：
1. 检查 NetMusic 模组是否正确安装
2. 确认 Java 21 正确配置
3. 查看构建日志以获取详细错误信息
