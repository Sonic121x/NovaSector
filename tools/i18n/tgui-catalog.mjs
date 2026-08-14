#!/usr/bin/env node

import fs from 'node:fs';
import { createRequire } from 'node:module';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const require = createRequire(import.meta.url);
const ROOT = path.resolve(
  path.dirname(fileURLToPath(import.meta.url)),
  '../..',
);
const ts = require(path.join(ROOT, 'tgui/node_modules/typescript'));

const LOCALES = ['en', 'zh-Hans'];
const TGUI_SOURCE_DIR = path.join(ROOT, 'tgui/packages/tgui');
const TGUI_PACKAGE_I18N_DIR = path.join(ROOT, 'tgui/packages/tgui/i18n');
const STRINGS_I18N_DIR = path.join(ROOT, 'strings/i18n');
const TGUI_NAMESPACE = 'tgui';

// 可翻 prop 名的**单一来源**是 strings/i18n/policy.json：抽取器与运行时 localize.ts 各存一份
// 时，新增 prop 只改一边就会出现「目录有键界面不翻」/「界面翻了目录没键」的静默半覆盖。
const POLICY = JSON.parse(
  fs.readFileSync(path.join(ROOT, 'strings/i18n/policy.json'), 'utf8'),
);
const TRANSLATABLE_PROPS = new Set(POLICY.translatable_props);
const OPTION_TEXT_PROPS = new Set(POLICY.option_text_props);

// 偏好「feature 定义」里的 name/description（如 height_scaling.tsx 的 `name: 'Body Height'`）。
// 这些是对象字面量属性、非 JSX 文本，但 PreferencesMenu 渲染 feature.name 时经自动本地化 runtime
// 查前端目录显示。仅在 feature 定义目录下抽取，避免把任意 .tsx 里的 name/description 当文案。
const FEATURE_LABEL_PROPS = new Set(['name', 'description']);
const FEATURE_DEF_DIR = `${path.sep}PreferencesMenu${path.sep}preferences${path.sep}features${path.sep}`;

const COMMON_ZH = {
  Abandon: '放弃',
  Achievement: '成就',
  Achievements: '成就',
  Ability: '能力',
  Abilities: '能力',
  Admin: '管理员',
  Administrator: '管理员',
  Air: '空气',
  Airlock: '气闸',
  Alarm: '警报',
  Alarms: '警报',
  Alert: '警报',
  Alpha: '阿尔法',
  Asteroid: '小行星',
  Analyze: '分析',
  Amount: '数量',
  Anomaly: '异常体',
  Announcement: '公告',
  Announcements: '公告',
  Antagonist: '反派',
  Antagonists: '反派',
  APC: 'APC',
  Appearance: '外观',
  Application: '申请',
  Approve: '批准',
  Archive: '存档',
  Archived: '已存档',
  Area: '区域',
  Argument: '参数',
  Arguments: '参数',
  Atmos: '大气',
  Atmosphere: '大气',
  Attachment: '附件',
  Attack: '攻击',
  Auto: '自动',
  Available: '可用',
  Balance: '余额',
  Bank: '银行',
  Battery: '电池',
  Beaker: '烧杯',
  Belt: '带',
  Blood: '血液',
  Body: '身体',
  Book: '书籍',
  Books: '书籍',
  Browser: '浏览器',
  Build: '构建',
  Change: '更改',
  Cancelled: '已取消',
  Card: '卡',
  Cargo: '货运',
  Category: '分类',
  Charge: '电量',
  Character: '角色',
  Chemicals: '化学品',
  Chemistry: '化学',
  Clear: '清除',
  Click: '点击',
  Client: '客户端',
  Code: '代码',
  Color: '颜色',
  Command: '指挥',
  Component: '组件',
  Components: '组件',
  Confirmed: '已确认',
  Console: '控制台',
  Connection: '连接',
  Contents: '内容',
  Control: '控制',
  Controls: '控制',
  Controller: '控制器',
  Cooldown: '冷却',
  Core: '核心',
  Create: '创建',
  Crew: '船员',
  Crime: '罪名',
  Crimes: '罪名',
  Current: '当前',
  Custom: '自定义',
  Database: '数据库',
  Deck: '甲板',
  Default: '默认',
  Delete: '删除',
  Department: '部门',
  Description: '描述',
  Details: '详情',
  Direction: '方向',
  Disable: '禁用',
  Disabled: '已禁用',
  Disease: '疾病',
  Display: '显示',
  DNA: 'DNA',
  Door: '门',
  Download: '下载',
  Edit: '编辑',
  Effect: '效果',
  Effects: '效果',
  Eject: '弹出',
  Emergency: '紧急',
  Empty: '空',
  Enable: '启用',
  Enabled: '已启用',
  Enter: '输入',
  Engine: '引擎',
  Engineering: '工程',
  Entry: '条目',
  Equipment: '装备',
  Error: '错误',
  Event: '事件',
  Events: '事件',
  Experiment: '实验',
  Experiments: '实验',
  Fax: '传真',
  Failed: '失败',
  Filter: '筛选',
  Floor: '地板',
  Force: '强制',
  Frequency: '频率',
  General: '通用',
  Gene: '基因',
  Genetics: '遗传学',
  Goal: '目标',
  Goals: '目标',
  Health: '健康',
  Help: '帮助',
  ID: 'ID',
  Idle: '空闲',
  Info: '信息',
  Information: '信息',
  Input: '输入',
  Insert: '插入',
  Invalid: '无效',
  Item: '物品',
  Items: '物品',
  Key: '键',
  Law: '法律',
  Laws: '法律',
  Layer: '图层',
  Line: '行',
  List: '列表',
  Loadout: '配装',
  Lock: '锁定',
  Location: '位置',
  Log: '日志',
  Logs: '日志',
  Login: '登录',
  Logout: '登出',
  Machine: '机器',
  Map: '地图',
  Manual: '手册',
  Material: '材料',
  Materials: '材料',
  Medical: '医疗',
  Message: '消息',
  Messages: '消息',
  Menu: '菜单',
  Maximum: '最大',
  Minimum: '最小',
  Module: '模块',
  Modules: '模块',
  Mode: '模式',
  Modified: '已修改',
  Name: '名称',
  Network: '网络',
  Next: '下一个',
  New: '新建',
  Note: '备注',
  Notes: '备注',
  Notification: '通知',
  Notifications: '通知',
  Objective: '目标',
  Objectives: '目标',
  Normal: '正常',
  Open: '打开',
  Option: '选项',
  Options: '选项',
  Output: '输出',
  Overview: '概览',
  Panel: '面板',
  Parameter: '参数',
  Parameters: '参数',
  Pause: '暂停',
  Player: '玩家',
  Players: '玩家',
  Port: '端口',
  Power: '电力',
  Preset: '预设',
  Previous: '上一个',
  Print: '打印',
  Processing: '处理中',
  Progress: '进度',
  Quantity: '数量',
  Queue: '队列',
  Random: '随机',
  Range: '范围',
  Ready: '就绪',
  Reagent: '试剂',
  Reagents: '试剂',
  Reboot: '重启',
  Record: '记录',
  Records: '记录',
  Refinery: '精炼机',
  Refresh: '刷新',
  Reload: '重载',
  Remote: '远程',
  Remove: '移除',
  Rename: '重命名',
  Required: '需要',
  Reset: '重置',
  Restore: '恢复',
  Resume: '继续',
  Retry: '重试',
  Rule: '规则',
  Rules: '规则',
  Ruleset: '规则集',
  Rulesets: '规则集',
  Scanner: '扫描器',
  Scan: '扫描',
  Search: '搜索',
  Security: '安保',
  Select: '选择',
  Send: '发送',
  Server: '服务器',
  Settings: '设置',
  Shuttle: '穿梭机',
  Signal: '信号',
  Space: '太空',
  Status: '状态',
  Sort: '排序',
  Source: '来源',
  Start: '开始',
  Station: '空间站',
  Stop: '停止',
  Storage: '存储',
  Story: '故事',
  Stories: '故事',
  Submit: '提交',
  System: '系统',
  Tablet: '平板',
  Tablets: '平板',
  Target: '目标',
  Temperature: '温度',
  Text: '文本',
  Time: '时间',
  Tools: '工具',
  Toggle: '切换',
  Transfer: '转移',
  Turfs: '地格',
  Type: '类型',
  Types: '类型',
  Unknown: '未知',
  Update: '更新',
  Upload: '上传',
  User: '用户',
  Variable: '变量',
  Variables: '变量',
  Value: '值',
  View: '查看',
  Vote: '投票',
  Weather: '天气',
  Warning: '警告',
  Wizard: '巫师',
};

function translateTerm(term) {
  const titleCase = term ? `${term[0].toUpperCase()}${term.slice(1)}` : term;
  const direct = COMMON_ZH[term] ?? COMMON_ZH[titleCase];
  if (direct) {
    return direct;
  }

  const singular = term.endsWith('s') ? term.slice(0, -1) : null;
  return singular ? COMMON_ZH[singular] : null;
}

