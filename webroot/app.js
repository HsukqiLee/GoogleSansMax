/* ==========================================
   i18n
   ========================================== */
const LANGS={
'zh-CN':{
  tabHome:'首页',tabLatin:'西文',tabCjk:'CJK',tabCompare:'对比',tabCharset:'字符集',
  sans:'无衬线',serif:'衬线',mono:'等宽',sansLabel:'Sans-Serif (Google Sans Flex)',serifLabel:'Serif (Noto Serif)',monoLabel:'Monospace (Noto Sans Mono)',
  fontSize:'字号',fontWeight:'字重',customText:'自定义文本',preview:'预览',
  weightComparison:'字重对比',characterCoverage:'字符覆盖',cjkSample:'CJK 示例',hentaiganaTitle:'変体仮名',
  sectionRegular:'正体',sectionItalic:'斜体',
  coverageUnihan:'Unihan',coverageUnicode:'Unicode',
  coverageTesting:'测试中',coverageResult:'覆盖率结果',coverageCharPreview:'正在测试',
  runTest:'开始测试',testing:'测试中',hidePerfect:'隐藏满分',
  glyphCompare:'CJK 字形对比',glyphCompareDesc:'同一字在不同 lang 属性下的渲染差异',
  deviceFont:'设备字体',
  cjkExtA:'扩展 A 区',cjkExtB:'扩展 B 区',cjkExtC:'扩展 C 区',cjkExtD:'扩展 D 区',
  cjkExtE:'扩展 E 区',cjkExtF:'扩展 F 区',cjkExtG:'扩展 G 区',cjkExtH:'扩展 H 区',cjkExtI:'扩展 I 区',cjkExtJ:'扩展 J 区',
  locale:'字型',
  coverageChar:'字符',localeSystem:'系统',localeZhHans:'简体中文',localeZhHant:'繁體中文',localeJa:'日本語',localeKo:'한국어',
  pageTitle:'Google Sans Max',langLabel:'语言',
  charsetLatin:'Latin',charsetLatinExt:'Latin Ext',charsetCJK:'CJK',charsetKana:'假名',charsetHangul:'谚文',charsetSymbol:'符号',
  emojiComplexTitle:'复杂 Emoji 测试',emojiComplexDesc:'测试变体选择符、键帽、旗帜、肤色和 ZWJ 序列能否合成为完整图形。',emojiInspectHint:'请人工观察：不应出现方框、字母、拆开的组件或可见控制符。',
  emojiPresentation:'呈现方式',emojiKeycap:'键帽',emojiFlag:'旗帜',emojiTagFlag:'地区旗帜',emojiModifier:'肤色',emojiZwj:'ZWJ',emojiDirection:'方向',emojiFamily:'家庭',emojiPrivate:'私用字符',
  emojiHeartStyles:'无 VS / VS15 / VS16',emojiHeartNote:'无 VS 的默认样式可由浏览器决定；VS15 应为文本，VS16 应为彩色 Emoji。',emojiKeycapFive:'数字 5 键帽',emojiTaiwanFlag:'台湾旗帜',emojiEnglandFlag:'英格兰旗帜',emojiThumbTone:'中等肤色点赞',emojiHealthWorker:'女医务人员',emojiTechnologist:'技术人员',emojiRainbowFlag:'彩虹旗',emojiServiceDog:'服务犬',emojiRedHair:'红发女性',emojiWalkingRight:'向右行走',emojiFamilySample:'四口之家',emojiHandshake:'不同肤色握手',emojiCouple:'情侣与爱心',emojiAppleLogo:'Apple 标志',emojiAppleNote:'U+F8FF 是非标准私用约定；Firefox Android 可能拒绝私用区系统 fallback，原生应用或 WebView 结果可能不同。',
  footer:'Google Sans Max — 字重 100–1000 · 拉丁 + CJK · Sans + Serif + Mono',
},
'zh-TW':{
  tabHome:'首頁',tabLatin:'西文',tabCjk:'CJK',tabCompare:'對比',tabCharset:'字元集',
  sans:'無襯線',serif:'襯線',mono:'等寬',sansLabel:'Sans-Serif (Google Sans Flex)',serifLabel:'Serif (Noto Serif)',monoLabel:'Monospace (Noto Sans Mono)',
  fontSize:'字號',fontWeight:'字重',customText:'自訂文字',preview:'預覽',
  weightComparison:'字重對比',characterCoverage:'字元覆蓋',cjkSample:'CJK 範例',hentaiganaTitle:'変體假名',
  sectionRegular:'正體',sectionItalic:'斜體',
  coverageUnihan:'Unihan',coverageUnicode:'Unicode',
  coverageTesting:'測試中',coverageResult:'覆蓋率結果',coverageCharPreview:'正在測試',
  runTest:'開始測試',testing:'測試中',hidePerfect:'隱藏滿分',
  glyphCompare:'CJK 字形對比',glyphCompareDesc:'同一字在不同 lang 屬性下的渲染差異',
  deviceFont:'裝置字體',
  cjkExtA:'擴展 A 區',cjkExtB:'擴展 B 區',cjkExtC:'擴展 C 區',cjkExtD:'擴展 D 區',
  cjkExtE:'擴展 E 區',cjkExtF:'擴展 F 區',cjkExtG:'擴展 G 區',cjkExtH:'擴展 H 區',cjkExtI:'擴展 I 區',cjkExtJ:'擴展 J 區',
  locale:'字型',
  coverageChar:'字元',localeSystem:'系統',localeZhHans:'简体中文',localeZhHant:'繁體中文',localeJa:'日本語',localeKo:'한국어',
  pageTitle:'Google Sans Max',langLabel:'語言',
  charsetLatin:'Latin',charsetLatinExt:'Latin Ext',charsetCJK:'CJK',charsetKana:'假名',charsetHangul:'谚文',charsetSymbol:'符號',
  emojiComplexTitle:'複雜 Emoji 測試',emojiComplexDesc:'測試變體選擇符、鍵帽、旗幟、膚色和 ZWJ 序列能否合成為完整圖形。',emojiInspectHint:'請人工觀察：不應出現方框、字母、拆開的元件或可見控制符。',
  emojiPresentation:'呈現方式',emojiKeycap:'鍵帽',emojiFlag:'旗幟',emojiTagFlag:'地區旗幟',emojiModifier:'膚色',emojiZwj:'ZWJ',emojiDirection:'方向',emojiFamily:'家庭',emojiPrivate:'私用字元',
  emojiHeartStyles:'無 VS / VS15 / VS16',emojiHeartNote:'無 VS 的預設樣式可由瀏覽器決定；VS15 應為文字，VS16 應為彩色 Emoji。',emojiKeycapFive:'數字 5 鍵帽',emojiTaiwanFlag:'臺灣旗幟',emojiEnglandFlag:'英格蘭旗幟',emojiThumbTone:'中等膚色讚',emojiHealthWorker:'女醫務人員',emojiTechnologist:'技術人員',emojiRainbowFlag:'彩虹旗',emojiServiceDog:'服務犬',emojiRedHair:'紅髮女性',emojiWalkingRight:'向右行走',emojiFamilySample:'四口之家',emojiHandshake:'不同膚色握手',emojiCouple:'情侶與愛心',emojiAppleLogo:'Apple 標誌',emojiAppleNote:'U+F8FF 是非標準私用約定；Firefox Android 可能拒絕私用區系統 fallback，原生應用或 WebView 結果可能不同。',
  footer:'Google Sans Max — 字重 100–1000 · 拉丁 + CJK · Sans + Serif + Mono',
},
'en':{
  tabHome:'Home',tabLatin:'Latin',tabCjk:'CJK',tabCompare:'Compare',tabCharset:'Charset',
  sans:'Sans',serif:'Serif',mono:'Mono',sansLabel:'Sans-Serif (Google Sans Flex)',serifLabel:'Serif (Noto Serif)',monoLabel:'Monospace (Noto Sans Mono)',
  fontSize:'Font Size',fontWeight:'Weight',customText:'Custom Text',preview:'Preview',
  weightComparison:'Weight Comparison',characterCoverage:'Character Coverage',cjkSample:'CJK Sample',hentaiganaTitle:'Hentaigana',
  sectionRegular:'Regular',sectionItalic:'Italic',
  coverageUnihan:'Unihan',coverageUnicode:'Unicode',
  coverageTesting:'Testing',coverageResult:'Coverage Result',coverageCharPreview:'Testing',
  runTest:'Run Test',testing:'Testing...',hidePerfect:'Hide perfect',
  glyphCompare:'CJK Glyph Compare',glyphCompareDesc:'Same character rendered under different lang attributes',
  deviceFont:'Device Font',
  cjkExtA:'Ext-A',cjkExtB:'Ext-B',cjkExtC:'Ext-C',cjkExtD:'Ext-D',
  cjkExtE:'Ext-E',cjkExtF:'Ext-F',cjkExtG:'Ext-G',cjkExtH:'Ext-H',cjkExtI:'Ext-I',cjkExtJ:'Ext-J',
  locale:'Locale',
  coverageChar:'chars',localeSystem:'System',localeZhHans:'Simplified Chinese',localeZhHant:'Traditional Chinese',localeJa:'Japanese',localeKo:'Korean',
  pageTitle:'Google Sans Max',langLabel:'Language',
  charsetLatin:'Latin',charsetLatinExt:'Latin Ext',charsetCJK:'CJK',charsetKana:'Kana',charsetHangul:'Hangul',charsetSymbol:'Symbol',
  emojiComplexTitle:'Complex Emoji Test',emojiComplexDesc:'Checks whether variation selectors, keycaps, flags, skin tones, and ZWJ sequences compose into complete glyphs.',emojiInspectHint:'Inspect visually: there should be no tofu, letters, split components, or visible control characters.',
  emojiPresentation:'Presentation',emojiKeycap:'Keycap',emojiFlag:'Flag',emojiTagFlag:'Subdivision flag',emojiModifier:'Skin tone',emojiZwj:'ZWJ',emojiDirection:'Direction',emojiFamily:'Family',emojiPrivate:'Private use',
  emojiHeartStyles:'No VS / VS15 / VS16',emojiHeartNote:'The browser may choose the no-VS style; VS15 should be text and VS16 should be color emoji.',emojiKeycapFive:'Keycap digit five',emojiTaiwanFlag:'Flag: Taiwan',emojiEnglandFlag:'Flag: England',emojiThumbTone:'Thumbs up: medium tone',emojiHealthWorker:'Woman health worker',emojiTechnologist:'Technologist',emojiRainbowFlag:'Rainbow flag',emojiServiceDog:'Service dog',emojiRedHair:'Woman with red hair',emojiWalkingRight:'Person walking right',emojiFamilySample:'Family of four',emojiHandshake:'Mixed-tone handshake',emojiCouple:'Couple with heart',emojiAppleLogo:'Apple logo',emojiAppleNote:'U+F8FF is a nonstandard private-use convention. Firefox Android may skip system PUA fallback, so native apps and WebView can differ.',
  footer:'Google Sans Max — Weight 100–1000 · Latin + CJK · Sans + Serif + Mono',
},
'ja':{
  tabHome:'ホーム',tabLatin:'欧文',tabCjk:'CJK',tabCompare:'比較',tabCharset:'文字セット',
  sans:'サンセリフ',serif:'セリフ',mono:'等幅',sansLabel:'Sans-Serif (Google Sans Flex)',serifLabel:'Serif (Noto Serif)',monoLabel:'Monospace (Noto Sans Mono)',
  fontSize:'フォントサイズ',fontWeight:'ウェイト',customText:'カスタムテキスト',preview:'プレビュー',
  weightComparison:'ウェイト比較',characterCoverage:'文字カバレッジ',cjkSample:'CJK サンプル',hentaiganaTitle:'変体仮名',
  sectionRegular:'正体',sectionItalic:'イタリック',
  coverageUnihan:'Unihan',coverageUnicode:'Unicode',
  coverageTesting:'テスト中',coverageResult:'カバレッジ結果',coverageCharPreview:'テスト中',
  runTest:'テスト開始',testing:'テスト中...',hidePerfect:'満点を非表示',
  glyphCompare:'CJK グリフ比較',glyphCompareDesc:'同じ文字を異なる lang 属性でレンダリング',
  deviceFont:'デバイスフォント',
  cjkExtA:'拡張A',cjkExtB:'拡張B',cjkExtC:'拡張C',cjkExtD:'拡張D',
  cjkExtE:'拡張E',cjkExtF:'拡張F',cjkExtG:'拡張G',cjkExtH:'拡張H',cjkExtI:'拡張I',cjkExtJ:'拡張J',
  locale:'ロケール',
  coverageChar:'文字',localeSystem:'システム',localeZhHans:'简体中文',localeZhHant:'繁體中文',localeJa:'日本語',localeKo:'한국어',
  pageTitle:'Google Sans Max',langLabel:'言語',
  charsetLatin:'ラテン文字',charsetLatinExt:'ラテン文字拡張',charsetCJK:'CJK',charsetKana:'仮名',charsetHangul:'ハングル',charsetSymbol:'記号',
  emojiComplexTitle:'複合 Emoji テスト',emojiComplexDesc:'異体字セレクタ、キーキャップ、旗、肌色、ZWJ シーケンスが一つの絵文字になるか確認します。',emojiInspectHint:'目視確認：豆腐、文字、分離した部品、可視の制御文字が表示されないこと。',
  emojiPresentation:'表示形式',emojiKeycap:'キーキャップ',emojiFlag:'旗',emojiTagFlag:'地域旗',emojiModifier:'肌色',emojiZwj:'ZWJ',emojiDirection:'方向',emojiFamily:'家族',emojiPrivate:'私用文字',
  emojiHeartStyles:'VS なし / VS15 / VS16',emojiHeartNote:'VS なしの表示はブラウザー依存です。VS15 はテキスト、VS16 はカラー Emoji になります。',emojiKeycapFive:'数字 5 キーキャップ',emojiTaiwanFlag:'台湾の旗',emojiEnglandFlag:'イングランド旗',emojiThumbTone:'中間肌色の親指',emojiHealthWorker:'女性の医療従事者',emojiTechnologist:'技術者',emojiRainbowFlag:'レインボーフラッグ',emojiServiceDog:'介助犬',emojiRedHair:'赤毛の女性',emojiWalkingRight:'右向きに歩く人',emojiFamilySample:'4人家族',emojiHandshake:'異なる肌色の握手',emojiCouple:'カップルとハート',emojiAppleLogo:'Apple ロゴ',emojiAppleNote:'U+F8FF は非標準の私用文字です。Firefox Android は PUA のシステム fallback を行わない場合があり、WebView やネイティブアプリと結果が異なります。',
  footer:'Google Sans Max — ウェイト 100–1000 · ラテン + CJK · Sans + Serif + Mono',
},
'ko':{
  tabHome:'홈',tabLatin:'서문',tabCjk:'CJK',tabCompare:'비교',tabCharset:'문자집합',
  sans:'산세리프',serif:'세리프',mono:'고정폭',sansLabel:'Sans-Serif (Google Sans Flex)',serifLabel:'Serif (Noto Serif)',monoLabel:'Monospace (Noto Sans Mono)',
  fontSize:'폰트 크기',fontWeight:'웨이트',customText:'사용자 정의 텍스트',preview:'미리보기',
  weightComparison:'웨이트 비교',characterCoverage:'문자 커버리지',cjkSample:'CJK 샘플',hentaiganaTitle:'헨타이가나',
  sectionRegular:'정체',sectionItalic:'이탤릭',
  coverageUnihan:'Unihan',coverageUnicode:'Unicode',
  coverageTesting:'테스트 중',coverageResult:'커버리지 결과',coverageCharPreview:'테스트 중',
  runTest:'테스트 시작',testing:'테스트 중...',hidePerfect:'만점 숨기기',
  glyphCompare:'CJK 글리프 비교',glyphCompareDesc:'동일한 문자를 다른 lang 속성으로 렌더링',
  deviceFont:'장치 폰트',
  cjkExtA:'확장A',cjkExtB:'확장B',cjkExtC:'확장C',cjkExtD:'확장D',
  cjkExtE:'확장E',cjkExtF:'확장F',cjkExtG:'확장G',cjkExtH:'확장H',cjkExtI:'확장I',cjkExtJ:'확장J',
  locale:'로케일',
  coverageChar:'문자',localeSystem:'시스템',localeZhHans:'简体中文',localeZhHant:'繁體中文',localeJa:'日本語',localeKo:'한국어',
  pageTitle:'Google Sans Max',langLabel:'언어',
  charsetLatin:'로마자',charsetLatinExt:'로마자 확장',charsetCJK:'CJK',charsetKana:'가나',charsetHangul:'한글',charsetSymbol:'기호',
  emojiComplexTitle:'복합 Emoji 테스트',emojiComplexDesc:'변형 선택자, 키캡, 깃발, 피부색 및 ZWJ 시퀀스가 하나의 그림으로 합성되는지 확인합니다.',emojiInspectHint:'육안 확인: 네모, 문자, 분리된 구성 요소 또는 보이는 제어 문자가 없어야 합니다.',
  emojiPresentation:'표현 방식',emojiKeycap:'키캡',emojiFlag:'깃발',emojiTagFlag:'지역 깃발',emojiModifier:'피부색',emojiZwj:'ZWJ',emojiDirection:'방향',emojiFamily:'가족',emojiPrivate:'사용자 정의 문자',
  emojiHeartStyles:'VS 없음 / VS15 / VS16',emojiHeartNote:'VS 없는 기본 모양은 브라우저가 선택할 수 있습니다. VS15는 텍스트, VS16은 컬러 Emoji여야 합니다.',emojiKeycapFive:'숫자 5 키캡',emojiTaiwanFlag:'대만 깃발',emojiEnglandFlag:'잉글랜드 깃발',emojiThumbTone:'중간 피부색 엄지',emojiHealthWorker:'여성 의료인',emojiTechnologist:'기술자',emojiRainbowFlag:'무지개 깃발',emojiServiceDog:'도우미견',emojiRedHair:'빨간 머리 여성',emojiWalkingRight:'오른쪽으로 걷는 사람',emojiFamilySample:'4인 가족',emojiHandshake:'서로 다른 피부색 악수',emojiCouple:'커플과 하트',emojiAppleLogo:'Apple 로고',emojiAppleNote:'U+F8FF는 비표준 사용자 정의 문자입니다. Firefox Android는 PUA 시스템 fallback을 건너뛸 수 있어 WebView 및 네이티브 앱과 결과가 다를 수 있습니다.',
  footer:'Google Sans Max — 웨이트 100–1000 · 라틴 + CJK · Sans + Serif + Mono',
},
};
const LANG_LABELS={'zh-CN':'简体中文','zh-TW':'繁體中文','en':'English','ja':'日本語','ko':'한국어'};
function detectLang(){const s=localStorage.getItem('gsm_lang');if(s&&LANGS[s])return s;const n=(navigator.language||'').replace(/[-_]/g,'-').toLowerCase();if(n.startsWith('zh')){if(n.includes('tw')||n.includes('hk')||n.includes('mo')||n.includes('hant'))return 'zh-TW';return 'zh-CN'}if(n.startsWith('ja'))return 'ja';if(n.startsWith('ko'))return 'ko';return 'en'}
function t(key){const v=LANGS[S.lang]&&LANGS[S.lang][key];if(v)return v;const ev=LANGS['en']&&LANGS['en'][key];if(ev)return ev;console.warn('[i18n] missing key:',key,'for lang:',S.lang);return key}

