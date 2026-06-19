# Weight Implementation Details

## Google Sans Flex (Latin Sans-Serif)

- Single variable font file with native `wght` axis supporting 1–1000
- Also supports `opsz` (6–144), `wdth` (25–151), `GRAD` (0–100), `slnt` (-10–0)
- fonts.xml declares 100–1000 across 10 standard weight tiers, mapped via `<axis tag="wght" stylevalue="N" />`
- Apps can use `fontVariationSettings` at runtime for any weight (1–1000)

## Latin Serif

- Noto Serif variable font with `wght` axis supporting 100–900
- Downloaded at CI build time from notofonts.github.io
- All weights mapped via `<axis tag="wght" stylevalue="N" />`
- Weight alias chain: serif-thin(100), serif-light(300), serif-medium(400), serif-semi-bold(500), serif-bold(700), serif-black(900)

## Noto Sans Mono (Latin Monospace)

- Downloaded at CI build time from Google Fonts
- `wght` axis supports 100–900 (native VF range), out-of-range values auto-clamped

## Noto CJK (Chinese/Japanese/Korean)

- VF `NotoSansCJK-VF.otf.ttc` covers 100–900, `NotoSerifCJK-VF.otf.ttc` covers 200–900
- CJK Black fonts have internal `usWeightClass=900`, identical to VF axis 900, so weight 1000 is not declared separately
- Languages covered: Japanese (ja), Korean (ko), Simplified Chinese (zh-Hans), Traditional Chinese (zh-Hant), Bopomofo (zh-Bopo)
- All CJK weights use unified `postScriptName`

## Emoji Engine

Automatically synchronizes the latest upstream resources during build-time, offering options between highly compatible CBDT (Bitmap) and high-definition lossless COLRv1 (Vector) Emoji standards.
- **Rare Character Completion**: Deeply integrates the core code of `UnicodeFontSet` to provide full Unicode character set fallback completion.
