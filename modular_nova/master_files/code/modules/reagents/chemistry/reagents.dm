/datum/reagent
	/// Modular version of `chemical_flags`, so we don't have to worry about
	/// it causing conflicts in the future.
	var/chemical_flags_nova = NONE

/datum/reagent/drug/nicotine
	addiction_types = list(/datum/addiction/nicotine = 40)

/datum/reagent/toxin/pestkiller/expose_obj(obj/exposed_obj, reac_volume, methods=TOUCH, show_message=TRUE)
	. = ..()
	if(istype(exposed_obj, /obj/structure/spider))
		var/obj/structure/spider/webs_or_something = exposed_obj
		webs_or_something?.take_damage(rand(1, 3), BURN, 0) // slowly but surely damages web structures

// NOVA EDIT ADDITION START - i18n
/// i18n：ConfigLoaded 之后重建描述的钩子。默认什么都不做 —— 试剂描述由 TGUI 负载 overlay
/// 翻译，实例数据保持 canonical English 是显示边界方案的地基。
///
/// 只有**在 `New()` 里把 `%VAR%` 占位符替换掉**的试剂需要覆写它：替换之后整串再也不等于任何
/// 目录键，overlay 与反查一起 miss，译文躺在目录里永不显示。覆写时源串取 `initial(description)`
/// （带占位符的 canonical 形态），先反查再替换。
/datum/reagent/proc/lang_relocalize_description()
	return
// NOVA EDIT ADDITION END