/* ==========================================
   Data
   ========================================== */
const FONTS={sans:{family:'sans-serif',weights:[100,200,300,350,400,500,600,700,800,900,950],labelKey:'sansLabel',italic:true},serif:{family:'serif',weights:[100,200,300,350,400,500,600,700,800,900,950],labelKey:'serifLabel',italic:true},mono:{family:'monospace',weights:[100,200,300,350,400,500,600,700,800,900,950],labelKey:'monoLabel',italic:true}};
const CJK_WEIGHTS=[100,200,300,350,400,500,600,700,800,900,950];
const CJK_DATA={'zh-Hans':{labelKey:'localeZhHans',sample:'天地玄黄 宇宙洪荒 日月盈昃 辰宿列张 寒来暑往 秋收冬藏',serif:'风急天高猿啸哀 渚清沙白鸟飞回 无边落木萧萧下 不尽长江滚滚来'},'zh-Hant':{labelKey:'localeZhHant',sample:'天地玄黃 宇宙洪荒 日月盈昃 辰宿列張 寒來暑往 秋收冬藏',serif:'風急天高猿嘯哀 渚清沙白鳥飛回 無邊落木蕭蕭下 不盡長江滾滾來'},'ja':{labelKey:'localeJa',sample:'いろはにほへと ちりぬるを わかよたれそ つねならむ',serif:'吾輩は猫である 名前はまだ無い'},'ko':{labelKey:'localeKo',sample:'나의 이름은 김철수입니다 한국어 테스트',serif:'백두산이 마르고 닳도록 하느님이 보우하사'}};
const SAMPLES={sans:'The quick brown fox jumps over the lazy dog 0123456789',serif:'Pack my box with five dozen liquor jugs 0123456789',mono:'const fn = () => Math.PI * 2; // 6.283'};
const HENTAIGANA=Array.from({length:256},(_,i)=>String.fromCodePoint(0x1B001+i)).join('');
const CJK_GLYPH_CHARS=['扇','靠','复','述','直','言'];
const CHARSET=[{id:'Latin',labelKey:'charsetLatin',start:0x0020,end:0x007E},{id:'Latin Ext',labelKey:'charsetLatinExt',start:0x00C0,end:0x024F},{id:'CJK',labelKey:'charsetCJK',start:0x4E00,end:0x4E8F},{id:'Kana',labelKey:'charsetKana',start:0x3040,end:0x30FF},{id:'Hangul',labelKey:'charsetHangul',start:0xAC00,end:0xD7AF},{id:'Symbol',labelKey:'charsetSymbol',start:0x2000,end:0x2BFF}];
const EMOJI_TESTS=[
  {category:'emojiPresentation',name:'emojiHeartStyles',note:'emojiHeartNote',variants:[[0x2764],[0x2764,0xFE0E],[0x2764,0xFE0F]]},
  {category:'emojiKeycap',name:'emojiKeycapFive',cps:[0x35,0xFE0F,0x20E3]},
  {category:'emojiFlag',name:'emojiTaiwanFlag',cps:[0x1F1F9,0x1F1FC]},
  {category:'emojiTagFlag',name:'emojiEnglandFlag',cps:[0x1F3F4,0xE0067,0xE0062,0xE0065,0xE006E,0xE0067,0xE007F]},
  {category:'emojiModifier',name:'emojiThumbTone',cps:[0x1F44D,0x1F3FD]},
  {category:'emojiZwj',name:'emojiHealthWorker',cps:[0x1F469,0x1F3FD,0x200D,0x2695,0xFE0F]},
  {category:'emojiZwj',name:'emojiTechnologist',cps:[0x1F9D1,0x200D,0x1F4BB]},
  {category:'emojiZwj',name:'emojiRainbowFlag',cps:[0x1F3F3,0xFE0F,0x200D,0x1F308]},
  {category:'emojiZwj',name:'emojiServiceDog',cps:[0x1F415,0x200D,0x1F9BA]},
  {category:'emojiZwj',name:'emojiRedHair',cps:[0x1F469,0x200D,0x1F9B0]},
  {category:'emojiDirection',name:'emojiWalkingRight',cps:[0x1F6B6,0x200D,0x27A1,0xFE0F]},
  {category:'emojiFamily',name:'emojiFamilySample',cps:[0x1F468,0x200D,0x1F469,0x200D,0x1F467,0x200D,0x1F466]},
  {category:'emojiZwj',name:'emojiHandshake',cps:[0x1FAF1,0x1F3FB,0x200D,0x1FAF2,0x1F3FF]},
  {category:'emojiZwj',name:'emojiCouple',cps:[0x1F469,0x1F3FD,0x200D,0x2764,0xFE0F,0x200D,0x1F468,0x1F3FB]},
  {category:'emojiPrivate',name:'emojiAppleLogo',note:'emojiAppleNote',deviceFallback:true,cps:[0xF8FF]},
];

