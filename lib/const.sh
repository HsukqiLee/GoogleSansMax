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



FONT_XML_FILES="fonts.xml fonts_base.xml fonts_fallback.xml fonts_inter.xml fonts_slate.xml fonts_ule.xml font_fallback.xml fonts_flyme.xml flyme_fallback.xml flyme_font_fallback.xml"
FONT_XML_SUBDIRS="system/etc system/product/etc system/system_ext/etc"
FONT_BINARY_SUBDIRS="system/fonts"

LOCK_DIR="/data/adb/ufs_lock"

MODULE_START_COMMENT="<!-- UnicodeFontSetModule Start -->"
MODULE_END_COMMENT="<!-- UnicodeFontSetModule End -->"

TEMP_DIR="/data/local/tmp"
CMAP_TOOL_PREFIX="font-cmap-tool"

THIS_MODULE_BINARY_FONTS_CACHE=""
