# How to Create Your Own Font Module Based on This Repo

This project is set as a Public Template. You can Fork this repository to quickly build your own Magisk / KernelSU font module, while enjoying the advanced XML parsing/injection technology and hot-update mechanism of this project.

## 1. Understanding the Font Types Used by This Project

This project uses **Variable Fonts (VF)** with the `wght` axis for weight mapping by default. First, determine which type your font is:

| Your Font Type | Can You Just Rename? | Additional Changes Needed |
|---|---|---|
| **Variable Font (VF)** with `wght` axis covering 100-900 (or 100-1000), supports normal + italic | ✅ Yes, just rename | Adjust weight range if different |
| **Variable Font (VF)** but lacks italic, or `wght` axis range differs | ✅ Yes, just rename | Modify weight ranges and italic logic in `customize.sh` / `action.sh` / `lib/awk.sh` |
| **Static Fonts**, one file per weight (e.g., `MyFont-Thin.ttf`, `MyFont-Bold.ttf`) | ❌ Cannot directly replace | Must rewrite `generate_xxx_xml` functions for static weight mapping |
| **TTC Collection** (e.g., `NotoSansCJK-VF.otf.ttc` multi-language collection) | ⚠️ Proceed with caution | Must ensure correct TTC index, postScriptName, and language mapping |
| **Replace CJK only**, keep Latin | ⚠️ Partial replacement possible | Only replace Noto CJK fonts, keep GoogleSansFlex untouched |

### How to check if a font is a Variable Font?

Run the following commands (requires `fonttools`):

```bash
# Check if the font has an fvar table (Variable Font indicator)
python -c "from fontTools.ttLib import TTFont; f=TTFont('your-font.ttf'); print('fvar' in f)"

# Check wght axis range
python -c "from fontTools.ttLib import TTFont; f=TTFont('your-font.ttf'); axis=[a for a in f['fvar'].axes if a.axisTag=='wght'][0]; print(f'wght range: {axis.minValue}-{axis.maxValue}')"
```

## 2. Replacing Font Files (Scenario-by-Scenario)

### Scenario A: Your Font is a Variable Font (Recommended, Easiest)

**Requirements:** Font contains `fvar` table, `wght` axis range covers 100-900 (or close).

**Steps:**

1. Place your VF font file into `system/fonts/`
2. Rename it to match the original module filename. For example, to replace the Latin sans-serif, name it `GoogleSansFlex-Regular.ttf`
3. Check if your font supports italic (`slnt` axis or a separate italic file). If not, remove italic entries from the XML generation functions
4. Check your font's `wght` range. If it is smaller than 100-1000, adjust the `WEIGHTS` variable in `customize.sh` (line 64)

**Example:** Replace Latin sans-serif with `Inter-VF.ttf` (VF, wght 100-900, no italic)
- Rename `Inter-VF.ttf` → `GoogleSansFlex-Regular.ttf` into `system/fonts/`
- Modify `customize.sh` line 64: `WEIGHTS="100 200 300 400 500 600 700 800 900"` (remove 1000)
- Modify `generate_sans_serif_xml()` in `customize.sh` to delete italic lines (line 79)
- Apply the same changes in `action.sh` and `lib/awk.sh` for the sans-serif generation logic

### Scenario B: Your Font is Static (One File Per Weight)

Font filenames contain weight indicators, e.g., `MyFont-Regular.ttf` (weight 400), `MyFont-Bold.ttf` (weight 700)

You need to change `generate_sans_serif_xml()` from VF mode to static mode. Example:

```bash
# Before (VF mode)
generate_sans_serif_xml() {
    local OUT="$1"
    echo '    <family name="sans-serif">' > "$OUT"
    for W in $WEIGHTS; do
        echo "        <font weight=\"$W\" style=\"normal\">GoogleSansFlex-Regular.ttf<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$OUT"
        echo "        <font weight=\"$W\" style=\"italic\">GoogleSansFlex-Regular.ttf<axis tag=\"wght\" stylevalue=\"$W\" /><axis tag=\"slnt\" stylevalue=\"-10\" /></font>" >> "$OUT"
    done
    echo '    </family>' >> "$OUT"
}

# After (static mode, one file per weight, files named MyFont-{weight}.ttf)
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

**Files that MUST be updated together (3 total):**
- `customize.sh` — `generate_sans_serif_xml()` (lines 74-82), `generate_serif_xml()` (lines 99-107), `generate_mono_xml()` (lines 87-94)
- `action.sh` — lines 280-303 (sans-serif, serif, monospace generation logic)
- `lib/awk.sh` — `patch_font_fallback()` sans-serif (lines 25-32), serif (lines 37-44), monospace (lines 53-59) generation logic

### Scenario C: Replacing CJK Fonts

CJK fonts are more complex than Latin due to:
- **TTC index**: `NotoSansCJK-VF.otf.ttc` is a TTC collection where index 0=Japanese, 1=Korean, 2=Simplified Chinese, 3=Traditional Chinese
- **postScriptName**: XML generation requires `postScriptName="NotoSansCJK${LANG_PREFIX}-Thin"`, where `LANG_PREFIX` is `jp`/`kr`/`sc`/`tc`
- **Language mapping**: The `case` statement at `customize.sh` lines 222-226 maps `LANG_TAG` → `INDEX` + `LANG_PREFIX`

**If your CJK font is ALSO a TTC VF collection:**
- Place the file in `system/fonts/`, rename to `NotoSansCJK-VF.otf.ttc`
- Adjust index mapping at `customize.sh` lines 222-226 (if your TTC order differs)
- Adjust `postScriptName` templates at lines 134 and 120 (if your naming convention differs)
- Synchronize changes in `action.sh` lines 306-345 and `lib/awk.sh` lines 63-75

**If your CJK font is a static single file (e.g., a single TTF/OTF, no language distinction):**
- Place the file in `system/fonts/`, rename to `NotoSansCJK-Regular.ttc`
- Simplify `generate_cjk_sans_xml()` to a single entry without language loops
- Remove the `for LANG_TAG` loop and keep a single `<family>` block

### Scenario D: Replace Only Some Fonts, Keep Others

This module's font replacement is independent per category. You can replace only one category by deleting the font files you don't need:

| To Keep Original | Delete / Skip |
|---|---|
| Latin sans-serif | Delete the sans-serif replacement logic at `customize.sh` lines 198-200, or delete `system/fonts/GoogleSansFlex-Regular.ttf` (module will skip missing files) |
| Latin serif | Delete `system/fonts/NotoSerif-VF.ttf` and `NotoSerif-Italic-VF.ttf` |
| Latin monospace | Delete `system/fonts/NotoSansMono-VF.ttf` |
| CJK | Delete `system/fonts/NotoSansCJK-VF.otf.ttc` and `NotoSerifCJK-VF.otf.ttc` |
| Unicode Completion & Emoji | Delete `config/fonts_fragment.xml` or delete corresponding Unicode font files under `system/fonts/` |

Note: Lines 203-213 in `customize.sh` perform `-f` file existence checks for serif and monospace — if the file doesn't exist, the replacement is automatically skipped. This is a "safe-by-design" feature.

## 3. Update Module Properties

Edit `module.prop` in the project root:

```
id=your-unique-module-id (must be globally unique, recommended format: author_module_name)
name=Display name
version=Version string
versionCode=Integer version code (increment each release)
author=Your name
description=Short description
```

**id naming rules:** Do NOT use `google_sans_max`. Use a format like `your_github_username_font_name` (e.g., `myuser_inter_font`). Avoid conflicts with existing modules.

## 4. Modify XML Generation Logic (Core Step)

This project involves **3 files** that must be updated together. They all contain the same XML generation logic:

| File | Purpose | Key Changes |
|---|---|---|
| `customize.sh` | Patches system fonts.xml **during installation** | Modify all `generate_xxx_xml` functions, `WEIGHTS` variable, CJK language mapping |
| `action.sh` | Re-patches XML **at runtime** (hot update) | Modify weight loops and font names at lines 280-345 |
| `lib/awk.sh` | **font_fallback.xml** (Android 15+) patch logic | Modify font names and weight ranges in `patch_font_fallback()` |

**Modification Checklist:**

- [ ] Font files placed in `system/fonts/` with correct names
- [ ] All `generate_xxx_xml` functions in `customize.sh` updated with new font references
- [ ] `WEIGHTS` variable in `customize.sh` matches your font's weight range
- [ ] Italic entries kept or removed based on font capabilities
- [ ] CJK TTC index, postScriptName, and language mappings updated
- [ ] `action.sh` font names and weight logic synced
- [ ] `lib/awk.sh` `patch_font_fallback()` font names and weight logic synced
- [ ] `lib/awk.sh` `generate_fb_cjk_payload()` CJK parameters synced
- [ ] `config/fonts_fragment.xml` Unicode font references updated (delete file if not needed)

## 5. Modify Build Scripts (Optional)

If you want GitHub Actions to automatically download font files instead of committing them to the repo:

- `.github/workflows/release.yml` — Add or modify `wget`/`curl` download commands
- `scripts/gen_manifest.sh` — Sync manifest generation if file structure changed

If workflow files don't exist, CI is not enabled. You can still build manually:

```bash
# Run from project root
zip -r9 MyFontModule.zip . -x ".git/*" ".github/*" "references/*" "banner.png" "launcher.png" "README*.md"
```

## 6. Publish Your Release

Publish a new Tag (e.g., `v1.0.0`) on the GitHub Releases page to trigger automated Actions build and package your ZIP. To build manually:

```bash
zip -r9 MyFontModule.zip . -x ".git/*" ".github/*" "references/*" "banner.png" "launcher.png" "README*.md"
```

## 7. Frequently Asked Questions

**Q: I only want to replace one font category (e.g., CJK serif only). What should I do?**
A: Keep the font files you need in `system/fonts/` and all scripts unchanged. Delete the font files you don't want to replace. The module checks for file existence at install time and skips missing font categories automatically.

**Q: My font files are `.otf` format. What do I need to change?**
A: OTF and TTF are interchangeable on Android. Replace all `.ttf` references with `.otf` in `customize.sh`, `action.sh`, and `lib/awk.sh` — or simply keep the original filenames and just match the names you put in `system/fonts/`.

**Q: My font only has weights 400 and 700. How do I configure it?**
A: Change `WEIGHTS` at `customize.sh` line 64 to `"400 700"` and modify the corresponding `generate_xxx_xml` functions to output only those two weight entries. For any missing weight, the system will automatically fall back to the nearest available weight.

**Q: The module fails after flashing / doesn't take effect. How to debug?**
A: 1) Check install logs (Magisk Manager → Modules → tap the module → view log); 2) Verify font file permissions in `system/fonts/` are 644; 3) Run `dumpsys fonts` on device to see registered fonts; 4) Check `module.prop` `id` for conflicts with other modules.

**Q: I want to keep the Unicode completion and Emoji features, but use my own main font. Is that possible?**
A: Yes. Keep `config/fonts_fragment.xml`, `lib/`, `lib/lib.sh` and related Unicode files. Only replace the main font files in `system/fonts/`. However, if you don't need the Unicode fallback fonts referenced in `fonts_fragment.xml` (like `PlangothicP1-Regular.otf`), you can delete them and remove the corresponding `<family>` blocks from the XML.

**Q: Why doesn't italic work after my modifications?**
A: This module simulates italic via the `slnt` axis (slant) in VF mode. If your VF font lacks a `slnt` axis and has no separate italic file, you must delete all lines with `style="italic"` from the XML generation functions. Otherwise, the system will try to load a non-existent axis value, causing rendering issues.

**Q: How are the CJK language mappings (INDEX / postScriptName) determined?**
A: For `NotoSansCJK-VF.otf.ttc`, the standard order is: index 0=Japanese (jp), 1=Korean (kr), 2=Simplified Chinese (sc), 3=Traditional Chinese (tc). If replacing with a different TTC font, run `python -c "from fontTools.ttLib import TTFont; f=TTFont('your.ttc', fontNumber=0); print(f['name'].getDebugName(6))"` for each index to identify the language, then adjust the `case` mapping at `customize.sh` lines 222-226 accordingly.
