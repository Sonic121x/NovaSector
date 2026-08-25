// GENERIC
/obj/item/card/id/advanced/silver/generic
	name = "generic silver identification card"
	icon = 'modular_nova/master_files/icons/obj/card.dmi'
	icon_state = "card_silvergen"
	assigned_icon_state = null

/obj/item/card/id/advanced/gold/generic
	name = "generic gold identification card"
	icon = 'modular_nova/master_files/icons/obj/card.dmi'
	icon_state = "card_goldgen"
	assigned_icon_state = null

// Interdyne (Deck Officer's)
/obj/item/card/id/advanced/chameleon/elite/black/silver
	name = "silver identification card"
	desc = "A silver card which shows honour and dedication."
	icon_state = "card_silver"
	inhand_icon_state = "silver_id"
	assigned_icon_state = "assigned_silver"

// DS2
/obj/item/card/id/advanced/prisoner/ds2
	name = "syndicate prisoner card"
	icon = 'modular_nova/master_files/icons/obj/card.dmi'
	icon_state = "card_ds2prisoner"

// SOLFED
/obj/item/card/id/advanced/solfed
	name = "solfed identification card"
	icon = 'modular_nova/master_files/icons/obj/card.dmi'
	icon_state = "card_solfed"
	assigned_icon_state = "assigned_solfed"

// Station CC
/obj/item/card/id/advanced/centcom/station
	wildcard_slots = WILDCARD_LIMIT_SILVER

/obj/item/card/id/examine_more(mob/user)
	. = ..()

	if(ACCESS_WEAPONS in GetAccess())
		. += span_info(LANG("obj.097f68aa3a94a345", null))
	else
		. += span_info(LANG("obj.9c17a127366ee5de", null))

// NOVA EDIT ADDITION - I18N - 便衣 ID 卡的职务名本地化。
//
// 父类 update_label() 早就把 assignment 过了 lang_reverse_text（cards_ids.dm），但这个子类
// **整个覆盖**了该 proc、用 `fake.assignment` 另拼一遍名字，于是漏掉了那一步 —— 同一个界面里
// 普通 ID 显示「(病毒学家)」、便衣 ID 显示「(Virologist)」。
// 这类「父类修了、子类覆盖没跟上」的漏网，只能靠按拼接形状全仓扫（`name = "[x] ([y])"`）才找得到。
//
// 只动显示名：trim/alt_trim 与 fake.assignment 本身不变，按它比较/取值的逻辑照旧拿英文。
/obj/item/card/id/advanced/plainclothes/update_label()
	. = ..()
	if(GLOB.i18n_server_locale == DEFAULT_UI_LOCALE || !trim_assignment_override)
		return
	var/datum/id_trim/fake = SSid_access.trim_singletons_by_path[alt_trim]
	if(isnull(fake))
		return
	var/name_string = registered_name ? "[registered_name]'s ID Card" : initial(name)
	name = "[name_string] ([lang_reverse_text(fake.assignment)])"
