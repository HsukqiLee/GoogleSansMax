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

"""Build a data-driven combining fallback for Common symbols.

The generated font promotes Common symbol outlines that are substantially
larger in NotoSansSuper than in Noto Sans Mono, then adds explicit GPOS
MarkToBase positioning derived from the donor's actual HarfBuzz output.  It
contains no ASCII and excludes complex scripts, emoji and spacing marks.
"""

import argparse
import io
import unicodedata
from pathlib import Path

import uharfbuzz
from fontTools import subset, unicodedata as font_unicode
from fontTools.feaLib.builder import addOpenTypeFeaturesFromString
from fontTools.pens.boundsPen import BoundsPen
from fontTools.pens.recordingPen import RecordingPen
from fontTools.ttLib import TTFont
from fontTools.varLib.instancer import instantiateVariableFont


FAMILY_NAME = "Google Sans Max Symbol Combining Compat"
POSTSCRIPT_NAME = "GoogleSansMaxSymbolCombiningCompat-Regular"
BASE_CATEGORIES = {"So", "Sm", "Sk"}


def glyph_has_outline(font, glyph_name):
    pen = RecordingPen()
    font.getGlyphSet()[glyph_name].draw(pen)
    return any(
        operation in {"lineTo", "curveTo", "qCurveTo", "addComponent"}
        for operation, _ in pen.value
    )


def glyph_bounds(font, glyph_name):
    pen = BoundsPen(font.getGlyphSet())
    font.getGlyphSet()[glyph_name].draw(pen)
    return pen.bounds


def instantiate_donor(font):
    if "fvar" not in font:
        return font
    axes = {axis.axisTag: axis.defaultValue for axis in font["fvar"].axes}
    if "wght" in axes:
        axes["wght"] = 400
    if "wdth" in axes:
        axes["wdth"] = 100
    return instantiateVariableFont(font, axes, inplace=True)


def normalized_size(font, glyph_name):
    bounds = glyph_bounds(font, glyph_name)
    if not bounds:
        return None
    upem = font["head"].unitsPerEm
    return (
        (bounds[2] - bounds[0]) / upem,
        (bounds[3] - bounds[1]) / upem,
    )


def select_codepoints(target, donor, primary, size_threshold):
    target_cmap = target.getBestCmap() or {}
    donor_cmap = donor.getBestCmap() or {}
    primary_cmap = primary.getBestCmap() or {}
    shared = set(target_cmap) & set(donor_cmap)

    bases = set()
    for codepoint in shared:
        if codepoint < 0x00A0:
            continue
        if codepoint in primary_cmap:
            continue
        if font_unicode.script(chr(codepoint)) != "Zyyy":
            continue
        if unicodedata.category(chr(codepoint)) not in BASE_CATEGORIES:
            continue
        target_name = target_cmap[codepoint]
        donor_name = donor_cmap[codepoint]
        if not glyph_has_outline(target, target_name):
            continue
        if not glyph_has_outline(donor, donor_name):
            continue
        target_size = normalized_size(target, target_name)
        donor_size = normalized_size(donor, donor_name)
        if not target_size or not donor_size or min(donor_size) == 0:
            continue
        ratio = max(
            target_size[0] / donor_size[0],
            target_size[1] / donor_size[1],
        )
        if ratio >= size_threshold:
            bases.add(codepoint)

    marks = {
        codepoint for codepoint in shared
        if font_unicode.script(chr(codepoint)) == "Zinh"
        and unicodedata.category(chr(codepoint)) == "Mn"
        and unicodedata.combining(chr(codepoint)) != 0
        and glyph_has_outline(target, target_cmap[codepoint])
        and glyph_has_outline(donor, donor_cmap[codepoint])
    }
    return bases, marks


def harfbuzz_font(font):
    buffer = io.BytesIO()
    font.save(buffer, reorderTables=True)
    data = buffer.getvalue()
    face = uharfbuzz.Face(data)
    result = uharfbuzz.Font(face)
    result.scale = (face.upem, face.upem)
    return result


def shape_pair(font, base, mark):
    buffer = uharfbuzz.Buffer()
    buffer.add_str(chr(base) + chr(mark))
    buffer.guess_segment_properties()
    uharfbuzz.shape(font, buffer)
    if len(buffer.glyph_infos) != 2:
        return None
    if any(info.codepoint == 0 for info in buffer.glyph_infos):
        return None
    if [info.cluster for info in buffer.glyph_infos] != [0, 0]:
        return None
    base_position, mark_position = buffer.glyph_positions
    if mark_position.x_advance != 0 or mark_position.y_advance != 0:
        return None
    return base_position, mark_position


