// NovaSector 全量汉化 (i18n) 的跨文件定义。
// 详见 modular_nova/modules/i18n/readme.md。

/// 受支持的界面语言（locale 代码，遵循 BCP-47）。
#define LANGUAGE_LOCALE_EN "en"
#define LANGUAGE_LOCALE_ZH_HANS "zh-Hans"

/// 缺省 locale（找不到玩家/服务器设置时回退到它，也是英文源串的 locale）。
#define DEFAULT_UI_LOCALE LANGUAGE_LOCALE_EN

/// i18n 目录文件位于 STRING_DIRECTORY ("strings") 下的此子目录：
/// strings/i18n/<locale>/<namespace>.json，内容为扁平的 {"key": "模板"}。
#define I18N_SUBDIRECTORY "i18n"
/// Runtime catalog classification manifest. It is deliberately outside locale directories so
/// the DM loader never mistakes metadata for translatable source text.
#define I18N_CATALOG_DOMAIN_MANIFEST "catalog-domains.json"

/// Catalog manifest domains.
#define I18N_DOMAIN_FORWARD "forward"
#define I18N_DOMAIN_MANUAL_FORWARD "manual_forward"
#define I18N_DOMAIN_GLOBAL_REVERSE "global_reverse"
#define I18N_DOMAIN_TGUI "tgui"
#define I18N_DOMAIN_SCOPED_PREFIX "scoped:"

/// Internal buckets in GLOB.i18n_catalogs.
#define I18N_CATALOG_FORWARD_BUCKET "forward"
#define I18N_CATALOG_PAIRED_BUCKET "paired"
#define I18N_CATALOG_DIRECT_BUCKET "direct"
#define I18N_CATALOG_MANUAL_BUCKET "manual_forward"

/// One runtime lifecycle. Index builders may run only while INITIALIZING or READY.
#define I18N_RUNTIME_BOOTSTRAP 1
#define I18N_RUNTIME_INITIALIZING 2
#define I18N_RUNTIME_READY 3

/// Runtime translation-layer counters.
#define I18N_LAYER_EXACT "exact"
#define I18N_LAYER_NORMALIZED "normalized"
#define I18N_LAYER_TEMPLATE "template"
#define I18N_LAYER_AC "ac"
#define I18N_LAYER_MISS "miss"

/// 全服 locale 下的本地化 + 格式化。用于广播类文本（visible_message 等，
/// 一条字符串展示给多名观察者，无法按单人 locale 区分）。
/// args 为参数 /list（与模板里的 {0}/{1}… 对应），无参数时传 null。
#define LANG(key, args) (lang_format(key, args))

/// 兼容旧调用的定向文本入口；当前服务器强制使用全服 locale。
#define LANGU(user, key, args) (lang_format_for(user, key, args))

/// `lang_localize_chain` 的字面 AC 放行档位。
/// 放共享 defines 而不是 fallback.dm：三条落地链分布在 runtime.dm / fallback.dm / 单测里，
/// 定义在模块文件里只是**碰巧**靠 .dme 的 include 顺序成立（单测在 8867 行之前就用不到）。
/// I18N_AC_NONE  —— 不过 AC（显示边界：名字要么整串命中、要么可分段翻，子串替换只会误伤）。
/// I18N_AC_PROSE —— 只有长散文过 AC（TGUI 负载：act 回传标识符永远不是这个形状）。
/// I18N_AC_FULL  —— 聊天/浏览器：整行本来就是散文。
#define I18N_AC_NONE 0
#define I18N_AC_PROSE 1
#define I18N_AC_FULL 2

/// 早调用告警上限：一次启动最多报这么多条。runtime.dm 的反查哨兵与 fallback.dm 的
/// AC 建表哨兵**共用**这一个上限，所以它住在共享 defines 里（单文件 define 会被
/// 文件底部的 #undef 挡在另一个文件之外）。
#define I18N_MAX_EARLY_WARNINGS 10

/// LANG 实参的 HTML 兜底最多下探几层（那条路经模板引擎会绕回 lang_localize_arg 自身）。
/// 每跳都是更短的子串、理论上必然收敛，钉上限只是不让聊天热路径有爆栈的可能。
#define I18N_ARG_HTML_MAX_DEPTH 3