// Dynamic block loading from unicode.org Blocks.txt (354 blocks, Unicode 18.0.0)
// Falls back to hardcoded copy on network failure
let allBlocks=null,hanBlocks=null,codepointRanges=null,unicodeTotal=0,unihanTotal=0;
const BLOCKS_URL='Blocks.txt';
const HAN_RE=/CJK|Ideographic|Ideograph|Bopomofo|Kangxi|Kanbun|Yi (?:Syllable|Radical)/i;
const INLINE_BLOCKS=[
  {name:'Basic Latin',start:0x0000,end:0x007F},{name:'Latin-1 Supplement',start:0x0080,end:0x00FF},
  {name:'Latin Extended-A',start:0x0100,end:0x017F},{name:'Latin Extended-B',start:0x0180,end:0x024F},
  {name:'IPA Extensions',start:0x0250,end:0x02AF},{name:'Spacing Modifier Letters',start:0x02B0,end:0x02FF},
  {name:'Combining Diacritical Marks',start:0x0300,end:0x036F},{name:'Greek and Coptic',start:0x0370,end:0x03FF},
  {name:'Cyrillic',start:0x0400,end:0x04FF},{name:'Cyrillic Supplement',start:0x0500,end:0x052F},
  {name:'Armenian',start:0x0530,end:0x058F},{name:'Hebrew',start:0x0590,end:0x05FF},
  {name:'Arabic',start:0x0600,end:0x06FF},{name:'Syriac',start:0x0700,end:0x074F},
  {name:'Arabic Supplement',start:0x0750,end:0x077F},{name:'Thaana',start:0x0780,end:0x07BF},
  {name:'NKo',start:0x07C0,end:0x07FF},{name:'Samaritan',start:0x0800,end:0x083F},
  {name:'Mandaic',start:0x0840,end:0x085F},{name:'Syriac Supplement',start:0x0860,end:0x086F},
  {name:'Arabic Extended-B',start:0x0870,end:0x089F},{name:'Arabic Extended-A',start:0x08A0,end:0x08FF},
  {name:'Devanagari',start:0x0900,end:0x097F},{name:'Bengali',start:0x0980,end:0x09FF},
  {name:'Gurmukhi',start:0x0A00,end:0x0A7F},{name:'Gujarati',start:0x0A80,end:0x0AFF},
  {name:'Oriya',start:0x0B00,end:0x0B7F},{name:'Tamil',start:0x0B80,end:0x0BFF},
  {name:'Telugu',start:0x0C00,end:0x0C7F},{name:'Kannada',start:0x0C80,end:0x0CFF},
  {name:'Malayalam',start:0x0D00,end:0x0D7F},{name:'Sinhala',start:0x0D80,end:0x0DFF},
  {name:'Thai',start:0x0E00,end:0x0E7F},{name:'Lao',start:0x0E80,end:0x0EFF},
  {name:'Tibetan',start:0x0F00,end:0x0FFF},{name:'Myanmar',start:0x1000,end:0x109F},
  {name:'Georgian',start:0x10A0,end:0x10FF},{name:'Hangul Jamo',start:0x1100,end:0x11FF},
  {name:'Ethiopic',start:0x1200,end:0x137F},{name:'Ethiopic Supplement',start:0x1380,end:0x139F},
  {name:'Cherokee',start:0x13A0,end:0x13FF},
  {name:'Unified Canadian Aboriginal Syllabics',start:0x1400,end:0x167F},
  {name:'Ogham',start:0x1680,end:0x169F},{name:'Runic',start:0x16A0,end:0x16FF},
  {name:'Tagalog',start:0x1700,end:0x171F},{name:'Hanunoo',start:0x1720,end:0x173F},
  {name:'Buhid',start:0x1740,end:0x175F},{name:'Tagbanwa',start:0x1760,end:0x177F},
  {name:'Khmer',start:0x1780,end:0x17FF},{name:'Mongolian',start:0x1800,end:0x18AF},
  {name:'Unified Canadian Aboriginal Syllabics Extended',start:0x18B0,end:0x18FF},
  {name:'Limbu',start:0x1900,end:0x194F},{name:'Tai Le',start:0x1950,end:0x197F},
  {name:'New Tai Lue',start:0x1980,end:0x19DF},{name:'Khmer Symbols',start:0x19E0,end:0x19FF},
  {name:'Buginese',start:0x1A00,end:0x1A1F},{name:'Tai Tham',start:0x1A20,end:0x1AAF},
  {name:'Combining Diacritical Marks Extended',start:0x1AB0,end:0x1AFF},
  {name:'Balinese',start:0x1B00,end:0x1B7F},{name:'Sundanese',start:0x1B80,end:0x1BBF},
  {name:'Batak',start:0x1BC0,end:0x1BFF},{name:'Lepcha',start:0x1C00,end:0x1C4F},
  {name:'Ol Chiki',start:0x1C50,end:0x1C7F},{name:'Cyrillic Extended-C',start:0x1C80,end:0x1C8F},
  {name:'Georgian Extended',start:0x1C90,end:0x1CBF},{name:'Sundanese Supplement',start:0x1CC0,end:0x1CCF},
  {name:'Vedic Extensions',start:0x1CD0,end:0x1CFF},
  {name:'Phonetic Extensions',start:0x1D00,end:0x1D7F},{name:'Phonetic Extensions Supplement',start:0x1D80,end:0x1DBF},
  {name:'Combining Diacritical Marks Supplement',start:0x1DC0,end:0x1DFF},
  {name:'Latin Extended Additional',start:0x1E00,end:0x1EFF},{name:'Greek Extended',start:0x1F00,end:0x1FFF},
  {name:'General Punctuation',start:0x2000,end:0x206F},{name:'Superscripts and Subscripts',start:0x2070,end:0x209F},
  {name:'Currency Symbols',start:0x20A0,end:0x20CF},
  {name:'Combining Diacritical Marks for Symbols',start:0x20D0,end:0x20FF},
  {name:'Letterlike Symbols',start:0x2100,end:0x214F},{name:'Number Forms',start:0x2150,end:0x218F},
  {name:'Arrows',start:0x2190,end:0x21FF},{name:'Mathematical Operators',start:0x2200,end:0x22FF},
  {name:'Miscellaneous Technical',start:0x2300,end:0x23FF},{name:'Control Pictures',start:0x2400,end:0x243F},
  {name:'Optical Character Recognition',start:0x2440,end:0x245F},
  {name:'Enclosed Alphanumerics',start:0x2460,end:0x24FF},{name:'Box Drawing',start:0x2500,end:0x257F},
  {name:'Block Elements',start:0x2580,end:0x259F},{name:'Geometric Shapes',start:0x25A0,end:0x25FF},
  {name:'Miscellaneous Symbols',start:0x2600,end:0x26FF},{name:'Dingbats',start:0x2700,end:0x27BF},
  {name:'Miscellaneous Mathematical Symbols-A',start:0x27C0,end:0x27EF},
  {name:'Supplemental Arrows-A',start:0x27F0,end:0x27FF},{name:'Braille Patterns',start:0x2800,end:0x28FF},
  {name:'Supplemental Arrows-B',start:0x2900,end:0x297F},
  {name:'Miscellaneous Mathematical Symbols-B',start:0x2980,end:0x29FF},
  {name:'Supplemental Mathematical Operators',start:0x2A00,end:0x2AFF},
  {name:'Miscellaneous Symbols and Arrows',start:0x2B00,end:0x2BFF},
  {name:'Glagolitic',start:0x2C00,end:0x2C5F},{name:'Latin Extended-C',start:0x2C60,end:0x2C7F},
  {name:'Coptic',start:0x2C80,end:0x2CFF},{name:'Georgian Supplement',start:0x2D00,end:0x2D2F},
  {name:'Tifinagh',start:0x2D30,end:0x2D7F},{name:'Ethiopic Extended',start:0x2D80,end:0x2DDF},
  {name:'Cyrillic Extended-A',start:0x2DE0,end:0x2DFF},{name:'Supplemental Punctuation',start:0x2E00,end:0x2E7F},
  {name:'CJK Radicals Supplement',start:0x2E80,end:0x2EFF},{name:'Kangxi Radicals',start:0x2F00,end:0x2FDF},
  {name:'Ideographic Description Characters',start:0x2FF0,end:0x2FFF},
  {name:'CJK Symbols and Punctuation',start:0x3000,end:0x303F},
  {name:'Hiragana',start:0x3040,end:0x309F},{name:'Katakana',start:0x30A0,end:0x30FF},
  {name:'Bopomofo',start:0x3100,end:0x312F},{name:'Hangul Compatibility Jamo',start:0x3130,end:0x318F},
  {name:'Kanbun',start:0x3190,end:0x319F},{name:'Bopomofo Extended',start:0x31A0,end:0x31BF},
  {name:'CJK Strokes',start:0x31C0,end:0x31EF},{name:'Katakana Phonetic Extensions',start:0x31F0,end:0x31FF},
  {name:'Enclosed CJK Letters and Months',start:0x3200,end:0x32FF},
  {name:'CJK Compatibility',start:0x3300,end:0x33FF},
  {name:'CJK Unified Ideographs Extension A',start:0x3400,end:0x4DBF},
  {name:'Yijing Hexagram Symbols',start:0x4DC0,end:0x4DFF},
  {name:'CJK Unified Ideographs',start:0x4E00,end:0x9FFF},
  {name:'Yi Syllables',start:0xA000,end:0xA48F},{name:'Yi Radicals',start:0xA490,end:0xA4CF},
  {name:'Lisu',start:0xA4D0,end:0xA4FF},{name:'Vai',start:0xA500,end:0xA63F},
  {name:'Cyrillic Extended-B',start:0xA640,end:0xA69F},{name:'Bamum',start:0xA6A0,end:0xA6FF},
  {name:'Modifier Tone Letters',start:0xA700,end:0xA71F},{name:'Latin Extended-D',start:0xA720,end:0xA7FF},
  {name:'Syloti Nagri',start:0xA800,end:0xA82F},{name:'Common Indic Number Forms',start:0xA830,end:0xA83F},
  {name:'Phags-pa',start:0xA840,end:0xA87F},{name:'Saurashtra',start:0xA880,end:0xA8DF},
  {name:'Devanagari Extended',start:0xA8E0,end:0xA8FF},{name:'Kayah Li',start:0xA900,end:0xA92F},
  {name:'Rejang',start:0xA930,end:0xA95F},{name:'Hangul Jamo Extended-A',start:0xA960,end:0xA97F},
  {name:'Javanese',start:0xA980,end:0xA9DF},{name:'Myanmar Extended-B',start:0xA9E0,end:0xA9FF},
  {name:'Cham',start:0xAA00,end:0xAA5F},{name:'Myanmar Extended-A',start:0xAA60,end:0xAA7F},
  {name:'Tai Viet',start:0xAA80,end:0xAADF},{name:'Meetei Mayek Extensions',start:0xAAE0,end:0xAAFF},
  {name:'Ethiopic Extended-A',start:0xAB00,end:0xAB2F},{name:'Latin Extended-E',start:0xAB30,end:0xAB6F},
  {name:'Cherokee Supplement',start:0xAB70,end:0xABBF},{name:'Meetei Mayek',start:0xABC0,end:0xABFF},
  {name:'Hangul Syllables',start:0xAC00,end:0xD7AF},{name:'Hangul Jamo Extended-B',start:0xD7B0,end:0xD7FF},
  {name:'High Surrogates',start:0xD800,end:0xDB7F},{name:'High Private Use Surrogates',start:0xDB80,end:0xDBFF},
  {name:'Low Surrogates',start:0xDC00,end:0xDFFF},{name:'Private Use Area',start:0xE000,end:0xF8FF},
  {name:'CJK Compatibility Ideographs',start:0xF900,end:0xFAFF},
  {name:'Alphabetic Presentation Forms',start:0xFB00,end:0xFB4F},
  {name:'Arabic Presentation Forms-A',start:0xFB50,end:0xFDFF},
  {name:'Variation Selectors',start:0xFE00,end:0xFE0F},{name:'Vertical Forms',start:0xFE10,end:0xFE1F},
  {name:'Combining Half Marks',start:0xFE20,end:0xFE2F},{name:'CJK Compatibility Forms',start:0xFE30,end:0xFE4F},
  {name:'Small Form Variants',start:0xFE50,end:0xFE6F},
  {name:'Arabic Presentation Forms-B',start:0xFE70,end:0xFEFF},
  {name:'Halfwidth and Fullwidth Forms',start:0xFF00,end:0xFFEF},{name:'Specials',start:0xFFF0,end:0xFFFF},
  {name:'Linear B Syllabary',start:0x10000,end:0x1007F},{name:'Linear B Ideograms',start:0x10080,end:0x100FF},
  {name:'Aegean Numbers',start:0x10100,end:0x1013F},{name:'Ancient Greek Numbers',start:0x10140,end:0x1018F},
  {name:'Ancient Symbols',start:0x10190,end:0x101CF},{name:'Phaistos Disc',start:0x101D0,end:0x101FF},
  {name:'Lycian',start:0x10280,end:0x1029F},{name:'Carian',start:0x102A0,end:0x102DF},
  {name:'Coptic Epact Numbers',start:0x102E0,end:0x102FF},{name:'Old Italic',start:0x10300,end:0x1032F},
  {name:'Gothic',start:0x10330,end:0x1034F},{name:'Old Permic',start:0x10350,end:0x1037F},
  {name:'Ugaritic',start:0x10380,end:0x1039F},{name:'Old Persian',start:0x103A0,end:0x103DF},
  {name:'Deseret',start:0x10400,end:0x1044F},{name:'Shavian',start:0x10450,end:0x1047F},
  {name:'Osmanya',start:0x10480,end:0x104AF},{name:'Osage',start:0x104B0,end:0x104FF},
  {name:'Elbasan',start:0x10500,end:0x1052F},{name:'Caucasian Albanian',start:0x10530,end:0x1056F},
  {name:'Vithkuqi',start:0x10570,end:0x105BF},{name:'Todhri',start:0x105C0,end:0x105FF},
  {name:'Linear A',start:0x10600,end:0x1077F},{name:'Latin Extended-F',start:0x10780,end:0x107BF},
  {name:'Cypriot Syllabary',start:0x10800,end:0x1083F},{name:'Imperial Aramaic',start:0x10840,end:0x1085F},
  {name:'Palmyrene',start:0x10860,end:0x1087F},{name:'Nabataean',start:0x10880,end:0x108AF},
  {name:'Hatran',start:0x108E0,end:0x108FF},{name:'Phoenician',start:0x10900,end:0x1091F},
  {name:'Lydian',start:0x10920,end:0x1093F},{name:'Sidetic',start:0x10940,end:0x1095F},
  {name:'Meroitic Hieroglyphs',start:0x10980,end:0x1099F},{name:'Meroitic Cursive',start:0x109A0,end:0x109FF},
  {name:'Kharoshthi',start:0x10A00,end:0x10A5F},{name:'Old South Arabian',start:0x10A60,end:0x10A7F},
  {name:'Old North Arabian',start:0x10A80,end:0x10A9F},{name:'Manichaean',start:0x10AC0,end:0x10AFF},
  {name:'Avestan',start:0x10B00,end:0x10B3F},{name:'Inscriptional Parthian',start:0x10B40,end:0x10B5F},
  {name:'Inscriptional Pahlavi',start:0x10B60,end:0x10B7F},{name:'Psalter Pahlavi',start:0x10B80,end:0x10BAF},
  {name:'Old Turkic',start:0x10C00,end:0x10C4F},{name:'Old Hungarian',start:0x10C80,end:0x10CFF},
  {name:'Hanifi Rohingya',start:0x10D00,end:0x10D3F},{name:'Garay',start:0x10D40,end:0x10D8F},
  {name:'Rumi Numeral Symbols',start:0x10E60,end:0x10E7F},{name:'Yezidi',start:0x10E80,end:0x10EBF},
  {name:'Arabic Extended-C',start:0x10EC0,end:0x10EFF},{name:'Old Sogdian',start:0x10F00,end:0x10F2F},
  {name:'Sogdian',start:0x10F30,end:0x10F6F},{name:'Old Uyghur',start:0x10F70,end:0x10FAF},
  {name:'Chorasmian',start:0x10FB0,end:0x10FDF},{name:'Elymaic',start:0x10FE0,end:0x10FFF},
  {name:'Brahmi',start:0x11000,end:0x1107F},{name:'Kaithi',start:0x11080,end:0x110CF},
  {name:'Sora Sompeng',start:0x110D0,end:0x110FF},{name:'Chakma',start:0x11100,end:0x1114F},
  {name:'Mahajani',start:0x11150,end:0x1117F},{name:'Sharada',start:0x11180,end:0x111DF},
  {name:'Sinhala Archaic Numbers',start:0x111E0,end:0x111FF},{name:'Khojki',start:0x11200,end:0x1124F},
  {name:'Multani',start:0x11280,end:0x112AF},{name:'Khudawadi',start:0x112B0,end:0x112FF},
  {name:'Grantha',start:0x11300,end:0x1137F},{name:'Tulu-Tigalari',start:0x11380,end:0x113FF},
  {name:'Newa',start:0x11400,end:0x1147F},{name:'Tirhuta',start:0x11480,end:0x114DF},
  {name:'Siddham',start:0x11580,end:0x115FF},{name:'Modi',start:0x11600,end:0x1165F},
  {name:'Mongolian Supplement',start:0x11660,end:0x1167F},{name:'Takri',start:0x11680,end:0x116CF},
  {name:'Myanmar Extended-C',start:0x116D0,end:0x116FF},{name:'Ahom',start:0x11700,end:0x1174F},
  {name:'Dogra',start:0x11800,end:0x1184F},{name:'Warang Citi',start:0x118A0,end:0x118FF},
  {name:'Dives Akuru',start:0x11900,end:0x1195F},{name:'Nandinagari',start:0x119A0,end:0x119FF},
  {name:'Zanabazar Square',start:0x11A00,end:0x11A4F},{name:'Soyombo',start:0x11A50,end:0x11AAF},
  {name:'Unified Canadian Aboriginal Syllabics Extended-A',start:0x11AB0,end:0x11ABF},
  {name:'Pau Cin Hau',start:0x11AC0,end:0x11AFF},{name:'Devanagari Extended-A',start:0x11B00,end:0x11B5F},
  {name:'Sharada Supplement',start:0x11B60,end:0x11B7F},{name:'Sunuwar',start:0x11BC0,end:0x11BFF},
  {name:'Bhaiksuki',start:0x11C00,end:0x11C6F},{name:'Marchen',start:0x11C70,end:0x11CBF},
  {name:'Masaram Gondi',start:0x11D00,end:0x11D5F},{name:'Gunjala Gondi',start:0x11D60,end:0x11DAF},
  {name:'Tolong Siki',start:0x11DB0,end:0x11DEF},{name:'Bengali Supplement',start:0x11DF0,end:0x11DFF},
  {name:'Makasar',start:0x11EE0,end:0x11EFF},{name:'Kawi',start:0x11F00,end:0x11F5F},
  {name:'Lisu Supplement',start:0x11FB0,end:0x11FBF},{name:'Tamil Supplement',start:0x11FC0,end:0x11FFF},
  {name:'Cuneiform',start:0x12000,end:0x123FF},{name:'Cuneiform Numbers and Punctuation',start:0x12400,end:0x1247F},
  {name:'Early Dynastic Cuneiform',start:0x12480,end:0x1254F},
  {name:'Archaic Cuneiform Numerals',start:0x12550,end:0x1268F},
  {name:'Cypro-Minoan',start:0x12F90,end:0x12FFF},{name:'Egyptian Hieroglyphs',start:0x13000,end:0x1342F},
  {name:'Egyptian Hieroglyph Format Controls',start:0x13430,end:0x1345F},
  {name:'Egyptian Hieroglyphs Extended-A',start:0x13460,end:0x143FF},
  {name:'Anatolian Hieroglyphs',start:0x14400,end:0x1467F},
  {name:'Gurung Khema',start:0x16100,end:0x1613F},{name:'Bamum Supplement',start:0x16800,end:0x16A3F},
  {name:'Mro',start:0x16A40,end:0x16A6F},{name:'Tangsa',start:0x16A70,end:0x16ACF},
  {name:'Bassa Vah',start:0x16AD0,end:0x16AFF},{name:'Pahawh Hmong',start:0x16B00,end:0x16B8F},
  {name:'Kirat Rai',start:0x16D40,end:0x16D7F},{name:'Chisoi',start:0x16D80,end:0x16DAF},
  {name:'Medefaidrin',start:0x16E40,end:0x16E9F},{name:'Beria Erfe',start:0x16EA0,end:0x16EDF},
  {name:'Miao',start:0x16F00,end:0x16F9F},{name:'Ideographic Symbols and Punctuation',start:0x16FE0,end:0x16FFF},
  {name:'Tangut',start:0x17000,end:0x187FF},{name:'Tangut Components',start:0x18800,end:0x18AFF},
  {name:'Khitan Small Script',start:0x18B00,end:0x18CFF},{name:'Tangut Supplement',start:0x18D00,end:0x18D7F},
  {name:'Tangut Components Supplement',start:0x18D80,end:0x18DFF},
  {name:'Jurchen',start:0x18E00,end:0x1919F},{name:'Jurchen Radicals',start:0x191A0,end:0x191DF},
  {name:'Kana Extended-B',start:0x1AFF0,end:0x1AFFF},{name:'Kana Supplement',start:0x1B000,end:0x1B0FF},
  {name:'Kana Extended-A',start:0x1B100,end:0x1B12F},{name:'Small Kana Extension',start:0x1B130,end:0x1B16F},
  {name:'Nushu',start:0x1B170,end:0x1B2FF},{name:'Duployan',start:0x1BC00,end:0x1BC9F},
  {name:'Shorthand Format Controls',start:0x1BCA0,end:0x1BCAF},
  {name:'Symbols for Legacy Computing Supplement',start:0x1CC00,end:0x1CEBF},
  {name:'Miscellaneous Symbols Supplement',start:0x1CEC0,end:0x1CEFF},
  {name:'Znamenny Musical Notation',start:0x1CF00,end:0x1CFCF},
  {name:'Byzantine Musical Symbols',start:0x1D000,end:0x1D0FF},
  {name:'Musical Symbols',start:0x1D100,end:0x1D1FF},
  {name:'Ancient Greek Musical Notation',start:0x1D200,end:0x1D24F},
  {name:'Musical Symbols Supplement',start:0x1D250,end:0x1D28F},
  {name:'Kaktovik Numerals',start:0x1D2C0,end:0x1D2DF},{name:'Mayan Numerals',start:0x1D2E0,end:0x1D2FF},
  {name:'Tai Xuan Jing Symbols',start:0x1D300,end:0x1D35F},
  {name:'Counting Rod Numerals',start:0x1D360,end:0x1D37F},
  {name:'Mathematical Alphanumeric Symbols',start:0x1D400,end:0x1D7FF},
  {name:'Sutton SignWriting',start:0x1D800,end:0x1DAAF},
  {name:'Miscellaneous Symbols and Arrows Extended',start:0x1DB00,end:0x1DBFF},
  {name:'Latin Extended-G',start:0x1DF00,end:0x1DFFF},
  {name:'Glagolitic Supplement',start:0x1E000,end:0x1E02F},
  {name:'Cyrillic Extended-D',start:0x1E030,end:0x1E08F},
  {name:'Nyiakeng Puachue Hmong',start:0x1E100,end:0x1E14F},{name:'Toto',start:0x1E290,end:0x1E2BF},
  {name:'Wancho',start:0x1E2C0,end:0x1E2FF},{name:'Nag Mundari',start:0x1E4D0,end:0x1E4FF},
  {name:'Ol Onal',start:0x1E5D0,end:0x1E5FF},{name:'Tai Yo',start:0x1E6C0,end:0x1E6FF},
  {name:'Ethiopic Extended-B',start:0x1E7E0,end:0x1E7FF},
  {name:'Mende Kikakui',start:0x1E800,end:0x1E8DF},{name:'Adlam',start:0x1E900,end:0x1E95F},
  {name:'Indic Siyaq Numbers',start:0x1EC70,end:0x1ECBF},
  {name:'Ottoman Siyaq Numbers',start:0x1ED00,end:0x1ED4F},
  {name:'Arabic Mathematical Alphabetic Symbols',start:0x1EE00,end:0x1EEFF},
  {name:'Mahjong Tiles',start:0x1F000,end:0x1F02F},{name:'Domino Tiles',start:0x1F030,end:0x1F09F},
  {name:'Playing Cards',start:0x1F0A0,end:0x1F0FF},
  {name:'Enclosed Alphanumeric Supplement',start:0x1F100,end:0x1F1FF},
  {name:'Enclosed Ideographic Supplement',start:0x1F200,end:0x1F2FF},
  {name:'Miscellaneous Symbols and Pictographs',start:0x1F300,end:0x1F5FF},
  {name:'Emoticons',start:0x1F600,end:0x1F64F},{name:'Ornamental Dingbats',start:0x1F650,end:0x1F67F},
  {name:'Transport and Map Symbols',start:0x1F680,end:0x1F6FF},
  {name:'Alchemical Symbols',start:0x1F700,end:0x1F77F},
  {name:'Geometric Shapes Extended',start:0x1F780,end:0x1F7FF},
  {name:'Supplemental Arrows-C',start:0x1F800,end:0x1F8FF},
  {name:'Supplemental Symbols and Pictographs',start:0x1F900,end:0x1F9FF},
  {name:'Chess Symbols',start:0x1FA00,end:0x1FA6F},
  {name:'Symbols and Pictographs Extended-A',start:0x1FA70,end:0x1FAFF},
  {name:'Symbols for Legacy Computing',start:0x1FB00,end:0x1FBFF},
  {name:'CJK Unified Ideographs Extension B',start:0x20000,end:0x2A6DF},
  {name:'CJK Unified Ideographs Extension C',start:0x2A700,end:0x2B73F},
  {name:'CJK Unified Ideographs Extension D',start:0x2B740,end:0x2B81F},
  {name:'CJK Unified Ideographs Extension E',start:0x2B820,end:0x2CEAF},
  {name:'CJK Unified Ideographs Extension F',start:0x2CEB0,end:0x2EBEF},
  {name:'CJK Unified Ideographs Extension I',start:0x2EBF0,end:0x2EE5F},
  {name:'CJK Compatibility Ideographs Supplement',start:0x2F800,end:0x2FA1F},
  {name:'CJK Unified Ideographs Extension G',start:0x30000,end:0x3134F},
  {name:'CJK Unified Ideographs Extension H',start:0x31350,end:0x323AF},
  {name:'CJK Unified Ideographs Extension J',start:0x323B0,end:0x3347F},
  {name:'Seal',start:0x3D000,end:0x3FC3F},{name:'Tags',start:0xE0000,end:0xE007F},
  {name:'Variation Selectors Supplement',start:0xE0100,end:0xE01EF},
  {name:'Supplementary Private Use Area-A',start:0xF0000,end:0xFFFFF},
  {name:'Supplementary Private Use Area-B',start:0x100000,end:0x10FFFF},
];
const INLINE_HAN=INLINE_BLOCKS.filter(b=>HAN_RE.test(b.name));
const INLINE_CODEPOINTS=[[33,126],[161,172],[174,767],[880,887],[890,895],[900,906],[908,908],[910,929],[931,1154],[1160,1327],[1329,1366],[1369,1418],[1421,1423],[1470,1470],[1472,1472],[1475,1475],[1478,1478],[1488,1514],[1519,1524],[1542,1551],[1563,1563],[1565,1610],[1632,1647],[1649,1749],[1758,1758],[1765,1766],[1769,1769],[1774,1805],[1808,1808],[1810,1839],[1869,1957],[1969,1969],[1984,2026],[2036,2042],[2046,2069],[2074,2074],[2084,2084],[2088,2088],[2096,2110],[2112,2136],[2142,2142],[2144,2154],[2160,2191],[2208,2249],[2307,2361],[2363,2363],[2365,2368],[2377,2380],[2382,2384],[2392,2401],[2404,2432],[2434,2435],[2437,2444],[2447,2448],[2451,2472],[2474,2480],[2482,2482],[2486,2489],[2493,2496],[2503,2504],[2507,2508],[2510,2510],[2519,2519],[2524,2525],[2527,2529],[2534,2557],[2563,2563],[2565,2570],[2575,2576],[2579,2600],[2602,2608],[2610,2611],[2613,2614],[2616,2617],[2622,2624],[2649,2652],[2654,2654],[2662,2671],[2674,2676],[2678,2678],[2691,2691],[2693,2701],[2703,2705],[2707,2728],[2730,2736],[2738,2739],[2741,2745],[2749,2752],[2761,2761],[2763,2764],[2768,2768],[2784,2785],[2790,2801],[2809,2809],[2818,2819],[2821,2828],[2831,2832],[2835,2856],[2858,2864],[2866,2867],[2869,2873],[2877,2878],[2880,2880],[2887,2888],[2891,2892],[2903,2903],[2908,2909],[2911,2913],[2918,2935],[2947,2947],[2949,2954],[2958,2960],[2962,2965],[2969,2970],[2972,2972],[2974,2975],[2979,2980],[2984,2986],[2990,3001],[3006,3007],[3009,3010],[3014,3016],[3018,3020],[3024,3024],[3031,3031],[3046,3066],[3073,3075],[3077,3084],[3086,3088],[3090,3112],[3114,3129],[3133,3133],[3137,3140],[3160,3162],[3164,3165],[3168,3169],[3174,3183],[3191,3200],[3202,3212],[3214,3216],[3218,3240],[3242,3251],[3253,3257],[3261,3262],[3264,3268],[3271,3272],[3274,3275],[3285,3286],[3292,3294],[3296,3297],[3302,3311],[3313,3315],[3330,3340],[3342,3344],[3346,3386],[3389,3392],[3398,3400],[3402,3404],[3406,3407],[3412,3425],[3430,3455],[3458,3459],[3461,3478],[3482,3505],[3507,3515],[3517,3517],[3520,3526],[3535,3537],[3544,3551],[3558,3567],[3570,3572],[3585,3632],[3634,3635],[3647,3654],[3663,3675],[3713,3714],[3716,3716],[3718,3722],[3724,3747],[3749,3749],[3751,3760],[3762,3763],[3773,3773],[3776,3780],[3782,3782],[3792,3801],[3804,3807],[3840,3863],[3866,3892],[3894,3894],[3896,3896],[3898,3911],[3913,3948],[3967,3967],[3973,3973],[3976,3980],[4030,4037],[4039,4044],[4046,4058],[4096,4140],[4145,4145],[4152,4152],[4155,4156],[4159,4183],[4186,4189],[4193,4208],[4213,4225],[4227,4228],[4231,4236],[4238,4252],[4254,4293],[4295,4295],[4301,4301],[4304,4680],[4682,4685],[4688,4694],[4696,4696],[4698,4701],[4704,4744],[4746,4749],[4752,4784],[4786,4789],[4792,4798],[4800,4800],[4802,4805],[4808,4822],[4824,4880],[4882,4885],[4888,4954],[4960,4988],[4992,5017],[5024,5109],[5112,5117],[5120,5759],[5761,5788],[5792,5880],[5888,5905],[5909,5909],[5919,5937],[5940,5942],[5952,5969],[5984,5996],[5998,6000],[6016,6067],[6070,6070],[6078,6085],[6087,6088],[6100,6108],[6112,6121],[6128,6137],[6144,6154],[6160,6169],[6176,6264],[6272,6276],[6279,6312],[6314,6314],[6320,6389],[6400,6430],[6435,6438],[6441,6443],[6448,6449],[6451,6456],[6464,6464],[6468,6509],[6512,6516],[6528,6571],[6576,6601],[6608,6618],[6622,6678],[6681,6682],[6686,6741],[6743,6743],[6753,6753],[6755,6756],[6765,6770],[6784,6793],[6800,6809],[6816,6829],[6846,6846],[6916,6963],[6965,6965],[6971,6971],[6973,6977],[6979,6988],[6990,7018],[7028,7039],[7042,7073],[7078,7079],[7082,7082],[7086,7141],[7143,7143],[7146,7148],[7150,7150],[7154,7155],[7164,7211],[7220,7221],[7227,7241],[7245,7306],[7312,7354],[7357,7367],[7379,7379],[7393,7393],[7401,7404],[7406,7411],[7413,7415],[7418,7418],[7424,7615],[7680,7957],[7960,7965],[7968,8005],[8008,8013],[8016,8023],[8025,8025],[8027,8027],[8029,8029],[8031,8061],[8064,8116],[8118,8132],[8134,8147],[8150,8155],[8157,8175],[8178,8180],[8182,8190],[8208,8231],[8240,8286],[8304,8305],[8308,8334],[8336,8348],[8352,8385],[8413,8416],[8418,8420],[8448,8587],[8592,9257],[9280,9290],[9312,11123],[11126,11502],[11506,11507],[11513,11557],[11559,11559],[11565,11565],[11568,11623],[11631,11632],[11648,11670],[11680,11686],[11688,11694],[11696,11702],[11704,11710],[11712,11718],[11720,11726],[11728,11734],[11736,11742],[11776,11869],[11904,11929],[11931,12019],[12032,12245],[12272,12287],[12289,12329],[12334,12351],[12353,12438],[12443,12543],[12549,12591],[12593,12686],[12688,12773],[12783,12830],[12832,42124],[42128,42182],[42192,42539],[42560,42606],[42608,42611],[42622,42653],[42656,42735],[42738,42743],[42752,42972],[42993,43009],[43011,43013],[43015,43018],[43020,43044],[43047,43051],[43056,43065],[43072,43127],[43136,43203],[43214,43225],[43250,43262],[43264,43301],[43310,43334],[43346,43347],[43359,43388],[43395,43442],[43444,43445],[43450,43451],[43454,43469],[43471,43481],[43486,43492],[43494,43518],[43520,43560],[43567,43568],[43571,43572],[43584,43586],[43588,43595],[43597,43597],[43600,43609],[43612,43643],[43645,43695],[43697,43697],[43701,43702],[43705,43709],[43712,43712],[43714,43714],[43739,43755],[43758,43765],[43777,43782],[43785,43790],[43793,43798],[43808,43814],[43816,43822],[43824,43883],[43888,44004],[44006,44007],[44009,44012],[44016,44025],[44032,55203],[55216,55238],[55243,55291],[63744,64109],[64112,64217],[64256,64262],[64275,64279],[64285,64285],[64287,64310],[64312,64316],[64318,64318],[64320,64321],[64323,64324],[64326,64975],[65008,65023],[65040,65049],[65072,65106],[65108,65126],[65128,65131],[65136,65140],[65142,65276],[65281,65470],[65474,65479],[65482,65487],[65490,65495],[65498,65500],[65504,65510],[65512,65518],[65532,65533],[65536,65547],[65549,65574],[65576,65594],[65596,65597],[65599,65613],[65616,65629],[65664,65786],[65792,65794],[65799,65843],[65847,65934],[65936,65948],[65952,65952],[66000,66044],[66176,66204],[66208,66256],[66273,66299],[66304,66339],[66349,66378],[66384,66421],[66432,66461],[66463,66499],[66504,66517],[66560,66717],[66720,66729],[66736,66771],[66776,66811],[66816,66855],[66864,66915],[66927,66938],[66940,66954],[66956,66962],[66964,66965],[66967,66977],[66979,66993],[66995,67001],[67003,67004],[67008,67059],[67072,67382],[67392,67413],[67424,67431],[67456,67461],[67463,67504],[67506,67514],[67584,67589],[67592,67592],[67594,67637],[67639,67640],[67644,67644],[67647,67669],[67671,67742],[67751,67759],[67808,67826],[67828,67829],[67835,67867],[67871,67897],[67903,67929],[67968,68023],[68028,68047],[68050,68096],[68112,68115],[68117,68119],[68121,68149],[68160,68168],[68176,68184],[68192,68255],[68288,68324],[68331,68342],[68352,68405],[68409,68437],[68440,68466],[68472,68497],[68505,68508],[68521,68527],[68608,68680],[68736,68786],[68800,68850],[68858,68899],[68912,68921],[68928,68965],[68974,68997],[69006,69007],[69216,69246],[69248,69289],[69293,69293],[69296,69297],[69314,69319],[69328,69336],[69376,69415],[69424,69445],[69457,69465],[69488,69505],[69510,69513],[69552,69579],[69600,69622],[69632,69632],[69634,69687],[69703,69709],[69714,69743],[69745,69746],[69749,69749],[69762,69810],[69815,69816],[69819,69820],[69822,69825],[69840,69864],[69872,69881],[69891,69926],[69932,69932],[69942,69959],[69968,70002],[70004,70006],[70018,70069],[70079,70088],[70093,70094],[70096,70111],[70113,70132],[70144,70161],[70163,70190],[70194,70195],[70197,70197],[70200,70205],[70207,70208],[70272,70278],[70280,70280],[70282,70285],[70287,70301],[70303,70313],[70320,70366],[70368,70370],[70384,70393],[70402,70403],[70405,70412],[70415,70416],[70419,70440],[70442,70448],[70450,70451],[70453,70457],[70461,70463],[70465,70468],[70471,70472],[70475,70477],[70480,70480],[70487,70487],[70493,70499],[70528,70537],[70539,70539],[70542,70542],[70544,70581],[70583,70586],[70594,70594],[70597,70597],[70599,70602],[70604,70605],[70607,70607],[70609,70609],[70611,70613],[70615,70616],[70656,70711],[70720,70721],[70725,70725],[70727,70747],[70749,70749],[70751,70753],[70784,70834],[70841,70841],[70843,70846],[70849,70849],[70852,70855],[70864,70873],[71040,71089],[71096,71099],[71102,71102],[71105,71131],[71168,71218],[71227,71228],[71230,71230],[71233,71236],[71248,71257],[71264,71276],[71296,71338],[71340,71340],[71342,71343],[71350,71350],[71352,71353],[71360,71369],[71376,71395],[71424,71450],[71454,71454],[71456,71457],[71462,71462],[71472,71494],[71680,71726],[71736,71736],[71739,71739],[71840,71922],[71935,71942],[71945,71945],[71948,71955],[71957,71958],[71960,71989],[71991,71992],[71997,71997],[71999,72002],[72004,72006],[72016,72025],[72096,72103],[72106,72147],[72156,72159],[72161,72164],[72192,72192],[72203,72242],[72249,72250],[72255,72262],[72272,72272],[72279,72280],[72284,72329],[72343,72343],[72346,72354],[72368,72440],[72448,72457],[72545,72545],[72549,72549],[72551,72551],[72640,72673],[72688,72697],[72704,72712],[72714,72751],[72766,72766],[72768,72773],[72784,72812],[72816,72847],[72873,72873],[72881,72881],[72884,72884],[72960,72966],[72968,72969],[72971,73008],[73030,73030],[73040,73049],[73056,73061],[73063,73064],[73066,73102],[73107,73108],[73110,73110],[73112,73112],[73120,73129],[73136,73179],[73184,73193],[73440,73458],[73461,73464],[73474,73488],[73490,73525],[73534,73535],[73537,73537],[73539,73561],[73648,73648],[73664,73713],[73727,74649],[74752,74862],[74864,74868],[74880,75075],[77712,77810],[77824,78895],[78913,78918],[78944,82938],[82944,83526],[90368,90397],[90410,90412],[90416,90425],[92160,92728],[92736,92766],[92768,92777],[92782,92862],[92864,92873],[92880,92909],[92917,92917],[92928,92975],[92983,92997],[93008,93017],[93019,93025],[93027,93047],[93053,93071],[93504,93561],[93760,93850],[93856,93880],[93883,93907],[93952,94026],[94032,94087],[94099,94111],[94176,94179],[94192,94198],[94208,101589],[101631,101662],[101760,101874],[110576,110579],[110581,110587],[110589,110590],[110592,110882],[110898,110898],[110928,110930],[110933,110933],[110948,110951],[110960,111355],[113664,113770],[113776,113788],[113792,113800],[113808,113817],[113820,113820],[113823,113823],[117760,118012],[118016,118451],[118458,118480],[118496,118512],[118608,118723],[118784,119029],[119040,119078],[119081,119142],[119146,119154],[119171,119172],[119180,119209],[119214,119274],[119296,119361],[119365,119365],[119488,119507],[119520,119539],[119552,119638],[119648,119672],[119808,119892],[119894,119964],[119966,119967],[119970,119970],[119973,119974],[119977,119980],[119982,119993],[119995,119995],[119997,120003],[120005,120069],[120071,120074],[120077,120084],[120086,120092],[120094,120121],[120123,120126],[120128,120132],[120134,120134],[120138,120144],[120146,120485],[120488,120779],[120782,121343],[121399,121402],[121453,121460],[121462,121475],[121477,121483],[122624,122654],[122661,122666],[122928,122989],[123136,123180],[123191,123197],[123200,123209],[123214,123215],[123536,123565],[123584,123627],[123632,123641],[123647,123647],[124112,124139],[124144,124153],[124368,124397],[124400,124410],[124415,124415],[124608,124638],[124640,124642],[124644,124645],[124647,124653],[124656,124660],[124670,124671],[124896,124902],[124904,124907],[124909,124910],[124912,124926],[124928,125124],[125127,125135],[125184,125251],[125259,125259],[125264,125273],[125278,125279],[126065,126132],[126209,126269],[126464,126467],[126469,126495],[126497,126498],[126500,126500],[126503,126503],[126505,126514],[126516,126519],[126521,126521],[126523,126523],[126530,126530],[126535,126535],[126537,126537],[126539,126539],[126541,126543],[126545,126546],[126548,126548],[126551,126551],[126553,126553],[126555,126555],[126557,126557],[126559,126559],[126561,126562],[126564,126564],[126567,126570],[126572,126578],[126580,126583],[126585,126588],[126590,126590],[126592,126601],[126603,126619],[126625,126627],[126629,126633],[126635,126651],[126704,126705],[126976,127019],[127024,127123],[127136,127150],[127153,127167],[127169,127183],[127185,127221],[127232,127405],[127462,127490],[127504,127547],[127552,127560],[127568,127569],[127584,127589],[127744,128728],[128732,128748],[128752,128764],[128768,128985],[128992,129003],[129008,129008],[129024,129035],[129040,129095],[129104,129113],[129120,129159],[129168,129197],[129200,129211],[129216,129217],[129232,129240],[129280,129623],[129632,129645],[129648,129660],[129664,129674],[129678,129734],[129736,129736],[129741,129756],[129759,129770],[129775,129784],[129792,129938],[129940,130042],[131072,173791],[173824,178205],[178208,183981],[183984,191456],[191472,192093],[194560,195101],[196608,201546],[201552,210041]];

