# 字重实现细节

## Google Sans Flex (Latin 无衬线)

- 单个可变字体文件，`wght` 轴原生支持 1–1000
- 支持 `opsz` (6–144)、`wdth` (25–151)、`GRAD` (0–100)、`slnt` (-10–0) 等辅助轴
- fonts.xml 声明 100–1000 共 10 个标准字重档位，通过 `<axis tag="wght" stylevalue="N" />` 精确映射
- App 可通过 `fontVariationSettings` 在运行时设置任意字重（1–1000）

## Latin 衬线 (serif)

- Noto Serif 可变字体，`wght` 轴支持 100–900
- CI 构建时从 notofonts.github.io 下载
- 所有字重通过 `<axis tag="wght" stylevalue="N" />` 精确映射
- 字重别名链: serif-thin(100)、serif-light(300)、serif-medium(400)、serif-semi-bold(500)、serif-bold(700)、serif-black(900)

## Noto Sans Mono (Latin 等宽)

- CI 构建时从 Google Fonts 下载可变字体
- `wght` 轴支持 100–900（VF 原生范围），超出范围自动 clamp

## Noto CJK (中日韩)

- VF `NotoSansCJK-VF.otf.ttc` 覆盖 100–900，`NotoSerifCJK-VF.otf.ttc` 覆盖 200–900
- CJK Black 字体内部 `usWeightClass=900`，与 VF 轴值 900 完全相同，因此无需单独声明 weight 1000
- 覆盖语言: 日语 (ja)、韩语 (ko)、简体中文 (zh-Hans)、繁体中文 (zh-Hant)、注音符号 (zh-Bopo)
- 所有 CJK 字重使用统一 `postScriptName`

## Emoji 引擎

在构建时自动同步上游最新资源，提供高兼容性的 CBDT (Bitmap) 与高清无损的 COLRv1 (Vector) 两种 Emoji 标准库供选。
- **生僻字补全**: 深度集成 `UnicodeFontSet` 核心代码，提供全 Unicode 字符集的 fallback 补全。
