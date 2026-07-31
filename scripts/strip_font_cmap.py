# Copyright (C) 2025 Hsukqi Lee <https://github.com/HsukqiLee>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
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

"""Strip empty coverage cmap entries when an earlier font has an outline.

The old CFF check read ``CharString.program`` before fontTools had
decompiled the bytecode.  The lazy program list is initially empty even for
real glyphs, so v1.5.x could treat valid entries as empty.  Drawing through
the fontTools glyph set resolves CFF subroutines and works for CFF and glyf.

Safety principle: remove a mapping only when the earlier provider has a real
outline and the target coverage font does not.  Do not delete whole Unicode
blocks or valid target glyphs: fallback may need a base and combining mark in
the same font even when the primary font already covers the base.
"""
import os
import re
import sys
from fontTools import ttLib
from fontTools.pens.recordingPen import RecordingPen

# Only fonts matching these patterns are processed.
COVERAGE_FONT_PATTERNS = [
    r'NotoSansSuper',
    r'NotoUnicode',
    r'LastResort',
]

PROVIDER_FONTS = [
    'GoogleSansFlex-Regular.ttf',
]

# v1.4.5 explicitly routed these punctuation marks back to the primary font.
# Keep this narrow compatibility rule; do not expand it to whole blocks.
PRIMARY_OVERRIDE_CODEPOINTS = {
    0x0021,  # !
    0x002C,  # ,
    0x002D,  # -
    0x002E,  # .
    0x003A,  # :
    0x003B,  # ;
    0x003F,  # ?
}


def _glyph_has_contours(font, glyph_name):
    """True if drawing the glyph emits at least one outline segment."""
    if not glyph_name:
        return False
    try:
        glyph = font.getGlyphSet()[glyph_name]
    except (KeyError, TypeError):
        return False
    pen = RecordingPen()
    glyph.draw(pen)
    return any(
        operation in {'lineTo', 'curveTo', 'qCurveTo', 'addComponent'}
        for operation, _ in pen.value
    )


def _resolve_glyph_name(font, cmap_val, glyph_order):
    if isinstance(cmap_val, str):
        return cmap_val
    if glyph_order and cmap_val < len(glyph_order):
        return glyph_order[cmap_val]
    return None


def _is_coverage(fname):
    return any(re.search(p, fname) for p in COVERAGE_FONT_PATTERNS)


def _real_codepoints(font):
    if 'cmap' not in font:
        return set()
    glyph_order = font.getGlyphOrder() if 'glyf' in font else None
    result = set()
    for subtable in font['cmap'].tables:
        if not subtable.isUnicode():
            continue
        for cp, value in subtable.cmap.items():
            glyph_name = _resolve_glyph_name(font, value, glyph_order)
            if _glyph_has_contours(font, glyph_name):
                result.add(cp)
    return result


def _strip_font(font, safe_codepoints=frozenset()):
    """Strip empty cmap entries with a verified earlier provider.
    Returns True if any entry was removed."""
    if 'cmap' not in font:
        return False
    modified = False
    glyph_order = font.getGlyphOrder() if 'glyf' in font else None
    for subtable in font['cmap'].tables:
        if not hasattr(subtable, 'cmap'):
            continue
        to_del = []
        for cp in subtable.cmap:
            if cp not in safe_codepoints:
                continue
            glyph_name = _resolve_glyph_name(
                font, subtable.cmap[cp], glyph_order
            )
            if cp in PRIMARY_OVERRIDE_CODEPOINTS or (
                glyph_name and not _glyph_has_contours(font, glyph_name)
            ):
                to_del.append(cp)
        for cp in to_del:
            del subtable.cmap[cp]
            modified = True
    return modified


def strip_font(path, safe_codepoints=frozenset()):
    """Strip from a single font file (or TTC).  Returns True if modified."""
    if not path.lower().endswith('.ttc'):
        font = ttLib.TTFont(path)
        if _strip_font(font, safe_codepoints):
            font.save(path)
            return True
        return False

    # TTC
    from fontTools.ttLib import TTCollection
    tc = TTCollection(path)
    modified = False
    n = len(tc.fonts)
    for i in range(n):
        print(f"    [{i + 1}/{n}] Sub-font {i}...", file=sys.stderr)
        if _strip_font(tc.fonts[i], safe_codepoints):
            modified = True
    if modified:
        print(f"    Saving TTC...", file=sys.stderr)
        tc.save(path)
    return modified


def main():
    if len(sys.argv) < 2:
        print("Usage: python strip_font_cmap.py <path> [path2 ...]")
        print("       <path> can be a single font file or a directory")
        print()
        print("Only coverage fonts (matching COVERAGE_FONT_PATTERNS) are processed.")
        sys.exit(1)

    targets = []
    for arg in sys.argv[1:]:
        if os.path.isdir(arg):
            for f in sorted(os.listdir(arg)):
                if f.lower().endswith(('.ttf', '.otf', '.ttc')):
                    targets.append((os.path.join(arg, f), f))
        else:
            targets.append((arg, os.path.basename(arg)))

    safe_codepoints = set()
    for path, fname in targets:
        if fname not in PROVIDER_FONTS:
            continue
        provider = ttLib.TTFont(path)
        provider_codepoints = _real_codepoints(provider)
        safe_codepoints.update(provider_codepoints)
        print(
            f"  Provider: {path} "
            f"({len(provider_codepoints)} real codepoints)"
        )

    for path, fname in targets:
        if not _is_coverage(fname):
            print(f"  Skipped (not coverage): {path}")
            continue
        try:
            if strip_font(path, safe_codepoints):
                print(f"  Stripped: {path}")
            else:
                print(f"  Skipped (no empty entries): {path}")
        except Exception as e:
            print(f"  ERROR: {path}: {e}")


if __name__ == '__main__':
    main()
