const testStrings = {
  default: "这是一个示例 The quick brown fox jumps over the lazy dog 0123456789",
  cjk: "日本語のテキスト 샘플 텍스트 繁體中文 简体中文",
};

const unicodeSets = [
  {
    title: "Emoji & Symbol Support",
    desc: "Test CBDT/COLRv1 Emoji and common symbols.",
    chars: "😀 😂 🤣 🥹 🙃 😉 😇 🥰 🥶 😱 🤪 🗿 💀 👽 👾 🤖 🎃 💥 ✨ 🌟 🔥 🌈 🦄 🦋 🍎 🍔 🍕 🚗 🚀 ⌚ 💻 📱 ❤️ 💔 💯 🏳️‍🌈"
  },
  {
    title: "Rare CJK: GB18030 / Ext-A",
    desc: "Check if system defaults to missing glyphs.",
    chars: "㐀 㐁 㐂 㐃 㐄 㐅 㐆 㐇 㐈 㐉 㐊 㐋 㐌 㐍 㐎 㐏 㑇 㑊 㕮 㘎 㙍 㙘 㙦 㛃"
  },
  {
    title: "Rare CJK: Ext-B to Ext-E",
    desc: "Extended blocks for comprehensive fallback testing.",
    chars: "𠀀 𠀁 𠀂 𠀃 𠀄 𪜀 𪜁 𪜂 𪜃 𫝀 𫝁 𫝂 𫠠 𫠡 𫠢 𫠣"
  },
  {
    title: "Rare CJK: Ext-F & 2021/2022 Additions",
    desc: "Extremely rare characters added recently to Unicode.",
    chars: "𬺰 𬺱 𬺲 𬺳 鿰 鿱 鿲 䶶 䶷 䶸 𪛗 𪛘 𪛙 𫜹"
  }
];

const fontFamilies = {
  "sans-serif": {
    family: "sans-serif",
    title: "Sans-Serif (Google Sans / Noto Sans CJK)",
    text: testStrings.default
  },
  "serif": {
    family: "serif",
    title: "Serif (Noto Serif CJK)",
    text: testStrings.default
  },
  "monospace": {
    family: "monospace",
    title: "Monospace",
    text: testStrings.default
  },
  "cjk": {
    family: "sans-serif",
    title: "CJK Languages (Ja/Ko/Hant)",
    text: testStrings.cjk
  }
};

const weights = [100, 200, 300, 400, 500, 600, 700, 800, 900];

function generateFontCards(config, isItalic = false) {
  let html = `<div class="md3-card">
    <div class="md3-card-title">${config.title} ${isItalic ? '(Italic)' : ''}</div>`;
  
  weights.forEach(w => {
    let id = `font-${config.family}-${w}-${isItalic ? 'italic' : 'normal'}`;
    html += `
      <div class="font-row">
        <div class="test-row-header">
          <div class="font-weight-label">Weight: ${w}</div>
          <label class="fail-checkbox-label">
            <input type="checkbox" class="fail-checkbox" data-id="${id}" data-type="font" data-desc="${config.title} Weight ${w} ${isItalic ? 'Italic' : 'Normal'}">
            Fail
          </label>
        </div>
        <div class="font-sample ${isItalic ? 'italic' : ''}" style="font-family: ${config.family}; font-weight: ${w};">
          ${config.text}
        </div>
      </div>
    `;
  });
  html += `</div>`;
  return html;
}

function generateUnicodeCards() {
  let html = '';
  unicodeSets.forEach((set, idx) => {
    let id = `unicode-set-${idx}`;
    html += `<div class="md3-card">
      <div class="test-row-header">
        <div class="md3-card-title">${set.title}</div>
        <label class="fail-checkbox-label">
          <input type="checkbox" class="fail-checkbox" data-id="${id}" data-type="unicode" data-desc="${set.title}">
          Fail
        </label>
      </div>
      <div class="unicode-desc">${set.desc}</div>
      <div class="unicode-grid">`;
    
    // Split by space, or just treat as a continuous string if needed
    // The provided strings are space-separated
    const charArray = set.chars.split(' ').filter(c => c.trim().length > 0);
    charArray.forEach(char => {
      html += `<div class="unicode-item">${char}</div>`;
    });
    
    html += `</div></div>`;
  });
  return html;
}

function renderTab(target) {
  const container = document.getElementById('tab-content');
  if (target === 'unicode') {
    container.innerHTML = generateUnicodeCards();
  } else {
    const config = fontFamilies[target];
    container.innerHTML = generateFontCards(config, false) + generateFontCards(config, true);
  }
}

// Tab interaction
document.querySelectorAll('.md3-tab').forEach(tab => {
  tab.addEventListener('click', (e) => {
    // Remove active class from all
    document.querySelectorAll('.md3-tab').forEach(t => t.classList.remove('active'));
    // Add active class to clicked
    const currentTab = e.currentTarget;
    currentTab.classList.add('active');
    
    // Render content
    const target = currentTab.getAttribute('data-target');
    renderTab(target);
  });
});

// Initial render
renderTab('sans-serif');

// --- Debug Report Logic ---
const fabReport = document.getElementById('fab-report');
const dialogScrim = document.getElementById('dialog-scrim');
const btnClose = document.getElementById('btn-close-dialog');
const btnCopy = document.getElementById('btn-copy-report');
const reportOutput = document.getElementById('report-output');

// Collect all failed tests from the UI (persists across tabs? No, our tabs re-render so state is lost if we don't save it)
// Wait, since we re-render, we should keep a global state of failed tests.
const failedTests = new Set();

document.addEventListener('change', (e) => {
  if (e.target.classList.contains('fail-checkbox')) {
    const desc = e.target.getAttribute('data-desc');
    if (e.target.checked) {
      failedTests.add(desc);
    } else {
      failedTests.delete(desc);
    }
  }
});

fabReport.addEventListener('click', () => {
  let moduleInfo = "Unknown";
  // Attempt to get KernelSU Module Info
  if (window.ksu) {
    try {
      // ksu might expose system info or module info depending on the webui bridge
      moduleInfo = "KernelSU WebUI Environment"; 
    } catch(e) {}
  }

  let report = `## Google Sans Max - Debug Report

**Environment Info:**
- **User Agent:** \`${navigator.userAgent}\`
- **Platform:** \`${navigator.platform}\`
- **Language:** \`${navigator.language}\`
- **Module Context:** \`${moduleInfo}\`

**Failed Rendering Tests:**
`;

  if (failedTests.size === 0) {
    report += `\n*All tested fonts and Unicode characters rendered correctly!*\n`;
  } else {
    failedTests.forEach(test => {
      report += `- ❌ ${test}\n`;
    });
  }

  reportOutput.value = report;
  dialogScrim.classList.add('open');
});

btnClose.addEventListener('click', () => {
  dialogScrim.classList.remove('open');
});

btnCopy.addEventListener('click', () => {
  reportOutput.select();
  document.execCommand('copy');
  btnCopy.textContent = "Copied!";
  setTimeout(() => {
    btnCopy.textContent = "Copy";
  }, 2000);
});

// Restore checkbox states when switching tabs
function restoreCheckboxes() {
  document.querySelectorAll('.fail-checkbox').forEach(cb => {
    const desc = cb.getAttribute('data-desc');
    if (failedTests.has(desc)) {
      cb.checked = true;
    }
  });
}

// Override renderTab to restore checkboxes
const originalRenderTab = renderTab;
renderTab = function(target) {
  originalRenderTab(target);
  restoreCheckboxes();
};
