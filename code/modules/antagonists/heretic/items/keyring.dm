/obj/effect/lock_portal
	name = "现实裂隙"
	desc = "一道空间裂隙，深不可测且令人目眩。绝对不安全。"
	icon = 'icons/effects/eldritch.dmi'
	icon_state = "realitycrack"
	light_system = COMPLEX_LIGHT
	light_power = 1
	light_on = TRUE
	light_color = COLOR_GREEN
	light_range = 3
	opacity = TRUE
	density = FALSE //so we dont block doors closing
	layer = OBJ_LAYER //under doors
	///The knock portal we teleport to
	var/obj/effect/lock_portal/destination
	///The airlock we are linked to, we delete if it is destroyed
	var/obj/machinery/door/our_airlock
	/// if true the heretic is teleported to a random airlock, nonheretics are sent to the target
	var/inverted = FALSE

/obj/effect/lock_portal/Initialize(mapload, target, invert = FALSE)
	. = ..()
	if(target)
		our_airlock = target
		RegisterSignal(target, COMSIG_QDELETING, PROC_REF(delete_on_door_delete))

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)
	inverted = invert

///Deletes us and our destination portal if our_airlock is destroyed
/obj/effect/lock_portal/proc/delete_on_door_delete(datum/source)
	SIGNAL_HANDLER
	qdel(src)

///Signal handler for when our location is entered, calls teleport on the victim, if their old_loc didnt contain a portal already (to prevent loops)
/obj/effect/lock_portal/proc/on_entered(datum/source, mob/living/loser, atom/old_loc)
	SIGNAL_HANDLER
	if(istype(loser) && !(locate(type) in old_loc))
		teleport(loser)

/obj/effect/lock_portal/Destroy()
	if(!isnull(destination) && !QDELING(destination))
		QDEL_NULL(destination)

	destination = null
	our_airlock = null
	return ..()

///Teleports the teleportee, to a random airlock if the teleportee isnt a heretic, or the other portal if they are one
/obj/effect/lock_portal/proc/teleport(mob/living/teleportee)
	if(isnull(destination)) //dumbass
		qdel(src)
		return

	if(SSmapping.level_trait(z, ZTRAIT_NOPHASE) || SSmapping.level_trait(destination.z, ZTRAIT_NOPHASE))
		qdel(src)
		return

	//get it?
	var/obj/machinery/door/doorstination = (inverted ? !IS_HERETIC_OR_MONSTER(teleportee) : IS_HERETIC_OR_MONSTER(teleportee)) ? destination.our_airlock : find_random_airlock()
	if(!do_teleport(teleportee, get_turf(doorstination), channel = TELEPORT_CHANNEL_MAGIC))
		return

	teleportee.client?.move_delay = 0 //make moving through smoother

	if(!IS_HERETIC_OR_MONSTER(teleportee))
		teleportee.apply_damage(20, BRUTE) //so they dont roll it like a jackpot machine to see if they can land in the armory
		to_chat(teleportee, span_userdanger("你踉跄地穿过[src]，被超越你理解的力量所冲击，落到了一个完全出乎意料的地方。"))

	INVOKE_ASYNC(src, PROC_REF(async_opendoor), doorstination)

///Returns a random airlock on the same Z level as our portal, that isnt our airlock
/obj/effect/lock_portal/proc/find_random_airlock()
	var/list/turf/possible_destinations = list()
	for(var/obj/airlock as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/door/airlock))
		if(airlock.z != z)
			continue
		if(airlock.loc == loc)
			continue
		var/area/airlock_area = get_area(airlock)
		if(airlock_area.area_flags & NOTELEPORT)
			continue
		possible_destinations += airlock
	return pick(possible_destinations)

///Asynchronous proc to unbolt, then open the passed door
/obj/effect/lock_portal/proc/async_opendoor(obj/machinery/door/door)
	if(istype(door, /obj/machinery/door/airlock)) //they can create portals on ANY door, but we should unlock airlocks so they can actually open
		var/obj/machinery/door/airlock/as_airlock = door
		as_airlock.unbolt()
	door.open()

///An ID card capable of shapeshifting to other IDs given by the Key Keepers Burden knowledge
/obj/item/card/id/advanced/heretic
	access = list(ACCESS_HERETIC)
	///List of IDs this card consumed
	var/list/obj/item/card/id/fused_ids = list()
	///The first portal in the portal pair, so we can clear it later
	var/obj/effect/lock_portal/portal_one
	///The second portal in the portal pair, so we can clear it later
	var/obj/effect/lock_portal/portal_two
	///The first door we are linking in the pair, so we can create a portal pair
	var/datum/weakref/link
	/// are our created portals inverted? (heretics get sent to a random airlock, crew get sent to the target)
	var/inverted = FALSE

