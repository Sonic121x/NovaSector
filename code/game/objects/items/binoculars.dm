/obj/item/binoculars
	name = "双筒望远镜"
	desc = "用于远距离监视。"
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
	user.visible_message(span_notice("[user]将[src]举到[user.p_their()]眼前。"), span_notice("你将[src]举到眼前。"))
	inhand_icon_state = "binoculars_wielded"
	user.regenerate_icons()
	//Have you ever tried running with binocs on? It takes some willpower not to stop as things appear way too close than they're.
	user.add_movespeed_modifier(/datum/movespeed_modifier/binocs_wielded)

/obj/item/binoculars/proc/on_unwield(obj/item/source, mob/user)
	user.visible_message(span_notice("[user]放下了[src]。"), span_notice("你放下了[src]。"))
	inhand_icon_state = "binoculars"
	user.regenerate_icons()
	user.remove_movespeed_modifier(/datum/movespeed_modifier/binocs_wielded)
