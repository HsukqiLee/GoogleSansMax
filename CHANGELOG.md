## What's New in v1.4.0

- `webroot/index.html` WebUI 全面重构：Home 首页（字号/字重滑块 + 自定义文本 + VF 预览）、Sans/Serif/Mono/CJK 四个字体预览 Tab、Compare 仅保留设备字体与 MiSans 对比、Charset 含字形覆盖测试
- 覆盖率测试拆分为 Unihan/Unicode 两种模式，支持测试中字符预览；检测改为 canvas 像素对比（tofu U+FFFF reference），结果按模式独立存储，切换不丢失
- 覆盖率分级采用 KMP 标准（PG/EX/A/B/C/D/E/F），Grade 颜色更新
- CJK 字形对比表加显式 Noto Sans CJK 字体族
- 字重网格拆分为正体/斜体两段，使用 curated array [100,200,300,350,400,500,600,700,800,900,950]
- 语言切换改为下拉菜单，标签显示 简中/繁中/EN/日/한
- 修复 CJK Tab serif 字体族、VF 预览字重实时更新、MiSans CDN、CJK 扩展 E 区里程碑文字
- 测试中禁用模式切换与隐藏满分按钮

## What's New in v1.3.1

- `49e8e04` fix(release): correct notofonts VF font download paths (unhinted/variable-ttf/[wdth,wght])
- `ea7ae3b` chore: auto-bump version and update JSONs to v1.3.1 [skip ci]
- `f72f837` fix(v1.3.1): action button, corrupted font detection, release workflow hardening
- `f8c42ce` chore: update font manifest [skip ci]
- `818264b` chore: auto-bump version and update JSONs to v1.3.0 [skip ci]
