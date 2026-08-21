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
