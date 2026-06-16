## What's New in v1.4.4

- `4c04ad9` bump version: v1.4.3 → v1.4.4
- `142d32f` fix: use static NotoSansCJK-Regular.ttc for Firefox fallback (non-VF, non-TTC-index)
- `f004a60` fix: simplify Firefox CJK fallback to bare VF entry (no axis tags)
- `db32cb2` fix: use correct closing tag </familyset> for font_fallback.xml
- `b9c5349` fix: add lang-less CJK VF fallback directly in font_fallback.xml patch
- `d1849ec` fix: add lang-less CJK VF fallback for Firefox (Gecko engine)
- `3675d18` fix: regenerate favicon.ico with multi-res, add favicon.png fallback
- `19bba31` Revert "fix: use absolute path /favicon.ico in index.html"
- `b34f279` fix: use absolute path /favicon.ico in index.html
- `6fdb52f` fix: replace empty update-binary with proper Magisk installer script
- `46785fd` feat: add META-INF for Magisk compatibility
- `ddcecaa` feat: detect conflicting font modules before install
- `d7d272f` fix: remove customize.sh from CI manifest (deleted after install)
- `d54ee7a` feat: add launcher.png, favicon.ico; include launcher.png in CI manifest
- `ff96ff6` docs: remove 100/200 weight fix mentions from module.prop and READMEs
- `0350ace` feat: action.sh hot update now deletes stale files
- `a61f9c8` chore: update font manifest [skip ci]
- `84fdd7b` cleanup: remove redundant font size validation step
