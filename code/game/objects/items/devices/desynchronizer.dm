/obj/item/desynchronizer
	name = "去同步器"
	desc = "一种实验性设备，可以暂时将使用者从时空同步中分离，使其在激活期间有效消失。"
	icon = 'icons/obj/devices/syndie_gadget.dmi'
	icon_state = "desynchronizer"
	inhand_icon_state = "electronic"
	w_class = WEIGHT_CLASS_SMALL
	item_flags = NOBLUDGEON
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	custom_materials = list(/datum/material/iron= SMALL_MATERIAL_AMOUNT * 2.5, /datum/material/glass= SMALL_MATERIAL_AMOUNT * 5)
	interaction_flags_click = NEED_DEXTERITY|ALLOW_RESTING
	/// Max time this can be set
	var/max_duration = 300 SECONDS
	/// Currently set time
	var/duration = 30 SECONDS
	/// Last world time
	var/last_use = 0
	/// world.time + (world.time - last_use)
	var/next_use = 0
	/// The current space time rift
	var/obj/effect/abstract/sync_holder/sync_holder
	/// Timer obj for calling resync
	var/resync_timer

/obj/item/desynchronizer/attack_self(mob/living/user)
	if(world.time < next_use)
		to_chat(user, span_warning("[src]还在充能."))
		return
	if(!sync_holder)
		desync(user)
	else
		resync()

/obj/item/desynchronizer/examine(mob/user)
	. = ..()
	if(world.time < next_use)
		. += span_warning("剩余充能时间：[DisplayTimeText(next_use - world.time)]")
	. += span_notice("Alt-点击以自定义持续时间。当前持续时间：[DisplayTimeText(duration)]。")
	. += span_notice("可再次使用以提前中断效果。充能时间与去同步状态持续时间相同。")

/obj/item/desynchronizer/click_alt(mob/living/user)
	var/new_duration = tgui_input_number(user, "设置持续时间", "失同步器", duration / 10, max_duration, 5)
	if(!new_duration || QDELETED(user) || QDELETED(src) || !user.can_perform_action(src, NEED_DEXTERITY))
		return CLICK_ACTION_BLOCKING
	duration = new_duration
	to_chat(user, span_notice("你将持续时间设置为[DisplayTimeText(duration)]。"))
	return CLICK_ACTION_SUCCESS

/obj/item/desynchronizer/proc/desync(mob/living/user)
	if(sync_holder)
		return
	sync_holder = new(drop_location())
	new /obj/effect/temp_visual/desynchronizer(drop_location())
	to_chat(user, span_notice("你激活了[src]，将自己与当前时刻去同步。你仍能看到周围环境，但感到一种怪异的与现实脱节感。"))
	user.forceMove(sync_holder)
	last_use = world.time
	icon_state = "desynchronizer-on"
	resync_timer = addtimer(CALLBACK(src, PROC_REF(resync)), duration , TIMER_STOPPABLE)

/obj/item/desynchronizer/proc/resync()
	new /obj/effect/temp_visual/desynchronizer(sync_holder.drop_location())
	QDEL_NULL(sync_holder)
	if(resync_timer)
		deltimer(resync_timer)
		resync_timer = null
	icon_state = initial(icon_state)
	next_use = world.time + (world.time - last_use) // Could be 2*world.time-last_use but that would just be confusing

/obj/item/desynchronizer/Destroy()
	if(sync_holder)
		resync()
	return ..()

/obj/effect/abstract/sync_holder
	name = "去同步口袋"
	desc = "时空中的一个口袋，将使用者保持在未来的一瞬间。"
	icon = null
	icon_state = null
	alpha = 0
	invisibility = INVISIBILITY_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE

/obj/effect/abstract/sync_holder/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_SECLUDED_LOCATION, INNATE_TRAIT)

/obj/effect/abstract/sync_holder/relaymove(mob/living/user, direction)
	// While faded out of spacetime, no, you cannot move.
	return

/obj/effect/abstract/sync_holder/Destroy()
	for(var/I in contents)
		var/atom/movable/AM = I
		AM.forceMove(drop_location())
	return ..()

/obj/effect/abstract/sync_holder/AllowDrop()
	return TRUE //no dropping spaghetti out of your spacetime pocket
