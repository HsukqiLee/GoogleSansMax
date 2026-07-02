# Copyright (C) 2025 Hsukqi Lee <https://github.com/HsukqiLee>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

"""Strip problematic cmap entries from Unicode fallback fonts.

NotoSansSuper.otf (and similar coverage fonts) include cmap entries for a
vast range of common symbols, but map them to empty glyphs (CFF charstrings
with program length 0). When Android's Minikin renderer encounters such a
character, it finds a cmap hit in the fallback font and renders an empty
box instead of continuing to a font with a real glyph.

This script removes those cmap entries by Unicode block range, forcing the
renderer to fall back further in the chain to fonts with real glyphs.
"""
import os
import sys
from fontTools import ttLib

# Unicode block ranges to strip from coverage fonts.
BLOCK_RANGES = [
    # --- Punctuation & Spaces ---
    (0x2000, 0x206F),   # General Punctuation
    (0x2070, 0x209F),   # Superscripts and Subscripts
    (0x20A0, 0x20CF),   # Currency Symbols
    (0x20D0, 0x20FF),   # Combining Diacritical Marks for Symbols
    (0x2100, 0x214F),   # Letterlike Symbols
    (0x2150, 0x218F),   # Number Forms
    (0x2E00, 0x2E7F),   # Supplemental Punctuation
    # --- Arrows ---
    (0x2190, 0x21FF),   # Arrows
    (0x27F0, 0x27FF),   # Supplemental Arrows-A
    (0x2900, 0x297F),   # Supplemental Arrows-B
    (0x2B00, 0x2BFF),   # Miscellaneous Symbols and Arrows
    (0x1F800, 0x1F8FF),  # Supplemental Arrows-C
    # --- Math ---
    (0x2200, 0x22FF),   # Mathematical Operators
    (0x27C0, 0x27EF),   # Miscellaneous Mathematical Symbols-A
    (0x2980, 0x29FF),   # Miscellaneous Mathematical Symbols-B
    (0x2A00, 0x2AFF),   # Supplemental Mathematical Operators
    # --- Technical / UI ---
    (0x2300, 0x23FF),   # Miscellaneous Technical
    (0x2400, 0x243F),   # Control Pictures
    (0x2440, 0x245F),   # Optical Character Recognition (OCR)
    (0x2460, 0x24FF),   # Enclosed Alphanumerics
    # --- Box Drawing / Block Elements ---
    (0x2500, 0x257F),   # Box Drawing
    (0x2580, 0x259F),   # Block Elements
    # --- Geometric Shapes ---
    (0x25A0, 0x25FF),   # Geometric Shapes (includes U+25D4)
    (0x1F780, 0x1F7FF),  # Geometric Shapes Extended
    # --- Miscellaneous Symbols ---
    (0x2600, 0x26FF),   # Miscellaneous Symbols
    (0x2700, 0x27BF),   # Dingbats
    (0x1F300, 0x1F5FF),  # Miscellaneous Symbols and Pictographs
    (0x1F650, 0x1F67F),  # Ornamental Dingbats
    # --- Games / Cards ---
    (0x1F000, 0x1F02F),  # Mahjong Tiles
    (0x1F030, 0x1F09F),  # Domino Tiles
    (0x1F0A0, 0x1F0FF),  # Playing Cards
    (0x1FA00, 0x1FA6F),  # Chess Symbols
    # --- Other Symbol Extensions ---
    (0x1F700, 0x1F77F),  # Alchemical Symbols
    (0x1FA70, 0x1FAFF),  # Symbols and Pictographs Extended-A
    (0x1FB00, 0x1FBFF),  # Symbols and Pictographs Extended-B
    # --- CJK Symbols & Punctuation ---
    (0x3000, 0x303F),   # CJK Symbols and Punctuation
    # --- Modifier / Phonetic ---
    (0x02B0, 0x02FF),   # Spacing Modifier Letters
    (0x0300, 0x036F),   # Combining Diacritical Marks
    # --- All printable ASCII (0x21-0x7E) ---
    (0x0021, 0x007E),   # !"#$%&'()*+,-./0-9:;<=>?@A-Z[\]^_`a-z{|}~
    # --- Brahmic numerals & symbols ---
    (0x1F100, 0x1F1FF),  # Enclosed Alphanumeric Supplement
    # --- Braille ---
    (0x2800, 0x28FF),   # Braille Patterns
]

# Precompute a flat set of all target codepoints for fast lookup.
BLOCK_CODEPOINTS = set()
for lo, hi in BLOCK_RANGES:
    BLOCK_CODEPOINTS.update(range(lo, hi + 1))


def _glyph_has_contours(font, glyph_name):
    if not glyph_name:
        return False
    if 'CFF ' in font or 'CFF2' in font:
        top_key = 'CFF2' if 'CFF2' in font else 'CFF '
        td = font[top_key].cff.topDictIndex[0]
        try:
            cs = td.CharStrings[glyph_name]
            return len(cs.program) > 0
        except KeyError:
            return False
    if 'glyf' in font:
        try:
            glyph = font['glyf'][glyph_name]
        except (KeyError, TypeError):
            return False
        if glyph.numberOfContours > 0:
            return True
        if getattr(glyph, 'components', None):
            return True
        return False
    return True


def _is_empty_glyph(font, glyph_name):
    return not _glyph_has_contours(font, glyph_name)


def _resolve_glyph_name(font, cmap_val, glyph_order):
    if isinstance(cmap_val, str):
        return cmap_val
    if glyph_order and cmap_val < len(glyph_order):
        return glyph_order[cmap_val]
    return None


def _strip_font(font):
    if 'cmap' not in font:
        return False
    modified = False
    glyph_order = font.getGlyphOrder() if 'glyf' in font else None
    for subtable in font['cmap'].tables:
        if not hasattr(subtable, 'cmap'):
            continue
        for cp in BLOCK_CODEPOINTS:
            if cp not in subtable.cmap:
                continue
            glyph_name = _resolve_glyph_name(font, subtable.cmap[cp], glyph_order)
            if _is_empty_glyph(font, glyph_name):
                del subtable.cmap[cp]
                modified = True
    return modified


def strip_font(path):
    """Strip empty cmap entries from a single font or TTC file."""
    ext = os.path.splitext(path)[1].lower()
    if ext != '.ttc':
        font = ttLib.TTFont(path)
        if _strip_font(font):
            font.save(path)
            return True
        return False
    # TTC: iterate sub-fonts 0..N-1
    from fontTools.ttLib import TTCollection
    tc = TTCollection(path)
    modified = False
    n = len(tc.fonts)
    for i in range(n):
        print(f"    [{i+1}/{n}] Processing sub-font {i}...", file=sys.stderr)
        if _strip_font(tc.fonts[i]):
            modified = True
    if modified:
        print(f"    Saving modified TTC (may take 1-2 min)...", file=sys.stderr)
        tc.save(path)
    return modified


def main():
    if len(sys.argv) < 2:
        print("Usage: python strip_font_cmap.py <path> [path2 ...]")
        print("       <path> can be a single font file or a directory")
        sys.exit(1)

    targets = []
    for arg in sys.argv[1:]:
        if os.path.isdir(arg):
            for f in sorted(os.listdir(arg)):
                if f.lower().endswith(('.ttf', '.otf', '.ttc')):
                    targets.append(os.path.join(arg, f))
        else:
            targets.append(arg)

    for path in targets:
        try:
            if strip_font(path):
                print(f"  Stripped: {path}")
            else:
                print(f"  Skipped (no matching entries): {path}")
        except Exception as e:
            print(f"  ERROR: {path}: {e}")


if __name__ == '__main__':
    main()
