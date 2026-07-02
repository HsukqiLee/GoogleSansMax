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

"""Strip cmap entries from coverage fonts where real glyphs exist elsewhere.

Two-pass approach:
  Pass 1 — scan ALL font files in the build directory. For every cmap entry
    check if the target glyph has real drawing instructions. Build a set of
    codepoints that are "safe to strip" from coverage fonts because at least
    one non-coverage font has a real glyph.

  Pass 2 — for each coverage font (matching COVERAGE_FONT_PATTERNS), remove
    cmap entries whose glyph is empty in THIS font but a real glyph exists
    in another font.

This avoids the two failure modes of earlier block-range approaches:
  - Stripping empty entries with no real alternative (→ Last Resort font).
  - Keeping empty entries when a real glyph exists upstream (→ empty box).
"""
import os
import re
import sys
from fontTools import ttLib

COVERAGE_FONT_PATTERNS = [
    r'NotoSansSuper',
    r'NotoUnicode',
    r'LastResort',
]


# ---------------------------------------------------------------------------
# Glyph inspection helpers
# ---------------------------------------------------------------------------

def _glyph_has_contours(font, glyph_name):
    """True if `glyph_name` has actual drawing instructions."""
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


def _resolve_glyph_name(font, cmap_val, glyph_order):
    if isinstance(cmap_val, str):
        return cmap_val
    if glyph_order and cmap_val < len(glyph_order):
        return glyph_order[cmap_val]
    return None


def _iter_cmap(font):
    """Yield (codepoint, glyph_name) for every cmap entry."""
    if 'cmap' not in font:
        return
    glyph_order = font.getGlyphOrder() if 'glyf' in font else None
    for subtable in font['cmap'].tables:
        if not hasattr(subtable, 'cmap'):
            continue
        for cp, val in subtable.cmap.items():
            gname = _resolve_glyph_name(font, val, glyph_order)
            if gname:
                yield cp, gname


# ---------------------------------------------------------------------------
# Font loading helpers
# ---------------------------------------------------------------------------

def _is_coverage(fname):
    return any(re.search(p, fname) for p in COVERAGE_FONT_PATTERNS)


def _load_fonts(files):
    """Return list of (font, filename, filepath, is_ttc_subfont).

    For TTCs the fonts are extracted and returned individually; the caller
    must keep the TTCollection alive to save later.
    """
    entries = []   # (font, filename, save_path_or_None, is_ttc_sub)
    ttc_holder = []  # (TTCollection, filepath) — kept alive for save
    for path in files:
        fname = os.path.basename(path)
        if path.lower().endswith('.ttc'):
            tc = ttLib.TTCollection(path)
            ttc_holder.append((tc, path))
            for i in range(len(tc.fonts)):
                entries.append((tc.fonts[i], fname, path, True))
        else:
            font = ttLib.TTFont(path)
            entries.append((font, fname, path, False))
    return entries, ttc_holder


def _save_modified(entries, ttc_holder):
    """Save any font whose _stripped flag was set."""
    saved_any = False
    for font, fname, save_path, is_ttc in entries:
        if getattr(font, '_stripped', False) and not is_ttc:
            font.save(save_path)
            saved_any = True
    for tc, path in ttc_holder:
        needs_save = any(
            getattr(tc.fonts[i], '_stripped', False)
            for i in range(len(tc.fonts))
        )
        if needs_save:
            tc.save(path)
            saved_any = True
    return saved_any


# ---------------------------------------------------------------------------
# Pass 1 – build safe-codepoint set
# ---------------------------------------------------------------------------

def _collect_safe(entries):
    safe = {}
    for font, fname, _path, _is_ttc in entries:
        if _is_coverage(fname):
            continue
        for cp, gname in _iter_cmap(font):
            if _glyph_has_contours(font, gname):
                safe[cp] = True
    return safe


# ---------------------------------------------------------------------------
# Pass 2 – strip coverage fonts
# ---------------------------------------------------------------------------

def _strip_one(font, safe_cps):
    """Strip empty-glyph cmap entries for codepoints in safe_cps.

    Sets font._stripped = True if any entry was removed.
    """
    if 'cmap' not in font:
        return
    glyph_order = font.getGlyphOrder() if 'glyf' in font else None
    for subtable in font['cmap'].tables:
        if not hasattr(subtable, 'cmap'):
            continue
        to_del = []
        for cp, val in subtable.cmap.items():
            if cp not in safe_cps:
                continue
            gname = _resolve_glyph_name(font, val, glyph_order)
            if gname and not _glyph_has_contours(font, gname):
                to_del.append(cp)
        for cp in to_del:
            del subtable.cmap[cp]
            font._stripped = True


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def strip_all(path_or_dir):
    if os.path.isdir(path_or_dir):
        files = [
            os.path.join(path_or_dir, f)
            for f in sorted(os.listdir(path_or_dir))
            if f.lower().endswith(('.ttf', '.otf', '.ttc'))
        ]
    else:
        files = [path_or_dir]

    if not files:
        return

    entries, ttc_holder = _load_fonts(files)

    print("  Pass 1: scanning for real glyphs...", file=sys.stderr)
    safe = _collect_safe(entries)
    print(f"    {len(safe)} safe codepoints found.", file=sys.stderr)

    print("  Pass 2: stripping coverage fonts...", file=sys.stderr)
    for font, fname, _path, _is_ttc in entries:
        if _is_coverage(fname):
            dirname = os.path.basename(os.path.dirname(_path))
            _strip_one(font, safe)

    # Report and save
    for font, fname, save_path, is_ttc in entries:
        if getattr(font, '_stripped', False):
            print(f"  Stripped: {save_path}")
        else:
            if _is_coverage(fname) and not is_ttc:
                print(f"  Skipped (no matching entries): {save_path}")

    # Save TTCs
    for tc, path in ttc_holder:
        needs_save = any(
            getattr(tc.fonts[i], '_stripped', False)
            for i in range(len(tc.fonts))
        )
        if needs_save:
            print(f"    Saving TTC: {path} (may take 1-2 min)...", file=sys.stderr)
            tc.save(path)
            print(f"  Stripped: {path}")
        else:
            print(f"  Skipped (no matching entries): {path}")

    # Save non-TTC fonts
    for font, fname, save_path, is_ttc in entries:
        if getattr(font, '_stripped', False) and not is_ttc:
            font.save(save_path)


def main():
    if len(sys.argv) < 2:
        print("Usage: python strip_font_cmap.py <path> [path2 ...]")
        print("       <path> can be a single font file or a directory")
        sys.exit(1)
    for arg in sys.argv[1:]:
        strip_all(arg)


if __name__ == '__main__':
    main()
