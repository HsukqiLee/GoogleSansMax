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

"""Audit combining-mark fallback without modifying a device.

The audit approximates Minikin's combining-mark rollback: when the current
base font lacks a mark, Minikin may select a later font for the mark and move
the base into that run if the later font also covers the base.  The report
flags provider changes, base-size changes, and pairs that do not hit a real
OpenType MarkToBase anchor.
"""

import argparse
import json
import unicodedata
from dataclasses import dataclass
from pathlib import Path
from xml.etree import ElementTree

import uharfbuzz
from fontTools import unicodedata as font_unicode
from fontTools.pens.boundsPen import BoundsPen
from fontTools.ttLib import TTCollection, TTFont


OUTLINE_OPERATIONS = {"lineTo", "curveTo", "qCurveTo", "addComponent"}


def _font_filename(element):
    return (element.text or "").strip()


def _iter_mark_to_base_subtables(font):
    if "GPOS" not in font:
        return
    lookup_list = font["GPOS"].table.LookupList
    if lookup_list is None:
        return
    for lookup in lookup_list.Lookup:
        for subtable in lookup.SubTable:
            if lookup.LookupType == 4:
                yield subtable
            elif lookup.LookupType == 9 and subtable.ExtensionLookupType == 4:
                yield subtable.ExtSubTable


@dataclass
class FontFace:
    path: Path
    index: int
    family_index: int

    def __post_init__(self):
        if self.path.suffix.lower() == ".ttc":
            self.font = TTCollection(self.path).fonts[self.index]
        else:
            self.font = TTFont(self.path, fontNumber=self.index)
        self.cmap = self.font.getBestCmap() or {}
        self.glyph_set = self.font.getGlyphSet()
        self.glyph_order = self.font.getGlyphOrder()
        self.upem = self.font["head"].unitsPerEm
        self._bounds = {}
        self._mark_pairs = None
        self._hb_data = self.path.read_bytes()

    @property
    def label(self):
        suffix = f"#{self.index}" if self.index else ""
        return f"{self.path.name}{suffix}"

    def supports(self, codepoint):
        return codepoint in self.cmap

    def bounds(self, codepoint):
        if codepoint in self._bounds:
            return self._bounds[codepoint]
        glyph_name = self.cmap.get(codepoint)
        if not glyph_name:
            self._bounds[codepoint] = None
            return None
        pen = BoundsPen(self.glyph_set)
        self.glyph_set[glyph_name].draw(pen)
        self._bounds[codepoint] = pen.bounds
        return pen.bounds

    def glyph_bounds(self, glyph_id):
        key = ("glyph", glyph_id)
        if key in self._bounds:
            return self._bounds[key]
        glyph_name = self.glyph_order[glyph_id]
        pen = BoundsPen(self.glyph_set)
        self.glyph_set[glyph_name].draw(pen)
        self._bounds[key] = pen.bounds
        return pen.bounds

    def normalized_size(self, codepoint):
        bounds = self.bounds(codepoint)
        if not bounds:
            return None
        return (
            (bounds[2] - bounds[0]) / self.upem,
            (bounds[3] - bounds[1]) / self.upem,
        )

    def mark_pairs(self):
        if self._mark_pairs is not None:
            return self._mark_pairs
        pairs = set()
        for subtable in _iter_mark_to_base_subtables(self.font):
            marks = subtable.MarkCoverage.glyphs
            bases = subtable.BaseCoverage.glyphs
            for mark_index, mark_name in enumerate(marks):
                mark_class = subtable.MarkArray.MarkRecord[mark_index].Class
                for base_index, base_name in enumerate(bases):
                    anchors = subtable.BaseArray.BaseRecord[base_index].BaseAnchor
                    if mark_class < len(anchors) and anchors[mark_class] is not None:
                        pairs.add((base_name, mark_name))
        self._mark_pairs = pairs
        return pairs

    def codepoint_mark_pairs(self):
        glyph_codepoints = {}
        for codepoint, glyph_name in self.cmap.items():
            glyph_codepoints.setdefault(glyph_name, set()).add(codepoint)
        pairs = set()
        for base_name, mark_name in self.mark_pairs():
            for base in glyph_codepoints.get(base_name, ()):
                for mark in glyph_codepoints.get(mark_name, ()):
                    pairs.add((base, mark))
        return pairs

    def has_mark_anchor(self, base, mark):
        return (self.cmap[base], self.cmap[mark]) in self.mark_pairs()

    def shape(self, text):
        face = uharfbuzz.Face(self._hb_data, self.index)
        font = uharfbuzz.Font(face)
        font.scale = (face.upem, face.upem)
        buffer = uharfbuzz.Buffer()
        buffer.add_str(text)
        buffer.guess_segment_properties()
        uharfbuzz.shape(font, buffer)
        return list(zip(buffer.glyph_infos, buffer.glyph_positions))


def _resolve_font(filename, directories):
    for directory in directories:
        path = directory / filename
        if path.is_file():
            return path
    return None


