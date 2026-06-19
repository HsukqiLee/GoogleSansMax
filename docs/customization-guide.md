# 基于本仓库定制属于你的字体模块

本项目已被设计为 Public Template（公共模板）。你可以直接 Fork 本仓库，用来快速构建属于你自己的 Magisk / KernelSU 字体模块，同时享有本项目的高级 XML 解析注入技术和热更新机制。

## 一、理解本项目使用的字体类型

本项目默认使用 **可变字体（Variable Font, VF）**，通过 `wght` 轴映射字重。你需要先搞清楚你的字体属于哪种类型：

| 你的字体类型 | 能否直接替换文件名？ | 需要额外修改什么？ |
|---|---|---|
| **可变字体（VF）**，且 `wght` 轴覆盖 100-900（或 100-1000），支持 normal + italic | ✅ 可直接改名替换 | 调整字重范围（若有差异） |
| **可变字体（VF）**，但缺少 italic，或 `wght` 轴范围不同 | ✅ 可直接改名替换 | 修改 `customize.sh` / `action.sh` / `lib/awk.sh` 中的字重范围和 italic 逻辑 |
| **静态字体（Static Font）**，每字重一个文件（如 `MyFont-Thin.ttf`, `MyFont-Bold.ttf`） | ❌ 不能直接替换 | 需重写 `generate_xxx_xml` 函数为静态字重映射 |
| **TTC 集合字体**（如 `NotoSansCJK-VF.otf.ttc` 多语言集合） | ⚠️ 需谨慎 | 需确保 TTC index、postScriptName 和语言映射正确 |
| **仅替换 CJK 字体，保留原 Latin** | ⚠️ 可局部替换 | 只替换 Noto CJK 系列文件，保留 GoogleSansFlex |

### 如何检查字体是否为可变字体？

在终端使用以下命令（需安装 `fonttools`）：

```bash
# 查看字体是否包含 fvar 表（Variable Font 标志）
python -c "from fontTools.ttLib import TTFont; f=TTFont('你的字体.ttf'); print('fvar' in f)"

# 查看 wght 轴范围
python -c "from fontTools.ttLib import TTFont; f=TTFont('你的字体.ttf'); axis=[a for a in f['fvar'].axes if a.axisTag=='wght'][0]; print(f'wght range: {axis.minValue}-{axis.maxValue}')"
```

## 二、替换字体文件（分场景详解）

### 场景 A：你的字体是可变字体（推荐，最简单）

**适用条件：** 字体包含 `fvar` 表，且 `wght` 轴覆盖范围包含 100-900（或接近）。

**步骤：**

1. 将你的 VF 字体文件放入 `system/fonts/` 目录
2. 将文件名改为与原模块一致的名称，例如若替换 Latin 无衬线字体，则命名为 `GoogleSansFlex-Regular.ttf`
3. 检查你的字体是否支持 italic（`slnt` 轴或单独的 italic 文件），若不支持，需修改 XML 生成函数去除 italic 条目
4. 检查你的字体 `wght` 轴范围，若范围小于 100-1000，需调整 `customize.sh` 中的 `WEIGHTS` 变量（第 64 行）

**示例：** 将 Latin 无衬线替换为 `Inter-VF.ttf`（可变字体，wght 100-900，无 italic）
- 重命名 `Inter-VF.ttf` → `GoogleSansFlex-Regular.ttf` 放入 `system/fonts/`
- 修改 `customize.sh` 第 64 行：`WEIGHTS="100 200 300 400 500 600 700 800 900"`（去掉 1000）
- 修改 `customize.sh` 中 `generate_sans_serif_xml()` 函数，删除 italic 相关的行（第 79 行）
- 同步修改 `action.sh` 和 `lib/awk.sh` 中对应的 sans-serif 生成逻辑

### 场景 B：你的字体是静态字体（每字重一个文件）

字体文件名包含字重标识，如 `MyFont-Regular.ttf`（weight 400）、`MyFont-Bold.ttf`（weight 700）

你需要将 `generate_sans_serif_xml()` 函数从 VF 模式改为静态映射模式。示例：

```bash
# 修改前（VF 模式）
generate_sans_serif_xml() {
    local OUT="$1"
    echo '    <family name="sans-serif">' > "$OUT"
    for W in $WEIGHTS; do
        echo "        <font weight=\"$W\" style=\"normal\">GoogleSansFlex-Regular.ttf<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$OUT"
        echo "        <font weight=\"$W\" style=\"italic\">GoogleSansFlex-Regular.ttf<axis tag=\"wght\" stylevalue=\"$W\" /><axis tag=\"slnt\" stylevalue=\"-10\" /></font>" >> "$OUT"
    done
    echo '    </family>' >> "$OUT"
}

# 修改后（静态模式，每个字重一个文件，文件名为 MyFont-{weight}.ttf）
generate_sans_serif_xml() {
    local OUT="$1"
    echo '    <family name="sans-serif">' > "$OUT"
    echo '        <font weight="100" style="normal">MyFont-Thin.ttf</font>' >> "$OUT"
    echo '        <font weight="300" style="normal">MyFont-Light.ttf</font>' >> "$OUT"
    echo '        <font weight="400" style="normal">MyFont-Regular.ttf</font>' >> "$OUT"
    echo '        <font weight="500" style="normal">MyFont-Medium.ttf</font>' >> "$OUT"
    echo '        <font weight="700" style="normal">MyFont-Bold.ttf</font>' >> "$OUT"
    echo '        <font weight="900" style="normal">MyFont-Black.ttf</font>' >> "$OUT"
    echo '    </family>' >> "$OUT"
}
```

