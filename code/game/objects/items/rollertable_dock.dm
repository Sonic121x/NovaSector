// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/rolling_table_dock
	name = "rolling table dock"
	desc = "A collapsed roller table that can be ejected for service on the go. Must be collected or replaced after use."
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
	. += LANG("obj.5d5580ef5be00e58", list(loaded ? "loaded" : "empty"))

/obj/item/rolling_table_dock/deploy_rolling_table(mob/user, atom/location)
	if(loaded)
		loaded.forceMove(location)
		user.visible_message(span_notice(LANG("obj.1596d21de1f59c58", list(user, loaded))), balloon_alert(user, LANG("obj.2585aae8f2fdac64", list(loaded))))
		loaded = null
	else
		balloon_alert(user, LANG("obj.8f5eb52bda600d07", null))