def build_positioning(target, donor, bases, marks):
    target_cmap = target.getBestCmap()
    donor_cmap = donor.getBestCmap()
    donor_hb = harfbuzz_font(donor)
    donor_upem = donor["head"].unitsPerEm
    target_upem = target["head"].unitsPerEm

    mark_classes = []
    base_positions = {base: [] for base in sorted(bases)}
    valid_marks = []

    for mark_index, mark in enumerate(sorted(marks)):
        target_mark_name = target_cmap[mark]
        target_mark_bounds = glyph_bounds(target, target_mark_name)
        donor_mark_bounds = glyph_bounds(donor, donor_cmap[mark])
        if not target_mark_bounds or not donor_mark_bounds:
            continue
        target_mark_center = (
            (target_mark_bounds[0] + target_mark_bounds[2]) / 2,
            (target_mark_bounds[1] + target_mark_bounds[3]) / 2,
        )
        donor_mark_center = (
            (donor_mark_bounds[0] + donor_mark_bounds[2]) / 2,
            (donor_mark_bounds[1] + donor_mark_bounds[3]) / 2,
        )
        class_name = f"@mark{mark_index}"
        mark_classes.append(
            f"markClass [{target_mark_name}] <anchor 0 0> {class_name};"
        )
        valid_marks.append((mark, class_name, target_mark_center, donor_mark_center))

    for base in sorted(bases):
        donor_base_name = donor_cmap[base]
        target_base_name = target_cmap[base]
        donor_advance = donor["hmtx"][donor_base_name][0]
        target_advance = target["hmtx"][target_base_name][0]
        if donor_advance == 0:
            continue
        anchors = []
        for mark, class_name, target_mark_center, donor_mark_center in valid_marks:
            shaped = shape_pair(donor_hb, base, mark)
            if shaped is None:
                anchors.append(None)
                continue
            base_position, mark_position = shaped
            donor_origin_x = base_position.x_advance + mark_position.x_offset
            donor_origin_y = mark_position.y_offset
            donor_center_x = donor_origin_x + donor_mark_center[0]
            donor_center_y = donor_origin_y + donor_mark_center[1]
            target_center_x = donor_center_x * target_advance / donor_advance
            target_center_y = donor_center_y * target_upem / donor_upem
            anchors.append((
                round(target_center_x - target_mark_center[0]),
                round(target_center_y - target_mark_center[1]),
                class_name,
            ))
        base_positions[base] = anchors

    feature_lines = mark_classes
    feature_lines.append("lookup SYMBOL_MARK useExtension {")
    for base in sorted(bases):
        anchors = base_positions[base]
        if not anchors or all(anchor is None for anchor in anchors):
            continue
        parts = [f"  pos base [{target_cmap[base]}]"]
        for anchor in anchors:
            if anchor is None:
                parts.append("<anchor NULL>")
            else:
                x, y, class_name = anchor
                parts.append(f"<anchor {x} {y}> mark {class_name}")
        feature_lines.append(" ".join(parts) + ";")
    feature_lines.extend([
        "} SYMBOL_MARK;",
        "feature mark { lookup SYMBOL_MARK; } mark;",
        "table GDEF {",
        "  GlyphClassDef ["
        + " ".join(target_cmap[codepoint] for codepoint in sorted(bases))
        + "], , ["
        + " ".join(target_cmap[codepoint] for codepoint, *_ in valid_marks)
        + "], ;",
        "} GDEF;",
    ])
    return "\n".join(feature_lines), {mark for mark, *_ in valid_marks}


def set_names(font):
    replacements = {
        1: FAMILY_NAME,
        2: "Regular",
        3: f"{POSTSCRIPT_NAME};1.000",
        4: FAMILY_NAME,
        6: POSTSCRIPT_NAME,
        16: FAMILY_NAME,
        17: "Regular",
    }
    table = font["name"]
    table.names = [record for record in table.names if record.nameID not in replacements]
    for name_id, value in replacements.items():
        table.setName(value, name_id, 3, 1, 0x0409)


def build_font(
    target_path, donor_path, primary_path, output_path, size_threshold=1.25
):
    target = TTFont(target_path, recalcTimestamp=False)
    donor = instantiate_donor(TTFont(donor_path, recalcTimestamp=False))
    primary = TTFont(primary_path, recalcTimestamp=False)
    bases, marks = select_codepoints(target, donor, primary, size_threshold)
    if not bases or not marks:
        raise ValueError("No compatible symbol bases or marks found")

    feature_text, valid_marks = build_positioning(target, donor, bases, marks)
    options = subset.Options()
    options.layout_features = []
    options.name_IDs = ["*"]
    options.name_languages = ["*"]
    options.notdef_outline = True
    options.recalc_bounds = True
    options.recalc_timestamp = False
    subsetter = subset.Subsetter(options=options)
    subsetter.populate(unicodes=bases | valid_marks)
    subsetter.subset(target)
    for table in ("GDEF", "GPOS", "GSUB"):
        if table in target:
            del target[table]
    addOpenTypeFeaturesFromString(target, feature_text)
    set_names(target)

    output = Path(output_path)
    output.parent.mkdir(parents=True, exist_ok=True)
    target.save(output, reorderTables=True)
    return bases, valid_marks


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("target", help="NotoSansSuper font")
    parser.add_argument("donor", help="Noto Sans Mono variable font")
    parser.add_argument("primary", help="Primary Google Sans font")
    parser.add_argument("output", help="Output compatibility font")
    parser.add_argument("--size-threshold", type=float, default=1.25)
    args = parser.parse_args()
    bases, marks = build_font(
        args.target,
        args.donor,
        args.primary,
        args.output,
        args.size_threshold,
    )
    print(
        f"Built {args.output}: {len(bases)} Common symbol bases, "
        f"{len(marks)} inherited marks"
    )


if __name__ == "__main__":
    main()
