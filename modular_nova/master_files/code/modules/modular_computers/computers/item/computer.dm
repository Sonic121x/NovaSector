// NOVA EDIT ADDITION - I18N - PDA 名字里的职务本地化。
//
// 上游 `UpdateDisplay()` 把名字拼成 `"[saved_identification] ([saved_job])"`，职务原样嵌进去。
// 这个整串是**运行期拼的**，永远不是目录键 → 精确反查必 miss；而职务多为单词（Virologist /
// Coroner / Netdiver），按本仓库的安全线单词不得进字面 AC 字典（会从单词内部开火、也会污染
// `name ==` 比较），所以聊天层也够不着 → 玩家看到「他们穿着 Jamar Powers (Virologist)」，
// 而同一屏的安保记录里「等级：病毒学家」却是中文，对比之下像是漏了一条。
//
// 隔壁 ID 卡（cards_ids.dm 的 update_label）早就是这么修的，PDA 这条只是没跟上。
// 用 `. = ..()` 覆盖而非复制上游 proc：上游改了拼法这里不会静默失配，合并也不冲突。
//
// 只动**显示名**：saved_job 本身不变，任何按它比较/回传的逻辑照旧拿英文。
/obj/item/modular_computer/UpdateDisplay()
	. = ..()
	if(GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return
	if(!saved_identification && !saved_job)
		return
	name = "[saved_identification] ([lang_reverse_text(saved_job)])"
