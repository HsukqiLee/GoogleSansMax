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
#

# ================================
# English Language Pack
# ================================

# --- General ---
TXT_SERVICE_START="🚀 === Starting font module monitor task ==="
TXT_START_MONITOR="📹 Starting monitoring of other font modules..."
TXT_MONITOR_DONE="✅ Font module monitoring completed"
TXT_NO_CONFLICT="  ✅ No conflicting font modules detected"

TXT_LOCK_BUSY="⛔ Another instance is running, skipping this run"
TXT_SERVICE_BUSY="⛔ Another instance is running, exiting service"

TXT_API_TOO_LOW="⏬ Android version too low, skipping font injection"
TXT_ERROR_API_LEVEL="❌ Error: API level not set."

# --- Font XML ---
TXT_XML_NEW="🆕️ Detected new font XML from module %1\$s: %2\$s/%3\$s."
TXT_XML_UPDATE="♻️ Detected updated font XML from module %1\$s: %2\$s/%3\$s, reprocessing."
TXT_XML_RECREATE="🔁 Detected recreated font XML from module %1\$s: %2\$s/%3\$s."

TXT_XML_BACKUP_FAIL="  ❌ Backup failed: %s, skipping"
TXT_XML_COPY_FAIL="  ❌ Copy failed: %s"

TXT_XML_INJECT_OK="  ✅ Injected font configuration into %s"
TXT_XML_REPLACED="✅ Replaced %1\$s %2\$s/%3\$s and re-injected fonts."

# --- Error messages ---
TXT_ERROR_COPY="  ❌ Copy failed: from %1\$s to %2\$s"
TXT_ERROR_WRITE="  ❌ Write failed: %s"
TXT_ERROR_PROCESS="  ❌ Process failed: %s"
TXT_ERROR_MOVE="  ❌ Move failed: from %1\$s to %2\$s"

TXT_XML_FORMAT_WARN="  ⚠️ Warning: %s format may be invalid, skipping."
TXT_XML_NOT_FOUND="  ❌ File not found: %s"
TXT_XML_FRAGMENT_MISSING="  ❌ Font fragment configuration missing"
TXT_XML_NONE="  ℹ️ No other font XML modules found"

# --- Font binaries ---
TXT_WARN_NO_SELF_FONTS="⚠️ No font files found in this module's system/fonts, binary conflicts cannot be handled"
TXT_BIN_NEW="🆕️ Detected new conflicting font binary from module %1\$s: %2\$s/%3\$s."
TXT_BIN_UPDATE="♻️ Detected updated conflicting font binary from module %1\$s: %2\$s/%3\$s."
TXT_BIN_RECREATE="🔁 Detected recreated conflicting font binary from module %1\$s: %2\$s/%3\$s."

TXT_BIN_BACKUP_OK="✅ Removed and backed up: %1\$s/%2\$s/%3\$s"
TXT_BIN_BACKUP_FAIL="  ❌ Backup failed: %s, skipping"
TXT_BIN_NONE="  ℹ️ No conflicting font binaries found"

# --- Install phase ---
TXT_INSTALL_XML_SCAN="📄 Processing font XML files from other modules..."
TXT_INSTALL_BIN_SCAN="📦 Processing font binary files from other modules..."
TXT_INSTALL_SYSTEM_XML="🧩 Scanning system font XML files..."
TXT_INSTALL_DONE="- ✅ Installation completed, font conflicts resolved"
TXT_INSTALL_PROCESS="  ⚙️ Processing: %1\$s/%2\$s"
TXT_INSTALL_COPY_FAIL="  ❌ Copy failed: %s"
TXT_SYSTEM_XML_NONE="  ℹ️ No system font XML files found"

# --- Module lifecycle ---
TXT_MODULE_FOUND="  🔍 Found module: %s"
TXT_MODULE_REMOVED_XML="🧹 Module %1\$s removed, cleaning XML backups (%2\$s)."
TXT_MODULE_REMOVED_BIN="🧹 Module %1\$s removed, cleaning binary backups (%2\$s)."

# --- Input detection ---
TXT_KEYCHECK_DETECT="- 🎚️ Using keycheck for volume key detection (%s seconds)"
TXT_GETEVENT_DETECT="- 🎚️ Using getevent for volume key detection (%s seconds)"
TXT_NO_INPUT_METHOD="- ℹ️ No available input method detected"

# --- cmap cleanup ---
TXT_CMAP_TITLE="📌 Optional: cmap table cleanup"
TXT_CMAP_DESC_1="📖 If you encounter:"
TXT_CMAP_DESC_2=" - 😵 Kaomoji (like ʕ•ᴥ•ʔ、 (╯°□°)、 ๑⃙⃘´༥`๑⃙⃘ 、 (ͼ̤͂ ͜ ͽ̤͂)✧、 ٩(๑ᵒ̴̶̷͈᷄ᗨᵒ̴̶̷͈᷅)و) display abnormally"
TXT_CMAP_DESC_3=" - 😀 Emoji shows as blank / squares / misaligned (like😀.png 、🤓:nerd face)"
TXT_CMAP_DESC_4="👉 This is usually caused by font cmap conflicts"
TXT_CMAP_DESC_5="⚠️ This operation modifies module font files (safe & reversible)"