**需要同步修改的文件（共 3 个）：**
- `customize.sh` — `generate_sans_serif_xml()`（第 74-82 行）、`generate_serif_xml()`（第 99-107 行）、`generate_mono_xml()`（第 87-94 行）
- `action.sh` — 第 280-303 行（sans-serif、serif、monospace 生成逻辑）
- `lib/awk.sh` — `patch_font_fallback()` 中 sans-serif（第 25-32 行）、serif（第 37-44 行）、monospace（第 53-59 行）的生成逻辑

### 场景 C：替换 CJK 字体

CJK 字体比 Latin 复杂，涉及：
- **TTC index**：`NotoSansCJK-VF.otf.ttc` 是一个 TTC 集合，内部 index 0=日语、1=韩语、2=简体中文、3=繁体中文
- **postScriptName**：生成 XML 时需指定 `postScriptName="NotoSansCJK${LANG_PREFIX}-Thin"`，其中 `LANG_PREFIX` 为 `jp`/`kr`/`sc`/`tc`
- **语言映射**：`customize.sh` 第 222-226 行的 `case` 语句定义了 `LANG_TAG` → `INDEX` + `LANG_PREFIX` 的映射关系

**如果你替换的 CJK 字体也是 TTC VF 集合：**
- 文件放入 `system/fonts/`，重命名为 `NotoSansCJK-VF.otf.ttc`
- 调整 `customize.sh` 第 222-226 行的 index 映射（如果你的 TTC 顺序不同）
- 调整第 134 行和 120 行的 `postScriptName` 模板（如果你的字体 postScriptName 命名规则不同）
- 同步修改 `action.sh` 第 306-345 行和 `lib/awk.sh` 第 63-75 行的 CJK 生成逻辑

**如果你替换的 CJK 字体是静态单文件（如单个 TTF/OTF，不区分语言）：**
- 将文件放入 `system/fonts/`，重命名为 `NotoSansCJK-Regular.ttc`
- 简化 `generate_cjk_sans_xml()` 为无语言区分的单条目
- 删除 `for LANG_TAG` 循环，只保留一个 `<family>` 块

### 场景 D：仅替换部分字体，保留其他

本模块的字体替换是独立分区的。你可以只替换其中一个分类，删除不需要的字体文件即可：

| 你想保留原样 | 删除/跳过 |
|---|---|
| Latin 无衬线（sans-serif） | 删除 `customize.sh` 第 198-200 行的 sans-serif 替换逻辑，或直接删除 `system/fonts/GoogleSansFlex-Regular.ttf`（模块会跳过不存在的文件） |
| Latin 衬线（serif） | 删除 `system/fonts/NotoSerif-VF.ttf` 和 `NotoSerif-Italic-VF.ttf` |
| Latin 等宽（monospace） | 删除 `system/fonts/NotoSansMono-VF.ttf` |
| CJK | 删除 `system/fonts/NotoSansCJK-VF.otf.ttc` 和 `NotoSerifCJK-VF.otf.ttc` |
| Unicode 补全 & Emoji | 删除 `config/fonts_fragment.xml` 或删除 `system/fonts/` 下对应 Unicode 字体文件 |

注意：`customize.sh` 第 203-213 行对 serif 和 monospace 做了 `-f` 文件存在性检查，若文件不存在则自动跳过替换。这是本模块的"安全设计"——除非你要彻底删除该分类的 XML 注入逻辑，否则留空即可。

## 三、修改模块信息

修改项目根目录下的 `module.prop`：

```
id=你的模块唯一ID（必须全局唯一，推荐格式：作者名_模块名）
name=显示名称
version=版本号
versionCode=版本号整数（每次递增）
author=作者名
description=简短描述
```

**id 命名规则：** 不要使用 `google_sans_max`，建议使用 `你的github用户名_字体名`。如 `myuser_inter_font`。避免与已有模块冲突。

## 四、修改 XML 生成逻辑（核心步骤）

本项目涉及 **3 个文件** 需要同步修改，它们都包含相同的 XML 生成逻辑：

| 文件 | 用途 | 修改要点 |
|---|---|---|
| `customize.sh` | **安装时** patch 系统 fonts.xml | 修改所有 `generate_xxx_xml` 函数、`WEIGHTS` 变量、CJK 语言映射 |
| `action.sh` | **运行时热更新** 重新 patch XML | 修改第 280-345 行的字重循环和字体名 |
| `lib/awk.sh` | **font_fallback.xml**（Android 15+）patch 逻辑 | 修改 `patch_font_fallback()` 函数中的字体名和字重范围 |