function translateNounPhrase(phrase) {
  const direct = COMMON_ZH[phrase];
  if (direct) {
    return direct;
  }

  const words = phrase.split(/[\s-]+/).filter(Boolean);
  if (!words.length) {
    return null;
  }

  const translated = [];
  for (const word of words) {
    const match = word.match(/^([^A-Za-z]*)([A-Za-z]+)([^A-Za-z]*)$/);
    if (!match) {
      return null;
    }
    const [, leading, clean, trailing] = match;
    const term = translateTerm(clean);
    if (!term) {
      return null;
    }
    translated.push(`${leading}${term}${trailing}`);
  }
  return translated.join('');
}

function phraseTranslation(source) {
  const direct = COMMON_ZH[source];
  if (direct) {
    return direct;
  }

  const colon = source.match(/^(.+):$/);
  if (colon) {
    const base = phraseTranslation(colon[1]);
    return base ? `${base}：` : null;
  }

  const question = source.match(/^(.+)\?$/);
  if (question) {
    const base = phraseTranslation(question[1]);
    return base ? `${base}？` : null;
  }

  const patterns = [
    [/^Add (.+)$/, (value) => `添加${value}`],
    [/^Adjust (.+)$/, (value) => `调整${value}`],
    [/^Apply (.+)$/, (value) => `应用${value}`],
    [/^Approve (.+)$/, (value) => `批准${value}`],
    [/^Delete (.+)$/, (value) => `删除${value}`],
    [/^Edit (.+)$/, (value) => `编辑${value}`],
    [/^Remove (.+)$/, (value) => `移除${value}`],
    [/^Reset (.+)$/, (value) => `重置${value}`],
    [/^Scan (.+)$/, (value) => `扫描${value}`],
    [/^Select (.+)$/, (value) => `选择${value}`],
    [/^Set (.+)$/, (value) => `设置${value}`],
    [/^Show (.+)$/, (value) => `显示${value}`],
    [/^Toggle (.+)$/, (value) => `切换${value}`],
    [/^View (.+)$/, (value) => `查看${value}`],
    [/^(.+) Control$/, (value) => `${value}控制`],
    [/^(.+) Controls$/, (value) => `${value}控制`],
    [/^(.+) Display$/, (value) => `${value}显示`],
    [/^(.+) Level$/, (value) => `${value}等级`],
    [/^(.+) List$/, (value) => `${value}列表`],
    [/^(.+) Log$/, (value) => `${value}日志`],
    [/^(.+) Logs$/, (value) => `${value}日志`],
    [/^(.+) Mode$/, (value) => `${value}模式`],
    [/^(.+) Name$/, (value) => `${value}名称`],
    [/^(.+) Options$/, (value) => `${value}选项`],
    [/^(.+) Panel$/, (value) => `${value}面板`],
    [/^(.+) Settings$/, (value) => `${value}设置`],
    [/^(.+) Status$/, (value) => `${value}状态`],
    [/^(.+) Type$/, (value) => `${value}类型`],
    [/^(.+) Types$/, (value) => `${value}类型`],
  ];

  for (const [regex, render] of patterns) {
    const match = source.match(regex);
    if (!match) {
      continue;
    }

    const translated = translateNounPhrase(match[1]);
    if (translated) {
      return render(translated);
    }
  }

  return translateNounPhrase(source);
}

function readJson(filePath) {
  if (!fs.existsSync(filePath)) {
    return {};
  }
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function writeJson(filePath, data) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  const sorted = {};
  for (const key of Object.keys(data).sort((a, b) => a.localeCompare(b))) {
    sorted[key] = data[key];
  }
  fs.writeFileSync(filePath, `${JSON.stringify(sorted, null, '\t')}\n`);
}

function stringsCatalogPath(locale) {
  return path.join(STRINGS_I18N_DIR, locale, `${TGUI_NAMESPACE}.json`);
}

function packageCatalogPath(locale) {
  return path.join(TGUI_PACKAGE_I18N_DIR, `${locale}.json`);
}

function walk(dir, out = []) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (entry.name === 'i18n' || entry.name === 'node_modules') {
      continue;
    }

    const entryPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      walk(entryPath, out);
      continue;
    }

    if (
      (entry.name.endsWith('.tsx') || entry.name.endsWith('.jsx')) &&
      !entry.name.includes('.test.')
    ) {
      out.push(entryPath);
    }
  }
  return out;
}

// JSX 文本节点与 JSX 属性字符串里的 HTML 实体，编译期由 JSX transform 解码：源码写
// `you&apos;re`，运行时 React 拿到的是 `you're`。TS 的 `JsxText.text` / 属性字面量 `.text`
// **不解码**，直接拿来当 key 就会造出一批永远查不到的死键（`I&apos;m sold!…`），表现为
// 「目录里明明有译文、界面照旧显示英文」。所以抽取时按 JSX 语义先解码再算 key。
// 注意 `&nbsp;` 解成 U+00A0，会被 normalizeText 的 `\s+` 折叠/trim 掉——与运行时
// localize.ts 的同款折叠一致，两端仍然对得上。
const JSX_ENTITIES = {
  amp: '&',
  apos: "'",
  bull: '•',
  copy: '©',
  ensp: ' ',
  gt: '>',
  rarr: '→',
  times: '×',
  lt: '<',
  nbsp: ' ',
  quot: '"',
};

function decodeJsxEntities(text) {
  if (typeof text !== 'string' || !text.includes('&')) {
    return text;
  }
  return text.replace(/&(#x[0-9a-fA-F]+|#\d+|[a-zA-Z]+);/g, (match, body) => {
    if (body[0] === '#') {
      const code =
        body[1] === 'x' || body[1] === 'X'
          ? Number.parseInt(body.slice(2), 16)
          : Number.parseInt(body.slice(1), 10);
      return Number.isFinite(code) ? String.fromCodePoint(code) : match;
    }
    const mapped = JSX_ENTITIES[body.toLowerCase()];
    return mapped ?? match;
  });
}