function findBlock(cp,blocks){
  let lo=0,hi=blocks.length-1;
  while(lo<=hi){const mid=(lo+hi)>>1,b=blocks[mid];if(cp<b.start)hi=mid-1;else if(cp>b.end)lo=mid+1;else return mid}
  return -1}
function countCPs(ranges){let t=0;for(const r of ranges)t+=r[1]-r[0]+1;return t}
function computeFilteredTotal(cpRanges,blocks){
  let t=0;
  for(const r of cpRanges)
    for(let cp=r[0];cp<=r[1];cp++)
      if(findBlock(cp,blocks)>=0)t++;
  return t}
async function loadBlocks(){
  const loadCPs=async()=>{
    const r=await fetch('codepoints.json',{signal:AbortSignal.timeout(5000)});
    if(!r.ok)throw Error(String(r.status));
    return JSON.parse(await r.text())};
  if(location.protocol==='file:'){
    allBlocks=INLINE_BLOCKS;hanBlocks=INLINE_HAN;
    codepointRanges=INLINE_CODEPOINTS;
    unicodeTotal=countCPs(codepointRanges);
    unihanTotal=computeFilteredTotal(codepointRanges,INLINE_HAN);
    return}
  try{
    const[blocksResp,cpsResp]=await Promise.all([
      fetch(BLOCKS_URL,{signal:AbortSignal.timeout(5000)}),
      loadCPs()]);
    if(!blocksResp.ok)throw Error(String(blocksResp.status));
    const text=await blocksResp.text();
    const blocks=[];
    for(const line of text.split('\n')){
      const t=line.trim();
      if(!t||t.startsWith('#')||!t.includes(';'))continue;
      const[range,name]=t.split(';').map(s=>s.trim());
      const[s,e]=range.split('..').map(s=>parseInt(s.trim(),16));
      blocks.push({name,start:s,end:e});}
    allBlocks=blocks;hanBlocks=blocks.filter(b=>HAN_RE.test(b.name));
    codepointRanges=cpsResp;
    unicodeTotal=countCPs(codepointRanges);
    unihanTotal=computeFilteredTotal(codepointRanges,hanBlocks);
  }catch(e){console.warn('Data fetch failed:',e);
    allBlocks=INLINE_BLOCKS;hanBlocks=INLINE_HAN;
    codepointRanges=INLINE_CODEPOINTS;
    unicodeTotal=countCPs(codepointRanges);
    unihanTotal=computeFilteredTotal(codepointRanges,INLINE_HAN);}
}
const blocksPromise=loadBlocks();
const CJK_EXT_BLOCKS=[
  {key:'cjkExtA',start:0x3400,end:0x4DBF,sample:16},
  {key:'cjkExtB',start:0x20000,end:0x2A6DF,sample:16,milestone:'2003 新增: 龦-龵'},
  {key:'cjkExtC',start:0x2A700,end:0x2B73F,sample:16},
  {key:'cjkExtD',start:0x2B740,end:0x2B81F,sample:16,milestone:'2012 新增: 鿌'},
   {key:'cjkExtE',start:0x2B820,end:0x2CEAF,sample:16,milestone:'2015 人名地名用字'},
  {key:'cjkExtF',start:0x2CEB0,end:0x2EBEF,sample:16,milestone:'2017 新增: 鿥-鿠'},
  {key:'cjkExtG',start:0x30000,end:0x3134F,sample:16,milestone:'2021 急用科技用字: 鿰-鿼'},
  {key:'cjkExtH',start:0x31350,end:0x323AF,sample:16,milestone:'2022 新增: 𫜹'},
  {key:'cjkExtI',start:0x2EBF0,end:0x2EE5F,sample:16},
  {key:'cjkExtJ',start:0x323B0,end:0x3347F,sample:16},
];

