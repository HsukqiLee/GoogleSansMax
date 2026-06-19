# 技术原理解析与 Bug 修复说明

在开发本项目时，我们深入调研了市面上主流的字体模块（如 `notocjk`, `Google-Sans-Plus`, `MakeFontsGreatAgain` 等），并针对它们存在的历史遗留问题进行了底层架构重构：

## 1. 解决多模块共存时的 `fonts.xml` 冲突灾难

**原模块问题分析**: 绝大多数"简单替换型"字体模块会直接通过 Magisk 的 Magic Mount 机制盲目覆盖替换系统的 `/system/etc/fonts.xml`。当用户安装多个字体模块时，后加载的模块会暴力覆盖前者的 XML 文件，导致此前的配置全部失效。此外，这种盲目覆盖也会破坏各家手机厂商 (OEM) 针对自身 UI 定制的私有字体节点配置。

**本模块解决方案**: 我们摒弃了静态覆盖替换 XML 的做法。本模块在安装阶段使用高精度的 `sed` 动态解析与替换逻辑：
1. 首先对系统原生的 `fonts.xml` 进行特定节点（如 `sans-serif` 和 `zh-Hans` 等）的精细化替换，保留 OEM 的私有配置。
2. 随后，无缝对接 `UnicodeFontSet` 的高级 DOM 注入脚本，将复杂的 Unicode fallback 节点追加至文件尾部。

所有修改均在一个统一的流水线中于安装期（Install-time）完成，从而在根源上杜绝了模块间覆写冲突导致的字重不全或字符丢失问题。

## 2. 强制 Google 全家桶应用生效 (Kill GMS Font)

**原模块问题分析**: 当你成功将系统字体替换为 Google Sans 后，你会发现 Google 的第一方应用（如 Google 负一屏、Google 地图、Google 商店等）依然使用着它们自带的字体，甚至导致中日韩字重显示异常。这是因为 Google Play 服务 (GMS) 内部拥有一个 `FontsProvider`，它会绕过系统字体，私自将字体缓存下载至 `/data/` 分区供应用调用。

**本模块解决方案**: 我们深度整合了 `killgmsfont` 的核心拦截逻辑。模块会在开机后静默禁用 GMS 的字体更新服务，并自动清空其私自下载的字体缓存目录。通过此机制，我们强制要求所有的 Google 官方应用回退使用系统底层的 `GoogleSansMax`，从而确保全局（包含 Google 全家桶）字体渲染的绝对统一。

## 3. Firefox 兼容性 (Gecko 引擎忽略 `lang` 标签)

Firefox 的 Gecko 引擎在解析网页字体时，会忽略 Android `fonts.xml` / `font_fallback.xml` 中带有 `lang` 属性的 CJK 家族（这些标签对其他浏览器和系统 UI 正常）。因此，仅依赖 `lang="zh-Hans"` 等标签来挂载 CJK VF 字体的配置无法被 Firefox 识别。

**解决方案**: 在 `fonts.xml` 和 `font_fallback.xml` 末尾分别追加一条**无 `lang` 标签**的全局 CJK fallback 条目，使用系统静态字体 `NotoSansCJK-Regular.ttc`（非 VF、无 axis 标签），确保 Gecko 引擎能正确解析 CJK 字符。