function normalizeText(text) {
  if (typeof text !== 'string') {
    return null;
  }
  const normalized = text.replace(/\s+/g, ' ').trim();
  if (!normalized || !/[A-Za-z]/.test(normalized)) {
    return null;
  }
  if (/^[\d\s.,:;()[\]{}%+\-*/<>_=|"'`!?]+$/.test(normalized)) {
    return null;
  }
  return normalized;
}

function propertyName(name) {
  if (!name) {
    return null;
  }
  if (ts.isIdentifier(name) || ts.isStringLiteral(name)) {
    return name.text;
  }
  return null;
}

function literalText(node) {
  if (!node) {
    return null;
  }
  if (ts.isStringLiteral(node) || ts.isNoSubstitutionTemplateLiteral(node)) {
    return normalizeText(node.text);
  }
  if (ts.isJsxExpression(node) && node.expression) {
    return literalText(node.expression);
  }
  return null;
}

// 「显示位置」的字符串字面量抽取（含三元两支与 ||/&&/?? 的字面量操作数）。仅用于**已知是 UI 显示**
// 的上下文（可翻 prop 的值、JSX 子表达式）→ 无需句末标点启发式（位置已保证是给玩家看的文案）。
// 系统性覆盖一大类「抽取器够不着」的 TGUI 静态文案：`content={x ? 'Retract' : 'Deploy'}`、
// `{ai_name || 'No AI Detected'}`、`{cond ? 'Unable to Interact' : 'Able to Interact'}`、`{'Search...'}`。
// 运行时 auto-localize 按英文原文查 tgui.json 翻这些渲染出的串；这里只负责把它们抽进目录。
function addDisplayExpr(catalog, node) {
  if (!node) {
    return;
  }
  if (ts.isJsxExpression(node) || ts.isParenthesizedExpression(node)) {
    return addDisplayExpr(catalog, node.expression);
  }
  if (ts.isStringLiteral(node) || ts.isNoSubstitutionTemplateLiteral(node)) {
    addText(catalog, node.text);
    return;
  }
  if (ts.isConditionalExpression(node)) {
    addDisplayExpr(catalog, node.whenTrue);
    addDisplayExpr(catalog, node.whenFalse);
    return;
  }
  if (ts.isBinaryExpression(node)) {
    const op = node.operatorToken.kind;
    if (
      op === ts.SyntaxKind.BarBarToken ||
      op === ts.SyntaxKind.AmpersandAmpersandToken ||
      op === ts.SyntaxKind.QuestionQuestionToken
    ) {
      addDisplayExpr(catalog, node.left);
      addDisplayExpr(catalog, node.right);
      return;
    }
    if (op === ts.SyntaxKind.PlusToken) {
      // 纯字面量拼接（`'WARNING: This is destructive' + ' and will wipe ALL access.'`）：
      // 源码里为了绕 80 列而折行，JS 求值后就是**一整串**，运行时按整串查表。逐个操作数抽出
      // 的半句永远查不到（且半句译文本身也没用），整条不抽则是死键——必须按求值结果折叠成
      // 一个 key，与运行时看到的字节完全一致。
      const folded = foldStringConcat(node);
      if (folded !== null) {
        addText(catalog, folded);
        return;
      }
      // 含表达式的拼接（`'Giver Tank (' + moles + ' moles at '`）运行期才成串、形状不可复原
      // （运行时只看得到成品字符串，无从知道哪几段是字面量）：整条**不抽**。抽半句只会留下
      // 永远查不到的死键，还会被 MT 译成拼不回去的碎片——与混排 children 同一道理。
    }
  }
}

/**
 * prop 值里的**运行期拼接**（`` title={`Reading: ${data.title}`} ``、`content={'Food: ' + n}`）。
 *
 * 这类整串是运行期产物、永远不是目录键，`addDisplayExpr` 按「形状不可复原」整条不抽 → 框架词
 * （`Reading:` / `Mutant` / `Food Left:`）永远英文。全仓 151 处。
 *
 * 与混排 children 同一个解法：按 `Reading: {0}` 的**模板**入目录。区别在落地——children 的形状
 * 运行时还看得见（数组），prop 只剩一个成品字符串，所以要在 TS 侧按字面段做**逆匹配**还原。
 * 逆匹配是子串定位，比整串查表危险，故这里同时把合格模板记进 sidecar，运行时只对这批做逆匹配，
 * 不碰目录里那 590 多条 children 模板（`- {0}, the {1}` / `{0} of 12 total` 之流泛化骨架一旦
 * 进逆匹配面，就会把整句劫持成「中文脚手架裹英文」——DM 侧栽过这一跤）。
 */
function propTemplate(node) {
  const parts = templateParts(node);
  if (!parts) return null;
  if (!parts.some((p) => p.slot) || !parts.some((p) => p.text)) return null;
  let slot = 0;
  let template = '';
  let literal = '';
  for (const part of parts) {
    if (part.text !== undefined) {
      template += part.text;
      literal += part.text;
    } else {
      template += `{${slot++}}`;
    }
  }
  template = template.replace(/\s+/g, ' ').trim();
  // 逆匹配安全线：字面段要能当锚。太短或没有真词的骨架（`{0} - {1}`、`{0}: {1}`、`({0})`）
  // 会匹配上任何同形状的串，把捕获到的英文塞进中文脚手架 —— 比不翻更难看。
  if (literal.replace(/\s+/g, ' ').trim().length < 5) return null;
  if (!/[A-Za-z]{3}/.test(literal)) return null;
  // 字面段全是虚词/标点的骨架（`{0} from {1}, {2}` —— 锚只有 " from " 和 ", "）会匹配上任何
  // 含这几个词的整句：实测能吃掉目录里 27 条正常句子。必须有一个**实词**锚才算可定位。
  if (!/\b(?!(?:the|a|an|and|or|of|to|in|on|at|by|for|from|with|is|are|as|it)\b)[A-Za-z]{3,}\b/i.test(literal)) {
    return null;
  }
  return template;
}

/// 模板字面量 / 含表达式的 `+` 链 → [{text}|{slot}] 段序列；其它形状返回 null。
function templateParts(node) {
  if (!node) return null; // 布尔属性（`fitted`）没有 initializer
  if (ts.isJsxExpression(node) || ts.isParenthesizedExpression(node)) {
    return node.expression ? templateParts(node.expression) : null;
  }
  if (ts.isStringLiteral(node) || ts.isNoSubstitutionTemplateLiteral(node)) {
    return [{ text: node.text }];
  }
  if (ts.isTemplateExpression(node)) {
    const out = [];
    if (node.head.text) out.push({ text: node.head.text });
    for (const span of node.templateSpans) {
      out.push({ slot: true });
      if (span.literal.text) out.push({ text: span.literal.text });
    }
    return out;
  }
  if (
    ts.isBinaryExpression(node) &&
    node.operatorToken.kind === ts.SyntaxKind.PlusToken
  ) {
    const left = templateParts(node.left);
    if (!left) return null;
    const right = templateParts(node.right);
    if (!right) return null;
    return [...left, ...right];
  }
  // 任意其它表达式（标识符、调用、三元…）在成品串里就是一段不可知文本 → 占位符。
  return [{ slot: true }];
}

/// 把「操作数全是字符串字面量」的 `+` 链求值成一整串；含任何非字面量则返回 null。
function foldStringConcat(node) {
  if (ts.isParenthesizedExpression(node)) {
    return foldStringConcat(node.expression);
  }
  if (ts.isStringLiteral(node) || ts.isNoSubstitutionTemplateLiteral(node)) {
    return node.text;
  }
  if (
    ts.isBinaryExpression(node) &&
    node.operatorToken.kind === ts.SyntaxKind.PlusToken
  ) {
    const left = foldStringConcat(node.left);
    if (left === null) {
      return null;
    }
    const right = foldStringConcat(node.right);
    if (right === null) {
      return null;
    }
    return left + right;
  }
  return null;
}

/// 剥离 DM 语法宏（\improper/\proper），使抽出的串与运行时 TGUI 收到的（宏已解析）对齐。
function stripGrammarMacros(text) {
  return typeof text === 'string' ? text.replace(/\\(improper|proper)\s*/g, '') : text;
}

/**
 * 当前正在扫的来源标识（`tgui:ChemReactionChamber` / `dm:code/…/food.dm`）。
 *
 * 用模块级变量而不是给 addText 加参数：addText/addDisplayExpr 有十几处调用点、还嵌在
 * 递归 visit 里，逐个穿参数改动面大且容易漏。脚本是单线程顺序扫描，扫每个文件前设一次即可。
 */
let currentScope = null;

/**
 * 英文串 -> 出现过的来源集合。与 DM 侧的 strings/i18n/scopes.json 同一用途（语境消歧），
 * 但**分开落盘**：那个文件归 nova-i18n extract（Rust）写，两个写者共用一个文件迟早互相覆盖。
 *
 * 注意 TGUI 目录的 key **就是英文原文**，所以一个 key 可能同时属于多个界面
 * （`"Basic"` 在 Crayon 里是「基础」色系分组，在化学界面里该是「碱性」）。
 * scope 能**报出**这种冲突，但解决不了——同一个 key 只能有一个译文。真要分开译，
 * 得让前端按界面取不同译文，那是另一套改动。
 */
const textScopes = {};

/**
 * 允许运行时**逆匹配**的模板 key（只收 prop 里的运行期拼接，见 propTemplate）。
 *
 * 目录里另有 590+ 条 children 模板，它们运行时按整条精确查表、不需要也**不应**进逆匹配面：
 * `- {0}, the {1}` / `{0} of 12 total` 这类泛化骨架会把任意同形状的整句劫持成中文脚手架裹英文。
 */
const propTemplates = new Set();

function noteScope(normalized) {
  if (!currentScope || !normalized) return;
  (textScopes[normalized] ??= new Set()).add(currentScope);
}

function addText(catalog, text) {
  const normalized = normalizeText(stripGrammarMacros(text));
  if (normalized) {
    catalog[normalized] = normalized;
    noteScope(normalized);
  }
}

// 「标识符耦合的 DM 显示名」——这些 name/title 在 TGUI 里既是显示又是 act() 标识符（食物类别、
// 职业、怪癖…），不能让 DM 端 P1 改数据（会破坏 act）。改为从 DM 源读进前端 tgui 目录，由 TS
// runtime 只翻**显示**（act 用原英文值，安全）；运行时 P1 会跳过出现在 tgui 目录里的串。
// runtime 无多词门槛，单词类（Meat/Cursed…）也能命中。
// 每项：[相对路径, 是否递归扫目录下 .dm, 捕获组1=可翻串的正则(必须 /g)]。
// 注意：路径钉死，上游若重命名这些目录，抽取会静默漏掉（少翻、不崩、不冲突），改路径即可。
const DM_LABEL_SOURCES = [
  // 食物类别：全局列表的引号键。
  ['code/__DEFINES/~nova_defines/_globalvars/food.dm', false, /"([^"]+)"\s*=/g],
  // 职业名/部门名：job_types 用 `title = JOB_X`（#define 常量），字面量在 jobs.dm 的 #define 里。
  ['code/__DEFINES/jobs.dm', false, /#define\s+\w+\s+"([^"]+)"/g],
  ['modular_nova/master_files/code/__DEFINES', true, /#define\s+JOB_\w+\s+"([^"]+)"/g],
  // 怪癖名：各 quirk 子类型的 `name = "..."`。核心 quirks 目录全是 quirk，直接抽；modular_nova 的
  // quirk 散在 master_files/datums/{quirks,traits}、modules/*_quirk、lewd_quirks、changeling 等
  // 20+ 处 → 用 requireMarker '/datum/quirk' 递归扫、只取 quirk 文件的 name(不碰物品/生物名)。
  ['code/datums/quirks', true, /^\s*name\s*=\s*"([^"]+)"/gm],
  ['modular_nova', true, /^\s*name\s*=\s*"([^"]+)"/gm, '/datum/quirk'],
  // 替代职业名(alt_titles 下拉选项)：每行一个 "Title",。按名选择但前端只翻显示=安全。
  ['modular_nova/modules/alternative_job_titles', true, /^\s+"([A-Za-z][^"]*)",?\s*$/gm],
  // 人格名（特质与个性→人格 tab；按 datum 路径选择，name 仅显示=安全）。
  ['code/datums/personality', true, /^\s*name\s*=\s*"([^"]+)"/gm],
  ['modular_nova/master_files/code/datums/personality', true, /^\s*name\s*=\s*"([^"]+)"/gm],
  // 配装分类 Tab 名（loadout 顶部 Head/Face/Suits/Neck…，用 `category_name = "..."`，
  // 与物品名的 `name=` 不同正则；前端按分类切换、显示走目录翻=安全）。
  ['code/modules/loadout/categories', true, /\bcategory_name\s*=\s*"([^"]+)"/g],
  ['code/modules/loadout/loadout_categories.dm', false, /\bcategory_name\s*=\s*"([^"]+)"/g],
  ['modular_nova/modules/loadout/code', true, /\bcategory_name\s*=\s*"([^"]+)"/g],
  // 下游新增的配装分类（Face/Undersuit/Belt/Weapons/Toys 等）在 loadouts（复数）模块里。
  ['modular_nova/modules/loadouts', true, /\bcategory_name\s*=\s*"([^"]+)"/g],
  // loadouts（复数）模块里的配装**物品名**（Bouquet - Rose 等；按 item_path 选=显示安全）。
  ['modular_nova/modules/loadouts', true, /^\s*name\s*=\s*"([^"]+)"/gm],
  // 售货机分类 Tab 名（Vending.tsx 底部分类：Head/Accessories/Under/Suits & Skirts/Premium…）。
  // build_inventory 的分类 dict 用引号键 `"name" = "..."`（与机器自身 `name = ` 裸键不同正则，
  // 故不会误抽机器名）；前端按英文分类值过滤（product.category===categoryName）、仅渲染 {name}
  // 文本节点翻显示 → 译之安全（含单词类 Under/Toys/Premium）。
  ['code/modules/vending', true, /"name"\s*=\s*"([^"]+)"/g],
  ['modular_nova/modules/modular_vending', true, /"name"\s*=\s*"([^"]+)"/g],
  // 精灵配件名（发型/胡须/纹身/渐变样式…，角色设置下拉，按名选择=标识符）。
  ['code/datums/sprite_accessories.dm', false, /^\s*name\s*=\s*"([^"]+)"/gm],
  ['modular_nova/master_files/code/datums/sprite_accessories', true, /^\s*name\s*=\s*"([^"]+)"/gm],
  ['modular_nova/modules/customization/icons/sprite_accessories', true, /^\s*name\s*=\s*"([^"]+)"/gm],
  // 生殖器/胸部等 sprite accessory（角色外观下拉，如 Pair/Quad/Sextuple；按配件键选=显示安全）。
  ['modular_nova/modules/customization/modules/mob/dead/new_player/sprite_accessories', true, /^\s*name\s*=\s*"([^"]+)"/gm],
  // 语言名（语言 tab）。
  ['code/modules/language', true, /^\s*name\s*=\s*"([^"]+)"/gm],
  // 配装物品名（loadout 配装 tab；偏好按 item_path 存，name 仅显示=安全）。
  ['code/modules/loadout/categories', true, /^\s*name\s*=\s*"([^"]+)"/gm],
  ['modular_nova/modules/loadout/code', true, /^\s*name\s*=\s*"([^"]+)"/gm],
  // 物种名（角色 tab 物种浏览器；按 speciesKey/id 选择，name 仅显示=安全）。第 4 项剥 \improper/\proper
  // 宏（`name = "\improper Human"` → "Human"，与运行时 TGUI 收到的串对齐）。species_types 目录会混入
  // 少量内联器官/部件名（无害噪音：进 tgui 目录后由 TS 端翻显示、P1 跳过；非物种处仍可被翻）。
  ['code/modules/mob/living/carbon/human/species_types', true, /^\tname\s*=\s*"([^"]+)"/gm],
  ['modular_nova/modules/customization/modules/mob/living/carbon/human', true, /^\tname\s*=\s*"([^"]+)"/gm],
  // choiced 偏好「选项显示名」(角色设置下拉)。前端 dropdowns.tsx 用 {displayText, value}：
  // displayText 走目录翻显示、value 是 act 标识符保持英文=安全。只抽 display 串(非 value)。
  // 仅取定义为「字面量」的源；GLOB 动态填充的(addiction/organ/lunchbox 等)及 genital(来自
  // sprite accessories，已被上面 sprite_accessories 覆盖)不在此列。
  // 肤色显示名：GLOB.skin_tone_names 的关联值(键是 act 用的肤色 id，不抽)。mobs.dm 内仅此一处关联表。
  ['code/__HELPERS/mobs.dm', false, /^\t"[^"]+"\s*=\s*"([^"]+)",/gm],
  // 身高显示名：height_scaling_strings(键是 HUMAN_HEIGHT_* 定义)。
  ['modular_nova/modules/height_scaling/code/preferences.dm', false, /"\[HUMAN_HEIGHT_[^\]]+\]"\s*=\s*"([^"]+)"/g],
  // 脚步声选项(扁平 list，值即显示)。文件内大写引号串恰好只有这 5 个选项。
  ['modular_nova/master_files/code/modules/client/preferences/footstep_sound.dm', false, /"([A-Z][a-z]+)"/g],
  // 渗透点显示名(UPLINK_* = "PDA"/"Radio"/...)。
  ['code/modules/client/preferences/uplink_location.dm', false, /=\s*"([A-Z][^"]*)"/g],
  // 体型(body_type)下拉的 "Use gender" 选项(#define USE_GENDER)。另两项 MALE/FEMALE 是 define("male"/
  // "female")，前端 capitalizeFirst→"Male"/"Female"，由下面 display_gender 的同名字面量覆盖。
  ['code/modules/client/preferences/body_type.dm', false, /#define\s+USE_GENDER\s+"([^"]+)"/g],
  // 角色档案下拉:角色性别(display_gender)+角色吸引力(attraction)的 init_possible_values 字面量选项
  // ("Unset"/"Check OOC"/"Male"/"Nonbinary"/"Genderfluid"/"Straight"/"Bisexual"…)。choiced 选项是
  // {displayText,value}: value 回传给 act 保持英文=安全，仅 displayText 走前端目录翻显示。整行只是
  // 一个首字母大写引号串(选项列表项)才取，避开 `savefile_key="…"`(行内有 `key=`、且小写)。
  ['modular_nova/modules/character_directory/code/character_directory.dm', false, /^\s*"([A-Z][^"]*)",?\s*$/gm],
  // ERP 偏好下拉(角色 setup,同上 choiced 机制):erp_status/erp_status_nc/_v/_mechanics/_hypno/
  // erp_sexuality 的字面量选项("No"/"Ask (L)OOC"/"Yes - Dom"/"Roleplay only"/"Gay"…)。
  ['modular_nova/master_files/code/modules/client/preferences/erp_preferences.dm', false, /^\s*"([A-Z][^"]*)"\s*,?\s*$/gm],
  // 角色预览背景(background_state)下拉选项("Black"/"White Tiles"/"Reinforced Floor"…,角色 setup 可见)。
  ['modular_nova/modules/character_preview_background/code/character_preview_background.dm', false, /^\s*"([A-Z][^"]*)"\s*,?\s*$/gm],
  // entombed 任务者套装外观/硬光主题下拉(entombed_skin/entombed_hardlight_theme 的 init_possible_values
  // 字面量选项,如 "Standard"/"Corpsman"/"Standard Blue"/"Alert Amber";quirk 锁定,value==display=安全)。
  ['modular_nova/master_files/code/modules/entombed_quirk/code/entombed.dm', false, /^\s*"([A-Z][^"]*)"\s*,?\s*$/gm],
  // 偏好下拉选项中**用 #define 定义值**的(init_possible_values 返回 DEFINE，name="..." 正则与字面量
  // 选项正则都够不着，字面量在 #define 里)：预览视图(PREVIEW_PREF_* = "Job"/"Naked - Aroused"…)、
  // 硅基/合成脑类型(ORGAN_PREF_* = "Positronic Brain"/"Man-Machine Interface"…)、语音类型(VOICE_TYPE_*)。
  // 只抽首字母大写的字符串 define 值(排除数字/小写标识 define)。value 仍是英文 define=act 安全。
  ['code/__DEFINES/~nova_defines/preferences.dm', false, /#define\s+\w+\s+"([A-Z][^"]*)"/g],
  // 怪癖名用 #define 定义的(如 DEATH_CONSEQUENCES_QUIRK_NAME = "Death Degradation Disorder")，
  // 怪癖目录的 name="..." 正则够不着 → 专抽 *QUIRK_NAME* 字符串 define(name 仅显示=安全)。
  ['code/__DEFINES/~nova_defines/quirks.dm', false, /#define\s+\w*QUIRK_NAME\w*\s+"([^"]+)"/g],
  // 笑声/尖叫声下拉选项(choiced laugh/scream pref，选项来自 /datum/laugh_type、/datum/scream_type
  // 的 name="…"；选中值经 P1 已翻、但选项列表走常量资源+前端目录 miss → 全英文)。
  ['modular_nova/modules/emotes/code/laugh_datums.dm', false, /^\s*name\s*=\s*"([^"]+)"/gm],
  ['modular_nova/modules/emotes/code/scream_datums.dm', false, /^\s*name\s*=\s*"([^"]+)"/gm],
  // 腿型下拉(Normal Legs/Digitigrade Legs，#define 定义)。
  ['code/__DEFINES/mobs.dm', false, /#define\s+\w*LEGS\s+"([^"]+)"/g],
  // 装备物品偏好下拉(LOADOUT_OVERRIDE_* = "Delete job items"/"Move job to backpack"/"Place all in case")。
  ['code/__DEFINES/~nova_defines/loadouts.dm', false, /#define\s+LOADOUT_OVERRIDE_\w+\s+"([^"]+)"/g],
  // 硅基性别(代词)下拉(SILICON_* #define = "He/Him"/"She/Her"/"They/Them"/"It/Its" + use_character_gender
  // 变量 = "Use character gender")。文件内大写引号串恰好就这 5 个选项,整体抽。
  ['code/modules/client/preferences/silicon_gender.dm', false, /"([A-Z][^"]*)"/g],
  // 备用名称面板各字段**标签**(/datum/preference/name 的 `explanation = "…"`：Backup human name/
  // Hacker alias/Clown name/Mime name/Bible name/Deity name/Religion name/AI name/Cyborg name/
  // Operative Alias 等)。经 get_constant_data 发送、绕过 P1;names.tsx 用 `<LabeledList.Item
  // label={name.explanation}>` 渲染,label 在 TRANSLATABLE_PROPS → 进前端目录即翻。explanation 是
  // 纯标签(名字的值是另一字段),翻显示安全。
  ['code/modules/client/preferences/names.dm', false, /\bexplanation\s*=\s*"([^"]+)"/g],
  ['modular_nova/modules/drones/drone_naming.dm', false, /\bexplanation\s*=\s*"([^"]+)"/g],
  // 加入菜单(latejoin) tgui 窗口标题：`new(user, src, "JobSelection", "Latejoin Menu")` 的第 4 个
  // 实参。窗口标题经 Window 的 title prop(在 TRANSLATABLE_PROPS)渲染、能 auto-localize,但标题是
  // DM 字面量、JSX 抽取够不着 → 专抽该 new() 调用的标题串。
  ['code/modules/mob/dead/new_player/latejoin_menu.dm', false, /"JobSelection"\s*,\s*"([^"]+)"/g],
  // 强化+(Augments) 身体部位/植入物下拉**选项名**(/datum/augment_item 子类型的 `name="…"`，
  // 如 "Prosthetic left arm")。这页经 get_constant_data 走常量资源、绕过 P1；前端 LimbsPage 用
  // Dropdown displayText={aug.name}，act 用 option.path → name 仅显示=安全，渲染期 JSX localize 翻显示。
  ['modular_nova/modules/customization/modules/client/augment', true, /^\s*name\s*=\s*"([^"]+)"/gm],
  // 强化+ 槽位**标题**(AUGMENT_SLOT_* 定义值，如 "Left Arm"/"Chest")。slot 同时是前端 augments[slot]
  // 的 Record 键(标识符)，但渲染期只翻 <Section title={limb.slot}> 显示、底层数据不变 → 键安全。
  ['code/__DEFINES/~nova_defines/augment.dm', false, /#define\s+AUGMENT_SLOT_\w+\s+"([^"]+)"/g],
  // NtOS 软件商店（NT Software Hub）程序名（`filedesc = "Chat Client"` 等）：下载用 `filename`
  // 标识符、不用 filedesc，故 filedesc 仅显示=安全；NtosNetDownloader.tsx 渲染 {program.filedesc}
  // 文本节点 → 前端 auto-localize 翻显示。filedesc 是程序专有变量，全 modular_nova 扫亦低误抽。
  ['code/modules/modular_computers/file_system/programs', true, /\bfiledesc\s*=\s*"([^"]+)"/g],
  ['modular_nova', true, /\bfiledesc\s*=\s*"([^"]+)"/g],
  // NtOS 程序分类（PROGRAM_CATEGORY_* 定义值，如 "Device Tools"/"Games"/"Security & Records"）：
  // 前端按 prop 值（英文）过滤、仅渲染 {category} 文本节点翻显示 → 译之安全（含单词类 Games）。
  ['code/__DEFINES/modular_computer.dm', false, /#define\s+PROGRAM_CATEGORY_\w+\s+"([^"]+)"/g],
  // 制作菜单分类（CAT_* 定义值，如 "Chemistry"/"Atmospherics"/"Robotics"/"Weapons Ranged"）：
  // 经 ui_static_data 的 data["categories"] 发送，但单词类分类被 P1 多词门槛跳过 → 前端按英文值过滤、
  // 仅渲染 {category} 文本节点翻显示（act 用配方 ref/index 不用分类）→ 译之安全（含单词类）。
  ['code/__DEFINES/crafting.dm', false, /#define\s+CAT_\w+\s+"([^"]+)"/g],
  // 烹饪菜单子分类（CUISINE_*/DISH_*/MEAL_* 定义值，如 "Italian"/"Bread"/"Cake"/"Appetizer"）：
  // food crafting_ui_data 发 cuisine_category/dish_category/meal_category，PersonalCrafting/index.tsx 渲染
  // {cuisine}/{dish}/{meal} 文本节点；前端按英文值过滤（activeFoodCuisine.includes(recipe.cuisine_category)）
  // → 仅翻显示文本节点（act/filter 用英文原值）→ 译之安全（含单词类）。
  ['code/__DEFINES/crafting.dm', false, /#define\s+(?:CUISINE|DISH|MEAL)_\w+\s+"([^"]+)"/g],
  // 研究/制造机（部门原型机、外骨骼制造机、殖民地制造机…）的分类与**子分类**名
  // （RND_CATEGORY_* / RND_SUBCATEGORY_* 定义值，如 "/Tools"、"/Atmospherics Tools"）：
  // DM 发的 design.categories 是拼好的路径串（"Tools/Atmospherics Tools"），DesignBrowser.tsx 按 '/'
  // 切成树、只渲染 {category.title} 文本节点翻显示；选中/锚点/过滤全用英文原 title → 译之安全。
  // 顶层分类（Tools→工具）此前靠别处同名串偶然覆盖，子分类没有任何来源 → 二级菜单全英文。
  // 前导 '/' 是路径分隔符不是名字的一部分，用 `\/?` 吃掉，别抽进 key。
  // 只取首字母大写的值：小写的三个（initial/hacked/digitigrade）是**元分类**，DesignBrowser 的
  // BLACKLISTED_CATEGORIES 直接跳过、玩家永远看不到；抽进目录反而会让运行时把界面里任何
  // 等于 "hacked"/"initial" 的裸文本节点一起翻掉。
  ['code/__DEFINES/research', true, /#define\s+RND_(?:SUB)?CATEGORY_\w+\s+"\/?([A-Z][^"]*)"/g],
  ['code/__DEFINES/~nova_defines', true, /#define\s+RND_(?:SUB)?CATEGORY_\w+\s+"\/?([A-Z][^"]*)"/g],
  ['modular_nova', true, /#define\s+RND_(?:SUB)?CATEGORY_\w+\s+"\/?([A-Z][^"]*)"/g],
  // 待接：反派名散在 code/modules/antagonists 各处，整目录抽会混入目标/技能等海量非偏好名，需专门源。
];

function dmFilesUnder(absPath, recursive, out) {
  let stat;
  try {
    stat = fs.statSync(absPath);
  } catch {
    return out;
  }
  if (!stat.isDirectory()) {
    out.push(absPath);
    return out;
  }
  let entries;
  try {
    entries = fs.readdirSync(absPath, { withFileTypes: true });
  } catch {
    return out; // 无权限目录（如 tolgee-*）等：跳过，不崩。
  }
  for (const entry of entries) {
    const entryPath = path.join(absPath, entry.name);
    if (entry.isDirectory()) {
      if (recursive) dmFilesUnder(entryPath, recursive, out);
    } else if (entry.name.endsWith('.dm')) {
      out.push(entryPath);
    }
  }
  return out;
}

function extractDmLabels(catalog) {
  // 每项 [相对路径, 递归?, 正则(组1=可翻串)]，可选第 4 项 requireMarker：仅对**文件内容含该标记**
  // 的 .dm 抽取（用于类型过滤——如散落各处的 /datum/quirk 名，递归扫但只取 quirk 文件，不碰物品名）。
  for (const [rel, recursive, regex, requireMarker] of DM_LABEL_SOURCES) {
    for (const file of dmFilesUnder(path.join(ROOT, rel), recursive, [])) {
      let source;
      try {
        source = fs.readFileSync(file, 'utf8');
      } catch {
        continue;
      }
      if (requireMarker && !source.includes(requireMarker)) {
        continue;
      }
      for (const match of source.matchAll(regex)) {
        addText(catalog, match[1]); // addText 内部已剥 \improper/\proper
      }
    }
  }

  // AST 语义抽取层（nova-i18n labels）：与上面的正则**合并**（addText 去重 + 规整）。AST 按**类型路径 /
  // proc 语义**定位（而非文件路径正则），系统性补强：① `init_possible_values()` 返回值经预处理器展开
  // → 自动覆盖**所有 choiced 下拉**（含 #define 定义的选项），新增下拉不必再往 DM_LABEL_SOURCES 加行；
  // ② 类型作用域的 name/title（职业/怪癖/精灵配件…）对上游移动文件免疫；③ 实测比正则多覆盖约 280 条
  // 正则漏掉的真标签（反派/职业角色名、血型等）。产物 tools/i18n/dm_labels.json 由 `nova-i18n labels`
  // 生成（resync.sh 会刷新并提交）；缺失时静默跳过（CI/纯前端构建仍有正则兜底，零回归）。
  try {
    const astLabels = JSON.parse(
      fs.readFileSync(path.join(ROOT, 'tools/i18n/dm_labels.json'), 'utf8'),
    );
    if (Array.isArray(astLabels)) {
      for (const label of astLabels) {
        addText(catalog, label);
      }
    }
  } catch {
    // 没有 dm_labels.json（未生成）：跳过，正则层仍提供完整覆盖。
  }
}

// 交互菜单（modular_nova/modules/interaction_menu）的 name/description 来自 config/nova/interactions/
// 下的 JSON 数据文件（源码外 config 数据，DM/TS 抽取器都够不着）。规律：interaction.name 同时是
// **按钮显示**（InteractionsTab.tsx 的 `{interaction}` 文本节点）**和 act 标识符**（onClick 回传英文
// JS 变量 `interaction:`，再 `GLOB.interaction_instances[name]` 查表）——所以只能翻**显示**、不能翻
// 标识符。前端 auto-localize 按英文查 tgui.json 只改渲染文本（onClick 仍发英文变量）→ 安全；这同
// category（已走 title prop）一致。description 是 tooltip（TRANSLATABLE_PROP）同理。此处把它们抽进
// tgui.json，运行时 P1 也会跳过出现在 tgui 目录里的串（不动 DM ui_data 的 name=保住标识符）。
// 单文件 = 单个交互对象；`*.master.json` = 以交互名为键、值为交互对象的字典。category=="hide" 的
// 占位/示例交互跳过。
const INTERACTION_JSON_DIR = path.join(ROOT, 'config/nova/interactions');

function jsonFilesUnder(absPath, out = []) {
  let entries;
  try {
    entries = fs.readdirSync(absPath, { withFileTypes: true });
  } catch {
    return out;
  }
  for (const entry of entries) {
    const entryPath = path.join(absPath, entry.name);
    if (entry.isDirectory()) {
      jsonFilesUnder(entryPath, out);
    } else if (entry.name.endsWith('.json')) {
      out.push(entryPath);
    }
  }
  return out;
}

function extractInteractionLabels(catalog) {
  const collect = (obj) => {
    if (!obj || typeof obj !== 'object') {
      return;
    }
    if (Array.isArray(obj)) {
      for (const el of obj) {
        collect(el);
      }
      return;
    }
    // 一个交互对象：有 name 字段且非 hide 分类。message 数组等是字符串/数组，collect 自然跳过
    // （非 object）；嵌套对象（master json 的值）继续递归。
    if (typeof obj.name === 'string' && obj.category !== 'hide') {
      addText(catalog, obj.name);
      if (typeof obj.description === 'string') {
        addText(catalog, obj.description);
      }
    }
    for (const value of Object.values(obj)) {
      if (value && typeof value === 'object') {
        collect(value);
      }
    }
  };
  for (const file of jsonFilesUnder(INTERACTION_JSON_DIR)) {
    try {
      collect(JSON.parse(fs.readFileSync(file, 'utf8')));
    } catch {
      // 坏 JSON：跳过，不崩。
    }
  }
}

// 反派偏好（反派 tab）：定义在 TS 里（`key` 是 act 标识符，`name`/`description` 仅显示=安全；
// 且 TS 端 bundle、不经 DM ui_data，P1 无关）。定义文件多为 .ts，walk() 只扫 .tsx/.jsx 故漏掉。
// 这里专门抽 antag 定义的 name + description（内联模板字符串数组 + 同目录的共享 description 常量）。
const ANTAG_DEF_DIR = path.join(
  TGUI_SOURCE_DIR,
  'interfaces/PreferencesMenu/antagonists',
);

function tsFilesUnder(dir, out = []) {
  let entries;
  try {
    entries = fs.readdirSync(dir, { withFileTypes: true });
  } catch {
    return out;
  }
  for (const entry of entries) {
    const entryPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      tsFilesUnder(entryPath, out);
    } else if (entry.name.endsWith('.ts') || entry.name.endsWith('.tsx')) {
      out.push(entryPath);
    }
  }
  return out;
}

// 共享常量表里的显示字段。`walk()` 只扫 .tsx/.jsx，界面**共用**的查表数据却住在 .ts 里
// （constants.ts 的 GASES → `getGasLabel(gas_id)` 渲染进 AtmosFilter/PortablePump/管道等一整
// 排界面）。这些串运行期才由函数返回、界面文件里根本没有字面量 → 全类漏抽，界面越多漏得越广。
//
// 不整体放开 .ts：backend.ts/logging.ts 之流里的 name/label 多是标识符。按「文件 + 表名 + 字段」
// 三重定点登记，同类新表加一行即可。id/path 是 act() 回传标识符，永不入表。
// 组件专属的「这个 prop 是给玩家看的文案」登记表。
//
// 全局可翻 prop 表（policy.json translatable_props）**同时**驱动运行时 localizeProps，往里加
// `name` 会把 `<Icon name="cog">`、`<Input name=…>` 一起翻掉——图标名是标识符，翻了图标就没了。
// 但少数自定义组件确实拿 `name` 当纯标题用，且中转到某个真正可翻的 prop 上：反派页的
// `<AntagSelection name="Roundstart">` 内部渲染成 `<Section title={props.name}>`，运行时在
// Section 那一跳就能 auto-localize（title 在全局表里），**缺的只有抽取**——三个分类标题因此
// 从没进过目录，界面永远是英文。这里只做抽取侧的定点登记，运行时一行不用改。
const COMPONENT_TEXT_PROPS = [{ component: 'AntagSelection', props: ['name'] }];

function isComponentTextProp(attributeNode, propName) {
  const opening = attributeNode.parent && attributeNode.parent.parent;
  if (
    !opening ||
    (!ts.isJsxOpeningElement(opening) && !ts.isJsxSelfClosingElement(opening))
  ) {
    return false;
  }
  const tag = opening.tagName.getText();
  return COMPONENT_TEXT_PROPS.some(
    ({ component, props }) => component === tag && props.includes(propName),
  );
}

// `props` = 只收这些字段名的值（表项是对象，字段名固定）。
// `values: true` = 收表里**所有**字符串值、不看键——用于「键是回传标识符、值是显示文案」的映射表
// （`CRIMESTATUS2DESC` 的键 Arrest/Parole/… 正是 act 回传值，绝不能抽；值才是悬停说明）。
const CONSTANT_LABEL_TABLES = [
  { file: 'constants.ts', table: 'GASES', props: ['name', 'label'] },
  // 安保记录里 N/S/A/I/P/D 那排状态按钮的悬停说明。住在 .ts 里 → walk() 只扫 .tsx/.jsx，整类漏抽；
  // 渲染侧 `tooltip={CRIMESTATUS2DESC[button]}` 的 tooltip 本就在 translatable_props 里，
  // 缺的只有抽取。
  {
    file: 'interfaces/SecurityRecords/constants.ts',
    table: 'CRIMESTATUS2DESC',
    values: true,
  },
];

function extractConstantTableLabels(catalog) {
  for (const { file, table, props, values } of CONSTANT_LABEL_TABLES) {
    const filePath = path.join(TGUI_SOURCE_DIR, file);
    let source;
    try {
      source = fs.readFileSync(filePath, 'utf8');
    } catch {
      continue;
    }
    const sf = ts.createSourceFile(
      filePath,
      source,
      ts.ScriptTarget.Latest,
      true,
      ts.ScriptKind.TS,
    );
    const wanted = new Set(props ?? []);
    const visit = (node) => {
      if (
        ts.isVariableDeclaration(node) &&
        ts.isIdentifier(node.name) &&
        node.name.text === table
      ) {
        const collect = (inner) => {
          if (ts.isPropertyAssignment(inner)) {
            const name = propertyName(inner.name);
            if (values || wanted.has(name)) {
              addText(catalog, literalText(inner.initializer));
            }
          }
          ts.forEachChild(inner, collect);
        };
        collect(node);
        return;
      }
      ts.forEachChild(node, visit);
    };
    visit(sf);
  }
}

function extractAntagonistLabels(catalog) {
  for (const file of tsFilesUnder(ANTAG_DEF_DIR)) {
    let source;
    try {
      source = fs.readFileSync(file, 'utf8');
    } catch {
      continue;
    }
    const sf = ts.createSourceFile(
      file,
      source,
      ts.ScriptTarget.Latest,
      true,
      file.endsWith('.tsx') ? ts.ScriptKind.TSX : ts.ScriptKind.TS,
    );
    const visit = (node) => {
      if (ts.isPropertyAssignment(node)) {
        const name = propertyName(node.name);
        if (name === 'name') {
          addText(catalog, literalText(node.initializer));
        } else if (
          name === 'description' &&
          ts.isArrayLiteralExpression(node.initializer)
        ) {
          for (const element of node.initializer.elements) {
            addText(catalog, literalText(element));
          }
        }
      } else if (
        ts.isVariableDeclaration(node) &&
        node.initializer &&
        ts.isNoSubstitutionTemplateLiteral(node.initializer)
      ) {
        // 共享 description 常量，如 TRAITOR_MECHANICAL_DESCRIPTION = `...`。
        addText(catalog, literalText(node.initializer));
      }
      ts.forEachChild(node, visit);
    };
    visit(sf);
  }
}


// ---------------------------------------------------------------------------
// 混合 children 的占位符模板
//
// `<Box>Reduced by {n}% when infected with viruses.</Box>` 在 React 里的 children 是
// ["Reduced by ", n, "% when infected with viruses."]。逐段抽、逐段翻，渲染时仍按英文语序
// 拼回去 → 「减少了 2 感染病毒时的%。」。中文语序和英文不同，碎片翻译必然拼错，
// 比不翻还糟。改为整条抽成带占位符的模板（与 DM 侧 LANG 模板同一思路），运行时整条查表、
// 再把占位符换回原来的非字符串 children。
// ---------------------------------------------------------------------------

/// 复现 JSX transform 对 JSXText 的空白处理（Babel cleanJSXElementLiteralChild 同款）：
/// 含换行的首尾空白删掉，行间换行+缩进折成一个空格。抽取期算出的串必须与运行时 children
/// 里的字符串逐字节一致，否则查表必 miss。
function jsxTextValue(raw) {
  const lines = raw.split(/\r\n|\n|\r/);
  let lastNonEmptyLine = 0;
  for (let i = 0; i < lines.length; i++) {
    if (/[^ \t]/.test(lines[i])) lastNonEmptyLine = i;
  }
  let out = '';
  for (let i = 0; i < lines.length; i++) {
    let line = lines[i].replace(/\t/g, ' ');
    if (i !== 0) line = line.replace(/^ +/, '');
    if (i !== lines.length - 1) line = line.replace(/ +$/, '');
    if (line) {
      if (i !== lastNonEmptyLine) line += ' ';
      out += line;
    }
  }
  return out;
}

/// children 里「会在运行时占一个数组位」的节点：文本（空白节点被 transform 丢掉）与表达式。
/// 注释表达式 `{/* … */}` 不产生 child。
function templateChildren(children) {
  const out = [];
  for (const child of children) {
    if (ts.isJsxText(child)) {
      const value = jsxTextValue(decodeJsxEntities(child.text));
      if (value) out.push({ text: value });
    } else if (ts.isJsxExpression(child)) {
      if (!child.expression) continue; // {/* comment */}
      // `{' '}` / `{'Search…'}`：JSX 表达式里是**字符串字面量**时，React 渲染出来的是一个
      // 字符串 child，运行时 localizeChildrenTemplate 会把它并进模板文本；抽取期若记成占位符，
      // 算出的 key 就比运行时多一个 `{N}` → 整条模板永远查不到 → 整段回退英文。
      // prettier 换行时到处插 `{' '}`（`The <b>Linguist</b>{' '}\n neutral quirk …`），所以这
      // 一条会静默毒掉一大批混排 children 的模板：偏好菜单语言页、反派介绍页整段英文即此，
      // 而其中的 `<b>Linguist</b>` 因为自己是独立 jsx 节点照常被译 → 表现为「只有加粗的词是中文」。
      const literal = child.expression;
      if (
        ts.isStringLiteral(literal) ||
        ts.isNoSubstitutionTemplateLiteral(literal)
      ) {
        out.push({ text: literal.text });
        continue;
      }
      out.push({ slot: true });
    } else {
      out.push({ slot: true }); // 嵌套元素
    }
  }
  return out;
}

/// 把混合 children 拼成 `Reduced by {0}% when infected with viruses.` 这样的模板。
/// 只在**既有文本又有占位**、且文本部分含真正词句时才产出——纯占位或纯文本走原来的路径。
function childrenTemplate(children) {
  const parts = templateChildren(children);
  if (!parts.some((p) => p.text) || !parts.some((p) => p.slot)) return null;
  let slot = 0;
  let template = '';
  for (const part of parts) {
    template += part.text !== undefined ? part.text : `{${slot++}}`;
  }
  template = template.replace(/\s+/g, ' ').trim();
  // 至少要有一个字母词，且不是纯标点/数字外壳（`{0}%`、`({0})` 之流不值得进目录）。
  if (!/[A-Za-z]{2}/.test(template)) return null;
  return template;
}

function extractCatalog() {
  const catalog = {};
  // 这三个来源不是界面文件，语境按来源种类记（够用来把它们和界面串区分开）。
  currentScope = 'dm:labels';
  extractDmLabels(catalog);
  currentScope = 'dm:antagonists';
  extractAntagonistLabels(catalog);
  currentScope = 'dm:interactions';
  extractInteractionLabels(catalog);
  currentScope = 'tgui:constants';
  extractConstantTableLabels(catalog);
  for (const filePath of walk(TGUI_SOURCE_DIR)) {
    // 界面名即语境。`interfaces/ChemReactionChamber.tsx` -> `tgui:ChemReactionChamber`。
    currentScope = `tgui:${path.basename(filePath).replace(/\.(tsx|jsx|ts|js)$/, '')}`;
    const source = fs.readFileSync(filePath, 'utf8');
    const sourceFile = ts.createSourceFile(
      filePath,
      source,
      ts.ScriptTarget.Latest,
      true,
      filePath.endsWith('.jsx') ? ts.ScriptKind.JSX : ts.ScriptKind.TSX,
    );

    const isFeatureDef = filePath.includes(FEATURE_DEF_DIR);

    // 已被 children 模板吃掉的 JsxText 节点：不再单独入目录，否则那些碎片仍会被
    // 运行时逐段替换、拼出语序错乱的中文。
    const templatedText = new Set();

    function visit(node) {
      if ((ts.isJsxElement(node) || ts.isJsxFragment(node)) && node.children) {
        const template = childrenTemplate(node.children);
        if (template) {
          addText(catalog, template);
          for (const child of node.children) {
            if (ts.isJsxText(child)) templatedText.add(child);
          }
        }
      }
      if (ts.isJsxText(node)) {
        if (!templatedText.has(node)) {
          addText(catalog, decodeJsxEntities(node.text));
        }
      } else if (ts.isJsxAttribute(node)) {
        const name = node.name.getText(sourceFile);
        if (TRANSLATABLE_PROPS.has(name) || isComponentTextProp(node, name)) {
          // 属性初始值若是 JSX 直写的字符串（title="Don&apos;t"），实体同样由 transform 解码。
          const initializer =
            node.initializer && ts.isStringLiteral(node.initializer)
              ? decodeJsxEntities(node.initializer.text)
              : node.initializer;
          if (typeof initializer === 'string') {
            addText(catalog, initializer);
          } else {
            addDisplayExpr(catalog, initializer); // 含三元/|| 两支（content={x?'Retract':'Deploy'}）
            // 运行期拼接（`` title={`Reading: ${x}`} ``）：addDisplayExpr 按「形状不可复原」
            // 整条不抽，改按模板收，运行时由 localize.ts 的逆匹配还原。
            const template = propTemplate(initializer);
            if (template) {
              addText(catalog, template);
              propTemplates.add(normalizeText(stripGrammarMacros(template)));
            }
          }
        }
      } else if (ts.isPropertyAssignment(node)) {
        const name = propertyName(node.name);
        if (
          TRANSLATABLE_PROPS.has(name) ||
          OPTION_TEXT_PROPS.has(name) ||
          (isFeatureDef && FEATURE_LABEL_PROPS.has(name))
        ) {
          addDisplayExpr(catalog, node.initializer);
        }
      } else if (
        ts.isJsxExpression(node) &&
        node.parent &&
        !ts.isJsxAttribute(node.parent)
      ) {
        // JSX 子表达式（非属性值）：`{cond ? 'A' : 'B'}` / `{x || 'No AI Detected'}` / `{'Search…'}`
        // —— 渲染为可见文本节点，是 UI 文案。三元/||/字面量经 addDisplayExpr 抽取（bare 标识符 no-op）。
        addDisplayExpr(catalog, node.expression);
      } else if (
        ts.isStringLiteral(node) ||
        ts.isNoSubstitutionTemplateLiteral(node)
      ) {
        // TS 逻辑里的「句子型」UI 文案（return / 三元 / 赋值的字符串字面量；JSX 文本/属性分支抓不到，
        // 如 PersonalityPage 的 'You have no personality.'）。运行时 auto-localize 会按英文原文翻这些
        // 渲染出的串，缺的只是把它们抽进目录。保守启发式（含空格 + 首字母大写 + 句末标点 + 无
        // </>/{}/=/_ 等标识符/标签字符）只取自然语句，避开 className/key/路径/act 标识符。
        const t = node.text;
        if (
          /\s/.test(t) &&
          /^[A-Z]/.test(t) &&
          /[.!?]$/.test(t) &&
          !/[<>{}/=_]/.test(t)
        ) {
          addText(catalog, t);
        }
      }

      ts.forEachChild(node, visit);
    }

    visit(sourceFile);
  }
  return catalog;
}

function existingTguiCatalog(locale) {
  return {
    ...readJson(packageCatalogPath(locale)),
    ...readJson(stringsCatalogPath(locale)),
  };
}

function buildReverseTranslations(locale) {
  const localeDir = path.join(STRINGS_I18N_DIR, locale);
  const enDir = path.join(STRINGS_I18N_DIR, 'en');
  const reverse = {};

  if (!fs.existsSync(localeDir)) {
    return reverse;
  }

  for (const entry of fs.readdirSync(enDir)) {
    if (!entry.endsWith('.json') || entry === `${TGUI_NAMESPACE}.json`) {
      continue;
    }
    const enCatalog = readJson(path.join(enDir, entry));
    const localeCatalog = readJson(path.join(localeDir, entry));
    for (const [key, source] of Object.entries(enCatalog)) {
      const target = localeCatalog[key];
      if (
        typeof source === 'string' &&
        typeof target === 'string' &&
        target !== source &&
        /[\u3400-\u9fff]/.test(target)
      ) {
        reverse[source] ??= target;
      }
    }
  }

  return reverse;
}

function extract() {
  const extracted = extractCatalog();
  const existingEn = existingTguiCatalog('en');
  const existingZh = existingTguiCatalog('zh-Hans');
  const reverseZh = buildReverseTranslations('zh-Hans');

  const enCatalog = {
    ...extracted,
    ...existingEn,
  };
  const zhCatalog = {};

  for (const key of Object.keys(enCatalog)) {
    const existing = existingZh[key];
    // 用户已有译文**最优先**，绝不被自动生成覆盖。否则每次 extract 都会把整句人工译文降级为
    // phraseTranslation/reverse 的词级重组（如「创建指挥报告」→「创建指挥 Report」）。
    // 只有「尚无译文」的新键才用自动生成回填。
    if (existing && existing !== key) {
      zhCatalog[key] = existing;
      continue;
    }
    zhCatalog[key] = phraseTranslation(key) ?? reverseZh[key] ?? key;
  }

  writeJson(stringsCatalogPath('en'), enCatalog);
  writeJson(stringsCatalogPath('zh-Hans'), zhCatalog);
  warnHtmlEntities(enCatalog, zhCatalog);
  writeTguiScopes(enCatalog);
  writePropTemplates();
  sync();
}

// 目录里出现 HTML 实体 = 两类真 bug，且都**静默**：
//   key 带实体   → 抽取时漏解码，运行时永远查不到（界面显示英文，但目录里看着「已翻」）；
//   value 带实体 → 译文当文本子节点渲染，玩家会看到字面的 `&nbsp;` / `&quot;`。
// enCatalog 是「新抽取 ∪ 历史键」——历史键从不裁剪，所以旧的坏键只能靠这里报出来。
function warnHtmlEntities(enCatalog, zhCatalog) {
  const ENTITY = /&(#x[0-9a-fA-F]+|#\d+|[a-zA-Z]+);/;
  const badKeys = Object.keys(enCatalog).filter((key) => ENTITY.test(key));
  const badValues = Object.entries(zhCatalog).filter(([, value]) =>
    ENTITY.test(value),
  );
  if (!badKeys.length && !badValues.length) {
    return;
  }
  console.warn(
    `tgui 目录含 HTML 实体：key ${badKeys.length} 条（死键，运行时查不到）、译文 ${badValues.length} 条（会字面显示）`,
  );
  for (const key of badKeys.slice(0, 10)) {
    console.warn(`   key ${JSON.stringify(key)}`);
  }
  for (const [key, value] of badValues.slice(0, 10)) {
    console.warn(`   val ${JSON.stringify(key)} -> ${JSON.stringify(value)}`);
  }
}

/**
 * 落盘 TGUI 语境 sidecar，并报出**跨界面共用**的 key。
 *
 * 放 strings/i18n/tgui-scopes.json（locale 目录之外——build_i18n_cache 会把 locale 目录里
 * 每个 .json 全量并进反查表，见 DM 侧 scopes.json 的同款注意事项）。
 */
function writeTguiScopes(enCatalog) {
  const out = {};
  for (const key of Object.keys(enCatalog).sort()) {
    const scopes = textScopes[key];
    if (scopes && scopes.size) out[key] = [...scopes].sort();
  }
  const outPath = path.join(STRINGS_I18N_DIR, 'tgui-scopes.json');
  fs.writeFileSync(outPath, `${JSON.stringify(out, null, 2)}\n`);
  // 这个函数跑在**每次 tgui 构建**里，所以默认只出一行。
  // 跨界面共用的短 key（如 "Basic"：Crayon 的色系分组 vs 化学的碱性）只能有一个译文，
  // 各界面语义不同时必然有一边错——但那是需要专门排查的事，不该每次构建都刷屏。
  // 要看明细：I18N_SCOPE_REPORT=1 node tools/i18n/tgui-catalog.mjs extract
  const shared = Object.entries(out).filter(
    ([key, sc]) => sc.length > 1 && key.split(/\s+/).length <= 2,
  );
  console.log(
    `tgui 语境 sidecar: ${Object.keys(out).length} 条（跨界面共用短 key ${shared.length}）`,
  );
  if (process.env.I18N_SCOPE_REPORT) {
    for (const [key, sc] of shared) console.log(`   ${JSON.stringify(key)} ${sc.join(', ')}`);
  }
}

/**
 * 落盘「可逆匹配模板」sidecar（strings/i18n/tgui-prop-templates.json，locale 目录之外）。
 *
 * 与目录相反，这份**每次全量重写、不合并**：它不是译文（丢了会漏译），而是运行时逆匹配的
 * **准入面**（多了会误翻）。调用点删掉后模板若还留在面上，就可能去匹配别处成品串。译文本身
 * 仍留在 tgui.json 里，将来调用点回来会被重新收进面。
 */
function writePropTemplates() {
  const outPath = path.join(STRINGS_I18N_DIR, 'tgui-prop-templates.json');
  const out = [...propTemplates].filter(Boolean).sort();
  fs.writeFileSync(outPath, `${JSON.stringify(out, null, 2)}\n`);
}

function sync() {
  const enSource = readJson(stringsCatalogPath('en'));
  for (const locale of LOCALES) {
    const sourcePath = stringsCatalogPath(locale);
    const fallbackPath = packageCatalogPath(locale);
    const source = fs.existsSync(sourcePath)
      ? readJson(sourcePath)
      : readJson(fallbackPath);
    const runtimeCatalog = {};

    for (const [key, value] of Object.entries(source)) {
      const enValue = enSource[key] ?? key;
      if (locale === 'en' ? value !== key : value !== enValue) {
        runtimeCatalog[key] = value;
      }
    }

    writeJson(fallbackPath, runtimeCatalog);
  }
  // 三端策略单一来源 → 前端打包副本（localize.ts 静态 import，两份都提交）。
  const policySource = path.join(STRINGS_I18N_DIR, 'policy.json');
  const policyTarget = path.join(TGUI_PACKAGE_I18N_DIR, 'policy.json');
  if (fs.existsSync(policySource)) {
    fs.copyFileSync(policySource, policyTarget);
  }
  // 逆匹配准入面同理（localize.ts 静态 import，两份都提交）。
  const tplSource = path.join(STRINGS_I18N_DIR, 'tgui-prop-templates.json');
  const tplTarget = path.join(TGUI_PACKAGE_I18N_DIR, 'prop-templates.json');
  if (fs.existsSync(tplSource)) {
    fs.copyFileSync(tplSource, tplTarget);
  }
}

const command = process.argv[2] ?? 'sync';
if (command === 'extract') {
  extract();
} else if (command === 'sync') {
  sync();
} else {
  console.error(`Unknown command: ${command}`);
  console.error('Usage: node tools/i18n/tgui-catalog.mjs [extract|sync]');
  process.exit(1);
}