/obj/item/card/id/advanced/heretic/examine(mob/user)
	. = ..()
	if(!IS_HERETIC_OR_MONSTER(user))
		return
	. += span_hypnophrase("受曼苏斯附魔！")
	. += span_hypnophrase("将另一张ID卡用于此卡或将此卡用于另一张ID卡会消耗它，并允许你复制其访问权限。")
	. += span_hypnophrase("<b>在手中使用此卡</b>可以改变其外观。")
	. += span_hypnophrase("<b>将此卡用于一对门</b>，可以将它们链接在一起。进入一扇门会将你传送到另一扇门，而异教徒则会被传送到一个随机的气闸门。")
	. += span_hypnophrase("<b>按住Ctrl点击此ID卡</b>，会使ID卡创建反向传送门，将你传送到站内一个随机的气闸门，而异教徒则会被传送到目的地。")

/obj/item/card/id/advanced/heretic/attack_self(mob/user)
	. = ..()
	if(!IS_HERETIC(user))
		return
	var/cardname = tgui_input_list(user, "变形为？", "变形", fused_ids)
	if(!cardname)
		balloon_alert(user, "没有选项！")
		return ..()
	var/obj/item/card/id/card = fused_ids[cardname]
	shapeshift(card)

/obj/item/card/id/advanced/heretic/item_ctrl_click(mob/user)
	if(!IS_HERETIC(user))
		return CLICK_ACTION_BLOCKING
	inverted = !inverted
	balloon_alert(user, "[inverted ? "now" : "no longer"]制造反转裂隙")
	return CLICK_ACTION_SUCCESS

///Changes our appearance to the passed ID card
/obj/item/card/id/advanced/heretic/proc/shapeshift(obj/item/card/id/advanced/card)
	trim = card.trim
	if(ishuman(loc))
		var/mob/living/carbon/human/wearing = loc
		wearing.update_ID_card()
	assignment = card.assignment
	registered_age = card.registered_age
	registered_name = card.registered_name
	icon_state = card.icon_state
	inhand_icon_state = card.inhand_icon_state
	assigned_icon_state = card.assigned_icon_state
	name = card.name //not update_label because of the captains spare moment
	update_icon()

///Deletes and nulls our portal pair
/obj/item/card/id/advanced/heretic/proc/clear_portals()
	QDEL_NULL(portal_one)
	QDEL_NULL(portal_two)

///Clears portal references
/obj/item/card/id/advanced/heretic/proc/clear_portal_refs()
	SIGNAL_HANDLER
	portal_one = null
	portal_two = null

///Creates a portal pair at door1 and door2, displays a balloon alert to user
/obj/item/card/id/advanced/heretic/proc/make_portal(mob/user, obj/machinery/door/door1, obj/machinery/door/door2)
	var/message = "linked"
	if(portal_one || portal_two)
		clear_portals()
		message += ", previous cleared"

	portal_one = new(get_turf(door2), door2, inverted)
	portal_two = new(get_turf(door1), door1, inverted)
	portal_one.destination = portal_two
	RegisterSignal(portal_one, COMSIG_QDELETING, PROC_REF(clear_portal_refs))  //we only really need to register one because they already qdel both portals if one is destroyed
	portal_two.destination = portal_one
	balloon_alert(user, "[message]")

/obj/item/card/id/advanced/heretic/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/card/id/advanced) || !IS_HERETIC(user))
		return ..()
	eat_card(tool, user)
	return ITEM_INTERACT_SUCCESS

/obj/item/card/id/advanced/heretic/proc/eat_card(obj/item/card/id/card, mob/user)
	if(card == src)
		return //no self vore
	fused_ids[card.name] = card
	card.moveToNullspace()
	access |= card.access
	if(!isnull(user))
		playsound(drop_location(), 'sound/items/eatfood.ogg', rand(10,30), TRUE)
		balloon_alert(user, "已吞噬卡片")

/obj/item/card/id/advanced/heretic/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	if(!IS_HERETIC(user))
		return NONE
	if(istype(target, /obj/item/card/id/advanced))
		eat_card(target, user)
		return ITEM_INTERACT_SUCCESS
	if(istype(target, /obj/effect/lock_portal))
		clear_portals()
		return ITEM_INTERACT_SUCCESS
	if(!istype(target, /obj/machinery/door))
		return NONE
	if(SSmapping.level_trait(target.z, ZTRAIT_NOPHASE))
		return NONE
	var/reference_resolved = link?.resolve()
	if(reference_resolved == target)
		return ITEM_INTERACT_BLOCKING

	if(reference_resolved)
		make_portal(user, reference_resolved, target)
		to_chat(user, span_notice("你使用[src]，将[reference_resolved]和[target]链接在一起。"))
		link = null
		balloon_alert(user, "链接 2/2")
	else
		link = WEAKREF(target)
		balloon_alert(user, "链接 1/2")
	return ITEM_INTERACT_SUCCESS

/obj/item/card/id/advanced/heretic/Destroy()
	QDEL_LIST_ASSOC_VAL(fused_ids)
	link = null
	clear_portals()
	return ..()
