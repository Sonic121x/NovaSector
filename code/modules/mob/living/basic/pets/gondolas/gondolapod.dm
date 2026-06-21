/mob/living/basic/pet/gondola/gondolapod
	name = "冈多拉"
	real_name = "gondola"
	desc = "沉默的行者。这一只似乎是某家快递机构的一部分。"
	icon = 'icons/obj/supplypods.dmi'
	icon_state = "gondola"
	icon_living = "gondola"
	SET_BASE_PIXEL(-16, -5) //2x2 sprite
	layer = TABLE_LAYER //so that deliveries dont appear underneath it

	loot = list(
		/obj/effect/decal/cleanable/blood/gibs = 1,
		/obj/item/stack/sheet/animalhide/gondola = 2,
		/obj/item/food/meat/slab/gondola = 2,
	)

	///Boolean on whether the pod is currently open, and should appear such.
	var/opened = FALSE
	///The supply pod attached to the gondola, that actually holds the contents of our delivery.
	var/obj/structure/closet/supplypod/centcompod/linked_pod
	///Static list of actions the gondola is given on creation, and taken away when it successfully delivers.
	var/static/list/gondola_delivering_actions = list(
		/datum/action/innate/deliver_gondola_package,
		/datum/action/innate/check_gondola_contents,
	)

/mob/living/basic/pet/gondola/gondolapod/Initialize(mapload, pod)
	linked_pod = pod || new(src)
	name = linked_pod.name
	desc = linked_pod.desc
	if(!linked_pod.stay_after_drop || !linked_pod.opened)
		grant_actions_by_list(gondola_delivering_actions)
	return ..()

/mob/living/basic/pet/gondola/gondolapod/death()
	QDEL_NULL(linked_pod) //Will cause the open() proc for the linked supplypod to be called with the "broken" parameter set to true, meaning that it will dump its contents on death
	return ..()

/mob/living/basic/pet/gondola/gondolapod/create_gondola()
	return

/mob/living/basic/pet/gondola/gondolapod/update_overlays()
	. = ..()
	if(opened)
		. += "[icon_state]_open"

/mob/living/basic/pet/gondola/gondolapod/examine(mob/user)
	. = ..()
	if (contents.len)
		. += span_notice("看起来它还没有完成它的投递。")
	else
		. += span_notice("看起来它已经完成了投递。")

/mob/living/basic/pet/gondola/gondolapod/set_opened()
	opened = TRUE
	layer = initial(layer)
	update_appearance()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/, set_closed)), 5 SECONDS)

/mob/living/basic/pet/gondola/gondolapod/set_closed()
	opened = FALSE
	layer = LOW_MOB_LAYER
	update_appearance()

///Opens the gondola pod and delivers its package, one-time use as it removes all delivery-related actions.
/datum/action/innate/deliver_gondola_package
	name = "投递"
	desc = "打开你的舱体并释放其中储存的任何内容物。"
	button_icon = 'icons/hud/screen_gen.dmi'
	button_icon_state = "arrow"
	check_flags = AB_CHECK_PHASED

/datum/action/innate/deliver_gondola_package/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return

	var/mob/living/basic/pet/gondola/gondolapod/gondola_owner = owner
	gondola_owner.linked_pod.open_pod(gondola_owner, forced = TRUE)
	for(var/datum/action/actions as anything in gondola_owner.actions)
		if(actions.type in gondola_owner.gondola_delivering_actions)
			actions.Remove(gondola_owner)
	return TRUE

///Checks the contents of the gondola and lets them know what they're holding.
/datum/action/innate/check_gondola_contents
	name = "检查内容物"
	desc = "查看你当前在舱体内持有的物品数量。"
	button_icon = 'icons/hud/implants.dmi'
	button_icon_state = "storage"
	check_flags = AB_CHECK_PHASED

/datum/action/innate/check_gondola_contents/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return

	var/mob/living/basic/pet/gondola/gondolapod/gondola_owner = owner
	var/total = gondola_owner.contents.len
	if (total)
		to_chat(gondola_owner, span_notice("你感知到[total] object\s 在你无比广阔的肚子里。"))
	else
		to_chat(gondola_owner, span_notice("更仔细地观察内部发现……空无一物。"))
	return TRUE