/* ==========================================
   Utils
   ========================================== */
function h(tag,cls,txt){const e=document.createElement(tag);if(cls)e.className=cls;if(txt!==undefined)e.textContent=txt;return e}
function filterChip(label,active,onClick){
  const c=h('button','chip state-layer'+(active?' active':''));
  c.type='button';
  c.setAttribute('aria-pressed',String(active));
  if(active){
    const svg=document.createElementNS('http://www.w3.org/2000/svg','svg');
    svg.setAttribute('class','chip-check');svg.setAttribute('viewBox','0 -960 960 960');
    svg.innerHTML='<path d="M382-240 154-468l57-57 171 171 367-367 57 57-424 424Z"/>';
    c.append(svg);
  }
  c.append(h('span','',label));
  c.addEventListener('click',createRipple);
  if(onClick)c.addEventListener('click',onClick);
  return c;
}
function updateSliderFill(input){
  const pct=(input.value-input.min)/(input.max-input.min)*100;
  input.style.setProperty('--fill-pct',pct+'%');
  const track=input.parentElement;
  const stop=track&&track.querySelector('.slider-stop');
  if(stop){
    const thumbW=4,gap=8,dotW=4;
    const w=input.offsetWidth||track.offsetWidth;
    const frac=(input.value-input.min)/(input.max-input.min);
    const thumbCenter=frac*(w-thumbW)+thumbW/2;
    const thumbRight=thumbCenter+thumbW/2;
    const restX=w-8;                     /* center of right corner radius */
    const followX=thumbCenter-thumbW/2-gap-dotW/2; /* left of thumb */
    const cover=thumbRight+gap+dotW/2>restX;
    stop.style.opacity=cover?'0':'1';
  }
}
function gradeBlock(pct){if(pct>=99.99)return'PG';if(pct>=96)return'EX';if(pct>=90)return'A';if(pct>=82)return'B';if(pct>=70)return'C';if(pct>=62)return'D';if(pct>=42)return'E';return'F'}
function gradeColor(g){return{PG:'#00BCD4',EX:'#4CAF50',A:'#8BC34A',B:'#CDDC39',C:'#FFEB3B',D:'#FFC107',E:'#FF9800',F:'#F44336'}[g]||'#F44336'}
function parseUnicode(text){return text.replace(/U\+([0-9A-Fa-f]{4,6})/g,(_,hex)=>String.fromCodePoint(parseInt(hex,16)))}
function createRipple(e){
  const el=e.currentTarget;
  const ripple=document.createElement('span');
  ripple.className='md-ripple';
  const rect=el.getBoundingClientRect();
  const size=Math.max(rect.width,rect.height);
  ripple.style.width=ripple.style.height=size+'px';
  ripple.style.left=(e.clientX-rect.left-size/2)+'px';
  ripple.style.top=(e.clientY-rect.top-size/2)+'px';
  el.appendChild(ripple);
  ripple.addEventListener('animationend',()=>ripple.remove());
}

