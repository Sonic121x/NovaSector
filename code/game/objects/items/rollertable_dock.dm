/obj/item/rolling_table_dock
	name = "折叠桌坞站"
	desc = "一个可折叠的滚轮桌，可以弹出以便随时提供服务。使用后必须回收或更换。"
	icon = 'icons/obj/smooth_structures/rollingtable.dmi'
	icon_state = "rollingtable"
	var/obj/structure/table/rolling/loaded = null

/obj/item/rolling_table_dock/Initialize(mapload)
	. = ..()
	loaded = new(src)

/obj/item/rolling_table_dock/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/turf/target_turf = get_turf(interacting_with)
	if(target_turf.is_blocked_turf(TRUE) || (locate(/mob/living) in target_turf))
		return NONE
	if(isopenturf(interacting_with))
		deploy_rolling_table(user, interacting_with)
		return ITEM_INTERACT_SUCCESS
	return NONE

/obj/item/rolling_table_dock/proc/deploy_rolling_table(mob/user, atom/location)
	var/obj/structure/table/rolling/rable = new /obj/structure/table/rolling(location)
	rable.add_fingerprint(user)
	qdel(src)

/obj/item/rolling_table_dock/examine(mob/user)
	. = ..()
	. += "The dock is [loaded ? "loaded" : "empty"]."

/obj/item/rolling_table_dock/deploy_rolling_table(mob/user, atom/location)
	if(loaded)
		loaded.forceMove(location)
		user.visible_message(span_notice("[user] 部署了 [loaded]。"), balloon_alert(user, "你部署了 [loaded]。"))
		loaded = null
	else
		balloon_alert(user, "底座是空的！")
