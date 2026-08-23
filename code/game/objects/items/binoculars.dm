// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/binoculars
	name = "binoculars"
	desc = "Used for long-distance surveillance."
	inhand_icon_state = "binoculars"
	icon = 'icons/obj/devices/tool.dmi'
	icon_state = "binoculars"
	worn_icon_state = "binoculars"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	slot_flags = ITEM_SLOT_NECK | ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/binoculars/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=8, force_wielded=12, wield_callback = CALLBACK(src, PROC_REF(on_wield)), unwield_callback = CALLBACK(src, PROC_REF(on_unwield)))
	AddComponent(/datum/component/scope, range_modifier = 4, zoom_method = ZOOM_METHOD_WIELD)

/obj/item/binoculars/proc/on_wield(obj/item/source, mob/user)
	user.visible_message(span_notice(LANG("obj.571cc9172cea12be", list(user, src, user.p_their()))), span_notice(LANG("obj.dbdbe40b56a391a7", list(src))))
	inhand_icon_state = "binoculars_wielded"
	user.regenerate_icons()
	//Have you ever tried running with binocs on? It takes some willpower not to stop as things appear way too close than they're.
	user.add_movespeed_modifier(/datum/movespeed_modifier/binocs_wielded)

/obj/item/binoculars/proc/on_unwield(obj/item/source, mob/user)
	user.visible_message(span_notice(LANG("obj.01eee1f9a70583fe", list(user, src))), span_notice(LANG("obj.0c0a6780674a0a4c", list(src))))
	inhand_icon_state = "binoculars"
	user.regenerate_icons()
	user.remove_movespeed_modifier(/datum/movespeed_modifier/binocs_wielded)