def load_fallback_chain(xml_path, directories):
    root = ElementTree.parse(xml_path).getroot()
    chain = []
    for family_index, family in enumerate(root.findall("family")):
        name = family.attrib.get("name")
        if name and name != "sans-serif":
            continue
        candidates = family.findall("font")
        if not candidates:
            continue
        preferred = next(
            (
                element for element in candidates
                if element.attrib.get("style", "normal") == "normal"
                and element.attrib.get("weight", "400") == "400"
            ),
            candidates[0],
        )
        filename = _font_filename(preferred)
        path = _resolve_font(filename, directories)
        if path is None:
            continue
        index = int(preferred.attrib.get("index", "0"))
        chain.append(FontFace(path, index, family_index))
    return chain


def first_provider(chain, codepoint):
    return next((font for font in chain if font.supports(codepoint)), None)


def cluster_provider(chain, base, mark):
    base_font = first_provider(chain, base)
    if base_font is None:
        return None, None
    if base_font.supports(mark):
        return base_font, base_font
    mark_font = first_provider(chain, mark)
    if mark_font is not None and mark_font.supports(base):
        return base_font, mark_font
    return base_font, None


def _size_ratio(first, second, codepoint):
    first_size = first.normalized_size(codepoint)
    second_size = second.normalized_size(codepoint)
    if not first_size or not second_size or min(first_size) == 0:
        return None
    return max(second_size[0] / first_size[0], second_size[1] / first_size[1])


def _script_compatible(base, mark):
    base_script = font_unicode.script(chr(base))
    mark_script = font_unicode.script(chr(mark))
    mark_extensions = font_unicode.script_extension(chr(mark))
    return (
        mark_script == "Zinh"
        or base_script == mark_script
        or base_script in mark_extensions
    )


def candidate_pairs(donor, include_oracle):
    pairs = {
        pair for pair in donor.codepoint_mark_pairs()
        if _script_compatible(*pair)
    }
    if not include_oracle:
        return pairs

    common_bases = {
        codepoint for codepoint in donor.cmap
        if codepoint >= 0x00A0
        and font_unicode.script(chr(codepoint)) == "Zyyy"
        and unicodedata.category(chr(codepoint)) in {"So", "Sm", "Sk"}
    }
    inherited_marks = {
        codepoint for codepoint in donor.cmap
        if font_unicode.script(chr(codepoint)) == "Zinh"
        and unicodedata.category(chr(codepoint)) == "Mn"
        and unicodedata.combining(chr(codepoint)) != 0
    }
    pairs.update(
        (base, mark) for base in common_bases for mark in inherited_marks
    )
    return pairs


def audit(chain, pairs, donor, size_threshold):
    provider_switches = []
    risky_pairs = []
    provider_cache = {}

    def provider(codepoint):
        if codepoint not in provider_cache:
            provider_cache[codepoint] = first_provider(chain, codepoint)
        return provider_cache[codepoint]

    for base, mark in sorted(pairs):
        base_font = provider(base)
        if base_font is None:
            continue
        if base_font.supports(mark):
            combined_font = base_font
        else:
            mark_font = provider(mark)
            combined_font = (
                mark_font if mark_font is not None and mark_font.supports(base)
                else None
            )
        if combined_font is None or base_font is combined_font:
            continue
        ratio = _size_ratio(base_font, combined_font, base)
        anchored = combined_font.has_mark_anchor(base, mark)
        record = {
            "base": f"U+{base:04X}",
            "mark": f"U+{mark:04X}",
            "base_name": unicodedata.name(chr(base), ""),
            "mark_name": unicodedata.name(chr(mark), ""),
            "standalone_font": base_font.label,
            "combined_font": combined_font.label,
            "size_ratio": ratio,
            "mark_to_base_anchor": anchored,
            "donor_mark_to_base_anchor": donor.has_mark_anchor(base, mark),
        }
        provider_switches.append(record)
        if not anchored or (ratio is not None and ratio >= size_threshold):
            risky_pairs.append(record)

    return {
        "fonts": [font.label for font in chain],
        "candidate_pair_count": len(pairs),
        "provider_switch_count": len(provider_switches),
        "risky_pair_count": len(risky_pairs),
        "size_jump_count": sum(
            record["size_ratio"] is not None
            and record["size_ratio"] >= size_threshold
            for record in provider_switches
        ),
        "missing_anchor_count": sum(
            not record["mark_to_base_anchor"] for record in provider_switches
        ),
        "risky_pairs": risky_pairs,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--xml", required=True, type=Path)
    parser.add_argument(
        "--font-dir", action="append", required=True, type=Path,
        dest="font_dirs",
    )
    parser.add_argument("--output", type=Path)
    parser.add_argument("--size-threshold", type=float, default=1.25)
    parser.add_argument("--donor-font", required=True, type=Path)
    parser.add_argument("--include-common-oracle", action="store_true")
    parser.add_argument("--limit", type=int, default=100)
    args = parser.parse_args()

    chain = load_fallback_chain(args.xml, args.font_dirs)
    donor = FontFace(args.donor_font, 0, -1)
    pairs = candidate_pairs(donor, args.include_common_oracle)
    report = audit(chain, pairs, donor, args.size_threshold)
    limited = dict(report)
    limited["risky_pairs"] = report["risky_pairs"][:args.limit]
    output = json.dumps(limited, ensure_ascii=False, indent=2)
    if args.output:
        args.output.write_text(output + "\n", encoding="utf-8")
    print(output)


if __name__ == "__main__":
    main()
