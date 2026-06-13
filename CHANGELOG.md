## What's New in v1.3.1

- fix(module.prop): add `action=action.sh` — Magisk/KSU action button now works
- fix(install): abort if critical VF fonts are corrupted (< 100KB) — prevents bootloop from broken builds
- fix(release): download NotoSerif-Italic-VF.ttf (was missing from build)
- fix(release): NotoSansMono VF download switched to notofonts direct URL (Google Fonts CSS returned WOFF2)
- fix(release): add minimum size validation (100KB) with `exit 1` on failure for all VF fonts
- fix(release): add missing Japanese (jp) CJK Black static font downloads
- fix(sync_unicode): preserve *.sh files (customize.sh, action.sh, service.sh) during upstream sync

## What's New in v1.3.0

### Critical fixes — CJK serif in apps + broken VF fonts

- fix(font_fallback): merge CJK sans+serif into single `<family>` block per language
  - `font_fallback.xml` parser picks only the first matching `<family lang>` block; separate sans/serif blocks meant serif CJK was unreachable in apps
  - `generate_fb_cjk_payload()` now outputs one merged block: sans 100-900 + serif 200-900 (`fallbackFor="serif"`)
  - `replace_cjk_family()` Phase 2 removes leftover serif-only `<family>` blocks from old two-block layout
  - Affects: zh-Hans, zh-Hant, ko, ja — all now use merged CJK families
- fix(fonts): replace broken NotoSerif-VF.ttf (33KB → 3.4MB) and NotoSansMono-VF.ttf (389KB → 1.5MB)
  - Old files were thin-only stubs; weight requests beyond ~400 fell back to DroidSerif/DroidSansMono
  - New files downloaded from `notofonts/noto-fonts` repo with full wght 100-900 range
- fix(fonts): italic serif uses NotoSerif-Italic-VF.ttf (2MB) — NotoSerif-VF.ttf has no `ital` axis
- fix: remove monospace italic entries — NotoSansMono has no slant axis; italic falls through to sans-serif italic (matches AOSP DroidSansMono behavior)
- fix: inject Unicode font set fragment into font_fallback.xml (was only in fonts.xml; modern apps read font_fallback.xml)
- fix(action.sh): re-inject Unicode fragment after every repatch + fix SELinux context
- fix(sync_unicode.yml): preserve lib/awk.sh when syncing from upstream (prevents losing CJK merge logic)
- fix: expand serif aliases — serif-bold(700) → full chain (thin/light/medium/semi-bold/bold/black)
- fix: `supportedAxes="wght"` only (AOSP V+ parser rejects slnt)

### Other

- fix(webui): MD3 polish — italic, slider, tabs, charset
  - Enable italic display for Mono and CJK weight grids
  - Fix compare tab showing `[object HTMLSpanElement]` instead of Italic chip
  - Redesign slider to proper MD3: custom track with fill gradient + 20px circular thumb
  - Make tabs scrollable instead of equal-width stretch on narrow screens
  - Fix charset tab default active chip not matching (`latin` vs `Latin`)
  - Style CJK Sample separator as MD3 overline label
- fix(webui): pass app arg to render functions + remove stray max= assignment
- fix(webui): remove double-blue on active nav + add slider labels
- fix(font_fallback): resolve boot timeout and SELinux context for font_fallback.xml overlay
  - Added sepolicy.rule for init to relabel font_fallback.xml to system_font_fallback_file
  - Added chcon/setfattr during install and repatch for correct SELinux context

## What's New in v1.2.2

- `0f17197` fix: backup reads from mirror/system paths, repatch always starts fresh
- `1ff6d7d` fix: backup XML uses hardcoded paths instead of undefined variables
- `2277d09` refactor(webui): simplify architecture, add italic preview, sliding nav
- `b9752d7` chore: update font manifest [skip ci]
- `001626d` chore: auto-bump version and update JSONs to v1.2.1 [skip ci]
