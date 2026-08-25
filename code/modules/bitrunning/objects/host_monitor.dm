// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/bitrunning_host_monitor
	name = "host monitor"

	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2)
	desc = "A complex electronic that will analyze the connection health between host and avatar."
	obj_flags = CONDUCTS_ELECTRICITY
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "host_monitor"
	inhand_icon_state = "electronic"
	item_flags = NOBLUDGEON
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	throw_range = 7
	throw_speed = 3
	throwforce = 3
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = "electronic"

/obj/item/bitrunning_host_monitor/attack_self(mob/user, modifiers)
	. = ..()

	var/datum/component/avatar_connection/connection = user.GetComponent(/datum/component/avatar_connection)
	if(isnull(connection))
		balloon_alert(user, LANG("obj.e7d518c63f015323", null))
		return

	var/mob/living/pilot = connection.old_body_ref?.resolve()
	if(isnull(pilot))
		balloon_alert(user, LANG("obj.de0d9729db0afb9d", null))
		return

	to_chat(user, span_notice(LANG("obj.302dc5f0c31cdefc", list(pilot.health / pilot.maxHealth * 100))))