/* ==========================================
   State
   ========================================== */
const S={tab:'home',lang:detectLang(),
  latinType:'sans',
  cjkLang:'zh-Hans',cjkType:'sans',
  compareSelected:new Set([0,1]),
  charsetRange:'Latin',
  globalSize:32,globalWeight:400,customText:'永 の 한 A 6',
  coverageRunning:false,coverageResultsUnihan:null,coverageResultsUnicode:null,coverageProgress:0,coverageHidePerfect:false,coverageMode:'unihan',coveragePreview:'',coverageCurrentCP:'',coverageCurrentBlock:'',coverageTested:0,coverageTestedTotal:0,
  langMenuOpen:false,
};

/* ==========================================
   Lang Switcher (MD3 Icon Button + Menu)
   ========================================== */
function renderLangSwitcher(){
  const container=document.getElementById('langSwitcher');container.innerHTML='';
  const btn=h('button','lang-icon-btn state-layer');
  btn.setAttribute('aria-haspopup','true');
  btn.setAttribute('aria-expanded',String(S.langMenuOpen));
  btn.setAttribute('aria-label',t('langLabel'));
  btn.addEventListener('click',createRipple);
  const globeIcon=document.createElementNS('http://www.w3.org/2000/svg','svg');
  globeIcon.setAttribute('viewBox','0 -960 960 960');globeIcon.setAttribute('fill','currentColor');
  globeIcon.innerHTML='<path d="m480-80-40-120H160q-33 0-56.5-23.5T80-280v-520q0-33 23.5-56.5T160-880h240l35 120h365q35 0 57.5 22.5T880-680v520q0 33-22.5 56.5T800-80H480ZM286-376q69 0 113.5-44.5T444-536q0-8-.5-14.5T441-564H283v62h89q-8 28-30.5 43.5T287-443q-39 0-67-28t-28-69q0-41 28-69t67-28q18 0 34 6.5t29 19.5l49-47q-21-22-50.5-34T286-704q-67 0-114.5 47.5T124-540q0 69 47.5 116.5T286-376Zm268 20 22-21q-14-17-25.5-33T528-444l26 88Zm50-51q28-33 42.5-63t19.5-47H507l12 42h40q8 15 19 32.5t26 35.5Zm-84 287h280q18 0 29-11.5t11-28.5v-520q0-18-11-29t-29-11H447l47 162h79v-42h41v42h146v41h-51q-10 38-30 74t-47 67l109 107-29 29-108-108-36 37 32 111-80 80Z"/>';
  btn.append(globeIcon);
  btn.onclick=(e)=>{e.stopPropagation();S.langMenuOpen=!S.langMenuOpen;document.getElementById('langMenu').classList.toggle('open',S.langMenuOpen);btn.setAttribute('aria-expanded',String(S.langMenuOpen))};
  const menu=h('div','lang-menu');menu.id='langMenu';menu.setAttribute('role','menu');
  Object.keys(LANGS).forEach(code=>{
    const item=h('button','lang-menu-item'+(S.lang===code?' active':''));
    item.setAttribute('role','menuitem');
    item.addEventListener('click',createRipple);
    item.onclick=()=>{S.lang=code;S.langMenuOpen=false;localStorage.setItem('gsm_lang',code);render()};
    const label=h('span','',LANG_LABELS[code]||code);
    item.append(label);
    menu.append(item);
  });
  container.append(btn,menu);
}
document.addEventListener('click',()=>{S.langMenuOpen=false;const m=document.getElementById('langMenu');if(m)m.classList.remove('open')});