# --- Magisk ---
TXT_MAGISK_MIRROR_UNAVAIL="⚠️ Magisk mirror path unavailable, will use system path directly"
TXT_MAGISK_CMD_UNAVAIL="⚠️ Magisk command unavailable, will use system path directly"

TXT_CMAP_CHOICE="⏳ Within 15 seconds:"
TXT_CMAP_SKIP_HINT="  ⬆️ [+]Volume Up → Skip"
TXT_CMAP_RUN_HINT="  ⬇️ [-]Volume Down → Run cleanup"

TXT_CMAP_RUN="🚀 User chose to run cmap cleanup"
TXT_CMAP_SKIP="↩️ User chose to skip"
TXT_CMAP_TIMEOUT="⏱️ Timeout, skipped"
TXT_CMAP_UNSUPPORTED="ℹ️ Key detection not supported, skipped"

TXT_CMAP_START="🔧 Running font-cmap-cleaner..."
TXT_CMAP_DONE="✅ font-cmap-cleaner completed"
TXT_CMAP_FAIL="⚠️ font-cmap-cleaner failed (exit=%s)"
TXT_CMAP_COPY_FAIL="❌ Failed to copy font-cmap-tool"
TXT_CMAP_CANNOT_RUN="⚠️ font-cmap-cleaner cannot run on current system"
TXT_CMAP_TOOL_PATH="  📍 %s"

# --- ABI / tool ---
TXT_ABI_PRIMARY="- 🧬 Primary ABI: %s"
TXT_ABI_LIST="- 🧬 ABI list: %s"
TXT_ABI_UNSUPPORTED="❌ ! Unsupported ABI: %s"
TXT_CMAP_TOOL_MISSING="❌ ! font-cmap-cleaner binary not found or not executable"
TXT_CMAP_TOOL_USING="- 🔧 Using font-cmap-cleaner: %s"

# --- Install UI ---
TXT_INSTALL_TITLE="🎨 Unicode Font Set Installer"
TXT_INSTALL_HEADER="========================================"
TXT_VERSION="🏷️ Version: %s"
TXT_INSTALL_COMPLETE="🎉 Installation completed!"
TXT_REBOOT_REQUIRED="🔄 Please reboot your device to apply font configurations."
TXT_START_SERVICE="▶️ Starting font module service..."

# --- Lock ---
TXT_LOCK_TIMEOUT="⏰⚠️ Lock acquisition timeout (30s), possible deadlock"

# --- Installation steps ---
TXT_STEP_1="①📄 Scanning font XML files from other modules..."
TXT_STEP_2="②📦 Processing font binary files from other modules..."
TXT_STEP_3="③🧩 Processing system font XML files..."
TXT_STEP_4="④✅ Completing installation preparations..."
TXT_INSTALL_SEPARATOR="========================================"

# --- Log messages ---
TXT_LOG_FILE_NOT_FOUND="❌ File not found: %s"
TXT_LOG_FRAGMENT_NOT_FOUND="❌ Font fragment file not found: %s"
TXT_LOG_INVALID_XML_FORMAT="❌ Invalid XML format: %s"
TXT_LOG_COPY_FAILED="❌ Failed to copy %1\$s to %2\$s"
TXT_LOG_WRITE_FAILED="❌ Failed to write temporary file %s"
TXT_LOG_MISSING_COMMENTS="❌ Temporary file missing module comments: %s"
TXT_LOG_REPLACE_FAILED="❌ Failed to replace %1\$s with %2\$s"
TXT_LOG_PROCESS_FAILED="❌ Failed to process %s with awk"
TXT_LOG_MOVE_FAILED="❌ Failed to move %1\$s to %2\$s"
TXT_LOG_REMOVE_FAILED="⚠️ Failed to remove temporary file %s"
TXT_LOG_OLD_FONTS_REMOVE_FAILED="⚠️ Failed to remove old fonts from %s"
TXT_LOG_XML_PROCESSED="✅ Successfully processed font XML: %s"
TXT_LOG_SHA1_WRITE_FAILED="❌ Failed to write SHA1 value to %s"
TXT_LOG_SHA1_MOVE_FAILED="❌ Failed to move %1\$s to %2\$s"

# --- Language loader ---
TXT_LANG_DEFAULT_MISSING="⚠️ Default language file lang_en_US.sh not found"
TXT_LANG_UNSUPPORTED="⚠️ Unsupported language %s, using English"
