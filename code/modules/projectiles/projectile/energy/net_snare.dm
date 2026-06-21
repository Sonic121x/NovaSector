/obj/projectile/energy/snare
	name = "能量陷阱"
	icon_state = "e_netting"
	damage = 30
	damage_type = STAMINA
	hitsound = 'sound/items/weapons/taserhit.ogg'
	range = 10

/obj/projectile/energy/snare/Initialize(mapload)
	. = ..()
	SpinAnimation()

/obj/projectile/energy/snare/on_hit(atom/target, blocked = 0, pierce_hit)
	var/obj/item/dragnet_beacon/destination_beacon = null
	var/obj/item/gun/energy/e_gun/dragnet/our_dragnet = fired_from
	if(our_dragnet && istype(our_dragnet))
		destination_beacon = our_dragnet.linked_beacon

	if(isliving(target))
		var/mob/living/living_target = target
		living_target.adjust_staggered_up_to(STAGGERED_SLOWDOWN_LENGTH * 0.5, 5 SECONDS)
		for(var/turf/trapped_turf in range(1, get_turf(living_target)))
			if(trapped_turf.density)
				continue
			new /obj/effect/nettingportal(trapped_turf, destination_beacon)

	. = ..()

/obj/projectile/energy/snare/on_range()
	do_sparks(1, TRUE, src)
	. = ..()

/obj/effect/nettingportal
	name = "网枪传送场"
	desc = "蓝空能量场，锁定传送目标。"
	icon = 'icons/effects/effects.dmi'
	icon_state = "dragnetfield"
	light_range = 3
	anchored = TRUE

/obj/effect/nettingportal/Initialize(mapload, destination_beacon)
	. = ..()
	var/obj/item/dragnet_beacon/teletarget = destination_beacon
	addtimer(CALLBACK(src, PROC_REF(pop), teletarget), 3 SECONDS)

/obj/effect/nettingportal/proc/pop(teletarget)
	if(teletarget)
		for(var/mob/living/living_mob in get_turf(src))
			do_teleport(living_mob, get_turf(teletarget), 1, channel = TELEPORT_CHANNEL_BLUESPACE) //Teleport what's in the tile to the beacon
	else
		for(var/mob/living/living_mob in get_turf(src))
			do_teleport(living_mob, get_turf(living_mob), 15, channel = TELEPORT_CHANNEL_BLUESPACE) //Otherwise it just warps you off somewhere.

	qdel(src)

/obj/effect/nettingportal/singularity_act()
	return

/obj/effect/nettingportal/singularity_pull(atom/singularity, current_size)
	return

/obj/item/dragnet_beacon
	name = "\improper DRAGnet 信标"
	desc = "可以与 DRAGnet 同步，将其设置为指定的传送点。"
	icon = 'icons/obj/devices/tracker.dmi'
	icon_state = "dragnet_beacon"
	inhand_icon_state = "beacon"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	///Has a security ID been used to lock this in place?
	var/locked = FALSE

/obj/item/dragnet_beacon/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/gun/energy/e_gun/dragnet))
		var/obj/item/gun/energy/e_gun/dragnet/dragnet_to_link = tool
		dragnet_to_link.link_beacon(user, src)
		return

	if(isidcard(tool))
		if(!anchored)
			balloon_alert(user, "先用扳手固定信标！")
			return

		if(obj_flags & EMAGGED)
			balloon_alert(user, "访问控制烧坏了！")
			return

		var/obj/item/card/id/id_card = tool
		if((ACCESS_SECURITY in id_card.GetAccess()))
			locked = !locked
			balloon_alert(user, "信标[locked ? "locked" : "unlocked"]")
		else
			balloon_alert(user, "没有访问权限！")

/obj/item/dragnet_beacon/wrench_act(mob/living/user, obj/item/tool)
	if(user.is_holding(src))
		balloon_alert(user, "先把它放下！")
		return ITEM_INTERACT_BLOCKING

	if(anchored && locked)
		balloon_alert(user, "必须先解锁！")
		return ITEM_INTERACT_BLOCKING

	if(isinspace() && !anchored)
		balloon_alert(user, "没有可固定的地方！")
		return ITEM_INTERACT_BLOCKING

	set_anchored(!anchored)
	tool.play_tool_sound(src, 75)
	user.balloon_alert_to_viewers("[anchored ? "anchored" : "unanchored"]")

/obj/item/dragnet_beacon/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	obj_flags |= EMAGGED
	locked = FALSE
	set_anchored(FALSE)
	do_sparks(3, TRUE, src)
	balloon_alert(user, "信标已解锁")
	return TRUE