/* ==========================================
   MD3 Tonal Elevation (scroll)
   ========================================== */
(function(){
  var tb=document.querySelector('.top-bar');
  if(!tb)return;
  var ticking=false;
  window.addEventListener('scroll',function(){
    if(!ticking){requestAnimationFrame(function(){
      var y=window.scrollY;
      tb.classList.toggle('scrolled',y>0);
      ticking=false;
    });ticking=true;}
  },{passive:true});
})();

/* ==========================================
   Home Tab
   ========================================== */
function renderHome(parent){
  parent.append(h('h2','section-title',t('tabHome')));
  const card=h('div','card');const ctrl=h('div','controls');

  const szField=h('div','field');
  const szHead=h('div','field-header');
  szHead.append(h('span','field-label',t('fontSize')));
  const szNum=document.createElement('input');szNum.type='number';szNum.className='field-value';szNum.min='8';szNum.max='96';szNum.value=S.globalSize;szNum.setAttribute('aria-label',t('fontSize'));
  szHead.append(szNum);szField.append(szHead);
  const szTrack=h('div','slider-track');
  const szIn=document.createElement('input');szIn.type='range';szIn.min='8';szIn.max='96';szIn.value=S.globalSize;szIn.setAttribute('aria-label',t('fontSize'));
  szTrack.append(szIn,h('div','slider-stop'));updateSliderFill(szIn);szField.append(szTrack);ctrl.append(szField);

  const wtField=h('div','field');
  const wtHead=h('div','field-header');
  wtHead.append(h('span','field-label',t('fontWeight')));
  const wtNum=document.createElement('input');wtNum.type='number';wtNum.className='field-value';wtNum.min='1';wtNum.max='1000';wtNum.value=S.globalWeight;wtNum.setAttribute('aria-label',t('fontWeight'));
  wtHead.append(wtNum);wtField.append(wtHead);
  const wtTrack=h('div','slider-track');
  const wtIn=document.createElement('input');wtIn.type='range';wtIn.min='1';wtIn.max='1000';wtIn.value=S.globalWeight;wtIn.setAttribute('aria-label',t('fontWeight'));
  wtTrack.append(wtIn,h('div','slider-stop'));updateSliderFill(wtIn);wtField.append(wtTrack);ctrl.append(wtField);

  const txField=h('div','text-field');
  const txIn=document.createElement('input');txIn.type='text';txIn.id='gsm-custom-text';txIn.value=S.customText;txIn.placeholder=' ';txIn.className='text-field-input';
  const txLabel=h('label','text-field-label',t('customText'));txLabel.setAttribute('for','gsm-custom-text');
  txField.append(txIn,txLabel);ctrl.append(txField);
  card.append(ctrl);parent.append(card);
  requestAnimationFrame(()=>{updateSliderFill(szIn);updateSliderFill(wtIn)});
  const onResize=()=>{if(!document.body.contains(szIn)){window.removeEventListener('resize',onResize);return}updateSliderFill(szIn);updateSliderFill(wtIn)};
  window.addEventListener('resize',onResize);
  const parsed=parseUnicode(S.customText);
  parent.append(h('h2','section-title',t('sansLabel')));
  renderVFPreview(parent,parsed,'sans-serif',S.globalWeight,S.globalSize);
  parent.append(h('h2','section-title',t('serifLabel')));
  renderVFPreview(parent,parsed,'serif',S.globalWeight,S.globalSize);
  parent.append(h('h2','section-title',t('monoLabel')));
  renderVFPreview(parent,parsed,'monospace',S.globalWeight,S.globalSize);
  function updateHome(){
    const size=S.globalSize+'px';
    const txt=parseUnicode(S.customText);
    document.querySelectorAll('.vf-preview-text, .weight-text').forEach(el=>{el.style.fontSize=size;el.style.fontWeight=S.globalWeight;el.textContent=txt});
  }
  szIn.addEventListener('input',()=>{S.globalSize=parseInt(szIn.value);szNum.value=S.globalSize;updateSliderFill(szIn);updateHome()});
  szNum.addEventListener('input',()=>{let v=parseInt(szNum.value);if(isNaN(v))return;if(v<8)v=8;if(v>96)v=96;S.globalSize=v;szIn.value=v;updateSliderFill(szIn);updateHome()});
  wtIn.addEventListener('input',()=>{S.globalWeight=parseInt(wtIn.value);wtNum.value=S.globalWeight;updateSliderFill(wtIn);updateHome()});
  wtNum.addEventListener('input',()=>{let v=parseInt(wtNum.value);if(isNaN(v))return;if(v<1)v=1;if(v>1000)v=1000;S.globalWeight=v;wtIn.value=v;updateSliderFill(wtIn);updateHome()});
  txIn.addEventListener('input',()=>{S.customText=txIn.value;updateHome()});
}

/* ==========================================
   VF Preview
   ========================================== */
function renderVFPreview(parent,text,fontFamily,weight,size){
  const vp=h('div','vf-preview');
  vp.append(h('div','vf-preview-title',t('preview')));
  const vt=h('div','vf-preview-text');
  vt.style.fontFamily=fontFamily;
  vt.style.fontWeight=weight||S.globalWeight;
  vt.style.fontSize=(size||S.globalSize)+'px';
  vt.textContent=parseUnicode(text);
  vp.append(vt);parent.append(vp);
}

/* ==========================================
   Weight Grid (upright + italic sections)
   ========================================== */
function renderWeightGrid(parent,fontFamily,weights,text,fontSize){
  const regCard=h('div','card');
  regCard.append(h('h3','section-title',t('sectionRegular')));
  const regGrid=h('div','weight-grid');
  weights.forEach(w=>{
    const row=h('div','weight-row');row.append(h('span','weight-num',String(w)));
    const tEl=h('div','weight-text');tEl.style.fontWeight=w;tEl.style.fontFamily=fontFamily;
    if(fontSize)tEl.style.fontSize=fontSize+'px';
    tEl.textContent=text;row.append(tEl);regGrid.append(row);
  });
  regCard.append(regGrid);parent.append(regCard);
  const itaCard=h('div','card');
  itaCard.append(h('h3','section-title',t('sectionItalic')));
  const itaGrid=h('div','weight-grid');
  weights.forEach(w=>{
    const row=h('div','weight-row');row.append(h('span','weight-num',w+'i'));
    const tEl=h('div','weight-text');tEl.style.fontWeight=w;tEl.style.fontFamily=fontFamily;tEl.style.fontStyle='italic';
    if(fontSize)tEl.style.fontSize=fontSize+'px';
    tEl.textContent=text;row.append(tEl);itaGrid.append(row);
  });
  itaCard.append(itaGrid);parent.append(itaCard);
}

/* ==========================================
   Render
   ========================================== */
const app=document.getElementById('app');
const footer=document.getElementById('footer');

function renderTabs(){document.querySelectorAll('.nav-item').forEach(btn=>{const key='tab'+btn.dataset.tab.charAt(0).toUpperCase()+btn.dataset.tab.slice(1);const label=t(key);btn.querySelector('.nav-label').textContent=label;btn.setAttribute('aria-label',label)})}
function render(){
  app.innerHTML='';
  document.title=t('pageTitle');
  const tb=document.querySelector('.top-bar-title');if(tb)tb.textContent=t('pageTitle');
  renderLangSwitcher();renderTabs();
  footer.textContent=t('footer');
  ({home:renderHome,latin:renderLatin,cjk:renderCJK,compare:renderCompare,charset:renderCharset})[S.tab]?.(app);
}

function renderLatin(parent){
  parent.append(h('h2','section-title',t('tabLatin')));
  const card=h('div','card');const ctrl=h('div','controls');
  const typeGroup=h('div','chip-group');
  ['sans','serif','mono'].forEach(ty=>{typeGroup.append(filterChip(t(ty),S.latinType===ty,()=>{S.latinType=ty;render()}))});
  const typeRow=h('div','chip-row');typeRow.append(typeGroup);
  ctrl.append(typeRow);card.append(ctrl);parent.append(card);
  const map={sans:{family:'sans-serif',weights:FONTS.sans.weights,label:'sansLabel',sample:SAMPLES.sans},
    serif:{family:'serif',weights:FONTS.serif.weights,label:'serifLabel',sample:SAMPLES.serif},
    mono:{family:'monospace',weights:FONTS.mono.weights,label:'monoLabel',sample:SAMPLES.mono}};
  const cfg=map[S.latinType];
  parent.append(h('h2','section-title',t(cfg.label)));
  renderWeightGrid(parent,cfg.family,cfg.weights,cfg.sample);
}

function renderCJK(parent){
  parent.append(h('h2','section-title',t('tabCjk')));
  const card=h('div','card');const ctrl=h('div','controls');
  const langGroup=h('div','chip-group');
  Object.entries(CJK_DATA).forEach(([code,d])=>{langGroup.append(filterChip(t(d.labelKey),S.cjkLang===code,()=>{S.cjkLang=code;render()}))});
  const typeGroup=h('div','chip-group');
  ['sans','serif'].forEach(ty=>{typeGroup.append(filterChip(t(ty),S.cjkType===ty,()=>{S.cjkType=ty;render()}))});
  const langRow=h('div','chip-row');langRow.append(langGroup);
  const typeRow=h('div','chip-row');typeRow.append(typeGroup);
  ctrl.append(langRow,typeRow);card.append(ctrl);parent.append(card);
  const d=CJK_DATA[S.cjkLang];
  const sample=S.cjkType==='serif'?d.serif:d.sample;
  renderWeightGrid(parent,S.cjkType==='serif'?'serif':'sans-serif',CJK_WEIGHTS,sample);
  parent.append(h('h2','section-title',t('hentaiganaTitle')));
  const hCard=h('div','card');const hGrid=h('div','weight-grid');
  CJK_WEIGHTS.forEach(w=>{const row=h('div','weight-row');row.append(h('span','weight-num',String(w)));const tEl=h('div','weight-text');tEl.style.fontWeight=w;tEl.style.fontFamily='sans-serif';tEl.style.fontSize='18px';tEl.textContent=HENTAIGANA;row.append(tEl);hGrid.append(row)});
  hCard.append(hGrid);parent.append(hCard);
}

const COMPARE_FONTS=[
  {labelKey:'deviceFont',family:'sans-serif',weights:[100,200,300,400,500,600,700,800,900],sample:'永 A 6 気'},
  {label:'MiSans',family:"'MiSans VF',sans-serif",weights:[100,200,300,400,500,600,700,800,900],sample:'永 A 6 気'},
  {label:'Inter',family:'Inter,sans-serif',weights:[100,200,300,400,500,600,700,800,900],sample:'永 A 6 気'},
  {label:'Roboto Flex',family:'Roboto Flex,sans-serif',weights:[100,200,300,400,500,600,700,800,900],sample:'永 A 6 気'},
  {label:'Noto Sans SC',family:"'Noto Sans SC',sans-serif",weights:[100,200,300,400,500,600,700,800,900],sample:'永 A 6 気'},
];
function fontLabel(f){return f.labelKey?t(f.labelKey):f.label}
function renderCompare(parent){
  parent.append(h('h2','section-title',t('weightComparison')));
  const card=h('div','card');const ctrl=h('div','controls');
  const fontGroup=h('div','chip-group');
  COMPARE_FONTS.forEach((f,i)=>{
    fontGroup.append(filterChip(fontLabel(f),S.compareSelected.has(i),()=>{
      if(S.compareSelected.has(i)){if(S.compareSelected.size>1)S.compareSelected.delete(i)}
      else S.compareSelected.add(i);
      render();
    }));
  });
  const chipRow=h('div','chip-row');chipRow.append(fontGroup);
  ctrl.append(chipRow);card.append(ctrl);parent.append(card);
  COMPARE_FONTS.forEach((f,i)=>{
    if(!S.compareSelected.has(i))return;
    const fc=h('div','card');
    fc.append(h('h3','section-title',fontLabel(f)));
    const grid=h('div','weight-grid');
    f.weights.forEach(w=>{
      const row=h('div','weight-row');row.append(h('span','weight-num',String(w)));
      const tEl=h('div','weight-text');tEl.style.fontWeight=w;tEl.style.fontFamily=f.family;
      tEl.textContent=f.sample;row.append(tEl);grid.append(row);
    });
    fc.append(grid);parent.append(fc);
  });
}