**修改检查清单：**

- [ ] 字体文件名已放入 `system/fonts/` 并正确命名
- [ ] `customize.sh` 中所有 `generate_xxx_xml` 函数的字体引用已更新
- [ ] `customize.sh` 中 `WEIGHTS` 变量范围正确
- [ ] `customize.sh` 中 italic 条目根据字体能力保留或删除
- [ ] `customize.sh` 中 CJK 的 TTC index、postScriptName、语言映射已更新
- [ ] `action.sh` 中所有的字体名和字重逻辑同步修改
- [ ] `lib/awk.sh` 中 `patch_font_fallback()` 的字体名和字重逻辑同步修改
- [ ] `lib/awk.sh` 中 `generate_fb_cjk_payload()` 的 CJK 参数同步修改
- [ ] `config/fonts_fragment.xml` 中的 Unicode 字体引用已更新（如不需要 Unicode 补全则删除此文件）

## 五、修改构建脚本（如需自动下载字体）

如果你希望 GitHub Actions 自动下载字体文件，而非将字体直接提交到仓库，请修改：

- `.github/workflows/release.yml` — 添加或修改 `wget`/`curl` 下载命令
- `scripts/gen_manifest.sh` — 如果修改了文件结构，需同步更新 manifest 生成逻辑

注意：如果工作流文件不存在，说明仓库未启用 CI。你仍然可以手动构建：在本地运行 `zip -r9 模块名.zip . -x ".git/*"` 打包。

## 六、发布属于你的版本

在 GitHub 的 Releases 页面发布一个新的 Tag（如 `v1.0.0`），即可自动触发 Actions 构建并打包发布你的 ZIP 文件。你也可以手动打包：

```bash
# 在项目根目录执行
zip -r9 MyFontModule.zip . -x ".git/*" ".github/*" "references/*" "banner.png" "launcher.png" "README*.md"
```

## 七、常见问题

**Q：我只想替换一个字体（比如只换 CJK 衬线），该怎么做？**
A：保留 `system/fonts/` 下你需要的字体文件和所有脚本文件不变，删除不需要的字体文件即可。模块启动时会检查文件存在性，自动跳过不存在的字体分类。

**Q：我的字体文件是 `.otf` 格式，需要改什么？**
A：Windows 上 OTF 与 TTF 可互换使用。在 `customize.sh`、`action.sh`、`lib/awk.sh` 中将所有 `.ttf` 替换为 `.otf`（或保持原名，只需与放入 `system/fonts/` 的文件名一致）。

**Q：我的字体只有 400 和 700 两个字重，怎么配置？**
A：修改 `customize.sh` 第 64 行的 `WEIGHTS` 为 `"400 700"`，并修改对应 `generate_xxx_xml` 函数只输出这两个字重的条目。不存在的字重系统会自动 fallback 到最近的可用字重。

**Q：修改后刷入总是失败/模块不生效，如何排查？**
A：1) 检查安装日志（Magisk 管理器 → 模块 → 点击模块查看日志）；2) 确认 `system/fonts/` 下的字体文件权限为 644；3) 在设备上执行 `dumpsys fonts` 查看系统当前注册的字体列表；4) 检查 `module.prop` 的 `id` 是否与其他模块冲突。

**Q：我只想保留本项目的 Unicode 补全和 Emoji 功能，但换成我自己的字体，可以吗？**
A：可以。保留 `config/fonts_fragment.xml`、`lib/`、`lib/lib.sh` 等 Unicode 相关文件不变，只替换 `system/fonts/` 下的主字体文件。但注意：`fonts_fragment.xml` 中引用的 Unicode fallback 字体文件（如 `PlangothicP1-Regular.otf`）如果不需要可以删除，同时从 XML 中移除对应 `<family>` 块。

**Q：为什么修改后 italic 字体不生效？**
A：本模块的 italic 在 VF 模式下通过 `slnt` 轴（slant）模拟。如果你的 VF 字体没有 `slnt` 轴，也没有独立的 italic 文件，需要删除 XML 生成函数中 `style="italic"` 的所有行。否则系统会尝试加载不存在的轴值导致渲染异常。

**Q：中文/日文/韩文的语言映射（INDEX / postScriptName）是如何确定的？**
A：对于 `NotoSansCJK-VF.otf.ttc`，其标准顺序为：index 0=日语（jp）、1=韩语（kr）、2=简体中文（sc）、3=繁体中文（tc）。如果你替换为其他 TTC 字体，需运行 `python -c "from fontTools.ttLib import TTFont; f=TTFont('your.ttc', fontNumber=0); print(f['name'].getDebugName(6))"` 查看每个 index 对应的语言名称，然后调整 `customize.sh` 第 222-226 行的 `case` 映射。