function renderCharset(parent){
  parent.append(h('h2','section-title',t('characterCoverage')));
  const card=h('div','card');const ctrl=h('div','controls');
  const charsetGroup=h('div','chip-group');CHARSET.forEach(r=>{charsetGroup.append(filterChip(t(r.labelKey),S.charsetRange===r.id,()=>{S.charsetRange=r.id;render()}))});
  const chipRow=h('div','chip-row');chipRow.append(charsetGroup);
  ctrl.append(chipRow);card.append(ctrl);
  const grid=h('div','charset-grid');const range=CHARSET.find(r=>r.id===S.charsetRange)||CHARSET[0];const count=Math.min(range.end-range.start+1,500);
  for(let i=0;i<count;i++){const code=range.start+i;const cell=h('div','charset-cell');cell.textContent=String.fromCodePoint(code);const tip=h('span','tip','U+'+code.toString(16).toUpperCase().padStart(4,'0'));cell.append(tip);grid.append(cell)}
  card.append(grid);parent.append(card);
  const emojiCard=h('div','card emoji-test-card');
  emojiCard.append(h('h2','section-title',t('emojiComplexTitle')));
  emojiCard.append(h('p','emoji-test-desc',t('emojiComplexDesc')));
  const emojiGrid=h('div','emoji-test-grid');
  const fmtCps=cps=>cps.map(cp=>'U+'+cp.toString(16).toUpperCase().padStart(4,'0')).join(' ');
  EMOJI_TESTS.forEach(test=>{
    const item=h('div','emoji-test-item');
    const sample=h('div','emoji-test-sample');
    if(test.deviceFallback)sample.classList.add('emoji-test-device-fallback');
    if(test.variants){sample.classList.add('emoji-test-variants');test.variants.forEach(cps=>sample.append(h('span','',String.fromCodePoint(...cps))))}
    else sample.textContent=String.fromCodePoint(...test.cps);
    const meta=h('div','emoji-test-meta');
    meta.append(h('span','emoji-test-category',t(test.category)));
    meta.append(h('strong','emoji-test-name',t(test.name)));
    const codeText=test.variants?test.variants.map(fmtCps).join('  /  '):fmtCps(test.cps);
    meta.append(h('code','emoji-test-code',codeText));
    if(test.note)meta.append(h('span','emoji-test-note',t(test.note)));
    item.append(sample,meta);emojiGrid.append(item);
  });
  emojiCard.append(emojiGrid,h('p','emoji-test-hint',t('emojiInspectHint')));parent.append(emojiCard);
  const glyphCard=h('div','card');glyphCard.append(h('h2','section-title',t('glyphCompare')));
  glyphCard.append(h('p','',t('glyphCompareDesc')));
  const tbl=document.createElement('table');tbl.className='glyph-table';
  const thead=document.createElement('thead');const hr=document.createElement('tr');
  [t('localeSystem'),t('localeZhHans'),t('localeZhHant'),t('localeJa'),t('localeKo')].forEach(l=>{const th=document.createElement('th');th.textContent=l;hr.append(th)});
  thead.append(hr);tbl.append(thead);
  const tbody=document.createElement('tbody');
  const glyphFont="'Noto Sans CJK SC','Noto Sans CJK TC','Noto Sans CJK JP','Noto Sans CJK KR',sans-serif";
  CJK_GLYPH_CHARS.forEach(ch=>{const tr=document.createElement('tr');
    [undefined,'zh-Hans','zh-Hant','ja','ko-kr'].forEach(lang=>{const td=document.createElement('td');td.textContent=ch;td.style.fontFamily=glyphFont;if(lang)td.setAttribute('lang',lang);tr.append(td)});
    tbody.append(tr)});tbl.append(tbody);glyphCard.append(tbl);parent.append(glyphCard);
  const covCard=h('div','card');covCard.append(h('h2','section-title',t('coverageResult')));
  const covCtrl=h('div','controls');
  const modeGroup=h('div','chip-group');
  const unihanBtn=filterChip(t('coverageUnihan'),S.coverageMode==='unihan',()=>{if(!S.coverageRunning){S.coverageMode='unihan';render()}});
  const unicodeBtn=filterChip(t('coverageUnicode'),S.coverageMode==='unicode',()=>{if(!S.coverageRunning){S.coverageMode='unicode';render()}});
  if(S.coverageRunning){unihanBtn.style.opacity='0.4';unihanBtn.style.pointerEvents='none';unicodeBtn.style.opacity='0.4';unicodeBtn.style.pointerEvents='none'}
  modeGroup.append(unihanBtn,unicodeBtn);
  const modeRow=h('div','chip-row');modeRow.append(modeGroup);
  const btnRow=h('div','chip-row');
  const runBtn=h('button','btn btn-primary ripple-container state-layer',t('runTest'));
  runBtn.addEventListener('click',createRipple);
  const hideBtn=h('button','btn btn-outline state-layer'+(S.coverageHidePerfect?' active':''),t('hidePerfect'));
  hideBtn.addEventListener('click',createRipple);
  hideBtn.onclick=()=>{S.coverageHidePerfect=!S.coverageHidePerfect;render()};
  if(S.coverageRunning){hideBtn.style.opacity='0.4';hideBtn.style.pointerEvents='none'}
  btnRow.append(runBtn,hideBtn);covCtrl.append(modeRow,btnRow);covCard.append(covCtrl);
  const progDiv=h('div','');
  const progStatus=h('div','coverage-status');
  const modeTotal=S.coverageMode==='unihan'?unihanTotal:unicodeTotal;
  if(S.coverageRunning){
    const pct=S.coverageProgress||0;
    const tS=S.coverageTested||0;
    const blk=S.coverageCurrentBlock||'';
    progStatus.innerHTML=`<strong>${blk}</strong><br>${tS.toLocaleString()} / ${S.coverageTestedTotal.toLocaleString()} ${t('coverageChar')}（${pct}%）`}
  else{
    const results=S.coverageMode==='unihan'?S.coverageResultsUnihan:S.coverageResultsUnicode;
    if(results){
      const supported=results.reduce((s,r)=>s+(r.supported||0),0);
      const total=results.reduce((s,r)=>s+(r.total||0),0);
      const opct=Math.round(supported/total*100);
      progStatus.innerHTML=`${supported.toLocaleString()} / ${total.toLocaleString()} ${t('coverageChar')}（${opct}%）`}
    else progStatus.innerHTML=`0 / ${modeTotal.toLocaleString()} ${t('coverageChar')}（0%）`}
  progDiv.append(progStatus);
  const previewBox=h('div','coverage-preview-chars');
  if(S.coverageRunning&&S.coverageCurrentCP){
    previewBox.append(h('div','',S.coverageCurrentCP),h('span','',S.coveragePreview||''))}
  progDiv.append(previewBox);
  covCard.append(progDiv);
  const currentResults=S.coverageMode==='unihan'?S.coverageResultsUnihan:S.coverageResultsUnicode;
  if(currentResults){const resDiv=h('div','coverage-results');
    currentResults.forEach(bl=>{
      if(S.coverageHidePerfect&&bl.pct===100)return;
      const card=h('div','coverage-result-card');
      const top=h('div','coverage-result-top');
      top.append(h('span','coverage-result-name',bl.name));
      top.append(h('span','coverage-result-pct',bl.pct+'%'));
      card.append(top);
      const gv=h('span','coverage-result-grade grade-'+bl.grade,bl.grade);card.append(gv);
      const range=h('div','coverage-result-range');
      const fmt=cp=>'U+'+cp.toString(16).toUpperCase().padStart(4,'0');
      const ch=s=>{try{return String.fromCodePoint(s)}catch(e){return '?'}};
      const start=h('span','range-start');start.append(h('span','',fmt(bl.start)),h('span','char',ch(bl.start)));
      range.append(start);
      range.append(h('span','range-mid','—'));
      const end=h('span','range-end');end.append(h('span','',fmt(bl.end)),h('span','char',ch(bl.end)));
      range.append(end);
      card.append(range);
      resDiv.append(card)});
    covCard.append(resDiv)}
  runBtn.onclick=async()=>{
    if(S.coverageRunning)return;S.coverageRunning=true;runBtn.textContent=t('testing');runBtn.disabled=true;
    if(S.coverageMode==='unihan')S.coverageResultsUnihan=[];else S.coverageResultsUnicode=[];
    S.coverageProgress=0;S.coveragePreview='';S.coverageCurrentCP='';S.coverageCurrentBlock='';
    if(S.coverageRunning){unihanBtn.style.opacity='0.4';unihanBtn.style.pointerEvents='none';unicodeBtn.style.opacity='0.4';unicodeBtn.style.pointerEvents='none';hideBtn.style.opacity='0.4';hideBtn.style.pointerEvents='none'}
    if(!allBlocks) await blocksPromise;
    const blocks=S.coverageMode==='unihan'?hanBlocks:allBlocks;
    const blockStats=new Map();
    for(const b of blocks)blockStats.set(b.name,{name:b.name,start:b.start,end:b.end,supported:0,total:0});
    const ranges=codepointRanges;
    const total=S.coverageMode==='unihan'?unihanTotal:unicodeTotal;
    let tested=0;let previewChars='';
    S.coverageTestedTotal=total;S.coverageTested=0;
    const gc=document.createElement('canvas');gc.width=48;gc.height=48;const gx=gc.getContext('2d',{willReadFrequently:true});
    gx.fillStyle='#fff';gx.fillRect(0,0,48,48);gx.fillStyle='#000';gx.font='32px sans-serif';gx.textBaseline='middle';gx.textAlign='center';
    gx.fillText('\uFFFF',24,24);const tofuRef=gx.getImageData(0,0,48,48).data;
    function hasGlyph(c){
      gx.fillStyle='#fff';gx.fillRect(0,0,48,48);gx.fillStyle='#000';gx.fillText(c,24,24);
      const d=gx.getImageData(0,0,48,48).data;let diff=0;
      for(let i=0;i<d.length;i+=4)diff+=Math.abs(d[i]-tofuRef[i]);
      return diff>1024}
    for(const[start,end]of ranges){
      for(let cp=start;cp<=end;cp++){
        const bi=findBlock(cp,blocks);
        if(bi<0)continue;
        const b=blocks[bi];
        if(S.coverageMode==='unihan'&&!HAN_RE.test(b.name))continue;
        const stat=blockStats.get(b.name);
        S.coverageCurrentBlock=b.name;
        const ch=String.fromCodePoint(cp);
        if(hasGlyph(ch))stat.supported++;
        stat.total++;
        tested++;S.coverageProgress=Math.round(tested/total*100);S.coverageTested=tested;
        previewChars=ch+previewChars;if(previewChars.length>128)previewChars=previewChars.slice(0,128);
        S.coverageCurrentCP=ch+' U+'+cp.toString(16).toUpperCase().padStart(4,'0');
        if(tested%500===0){
          const pct=S.coverageProgress;
          progStatus.innerHTML=`<strong>${S.coverageCurrentBlock}</strong><br>${tested.toLocaleString()} / ${total.toLocaleString()} ${t('coverageChar')}（${pct}%）`;
          previewBox.textContent='';previewBox.append(h('div','',S.coverageCurrentCP),h('span','',previewChars));
          await new Promise(r=>requestAnimationFrame(r))}}}
    for(const b of blocks){
      const stat=blockStats.get(b.name);
      if(!stat||stat.total===0)continue;
      const pct=Math.round(stat.supported/stat.total*100);
      const result={name:b.name,start:b.start,end:b.end,pct,grade:gradeBlock(pct),supported:stat.supported,total:stat.total};
      if(S.coverageMode==='unihan')S.coverageResultsUnihan.push(result);else S.coverageResultsUnicode.push(result)}
    S.coverageRunning=false;runBtn.textContent=t('runTest');runBtn.disabled=false;unihanBtn.style.opacity='';unihanBtn.style.pointerEvents='';unicodeBtn.style.opacity='';unicodeBtn.style.pointerEvents='';hideBtn.style.opacity='';hideBtn.style.pointerEvents='';
    S.coverageCurrentBlock='';S.coveragePreview='';S.coverageCurrentCP='';
    render()};
  parent.append(covCard);
}

/* ==========================================
   Navigation
   ========================================== */
document.getElementById('bottomNav').addEventListener('click',e=>{const btn=e.target.closest('.nav-item');if(!btn)return;document.querySelectorAll('.nav-item').forEach(b=>b.classList.remove('active'));btn.classList.add('active');S.tab=btn.dataset.tab;render()});

render();
