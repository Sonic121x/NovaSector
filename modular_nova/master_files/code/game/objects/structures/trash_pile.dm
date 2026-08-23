/obj/structure/trash_pile
	name = "trash pile"
	desc = "A heap of garbage, but maybe there's something interesting inside?"
	icon = 'modular_nova/master_files/icons/obj/trash_piles.dmi'
	icon_state = "randompile"
	density = TRUE
	anchored = TRUE
	layer = TABLE_LAYER
	obj_flags = CAN_BE_HIT
	pass_flags = LETPASSTHROW

	max_integrity = 50

	var/hide_person_time = 30
	var/hide_item_time = 15

	var/list/searchedby	= list()// Characters that have searched this trashpile, with values of searched time.

/obj/structure/trash_pile/Initialize(mapload)
	. = ..()
	icon_state = pick(
		"pile1",
		"pile2",
		"pilechair",
		"piletable",
		"pilevending",
		"brtrashpile",
		"microwavepile",
		"rackpile",
		"boxfort",
		"trashbag",
		"brokecomp",
	)

/obj/structure/trash_pile/proc/do_search(mob/user)
	if(contents.len) // There's something hidden
		var/atom/hidden_atom = contents[contents.len] // Get the most recent hidden thing
		if(istype(hidden_atom, /mob/living))
			var/mob/living/hidden_mob = hidden_atom
			balloon_alert(user, LANG("obj.35409d7b75673723", null))
			eject_mob(hidden_mob)
		else if (istype(hidden_atom, /obj/item))
			var/obj/item/hidden_item = hidden_atom
			balloon_alert(user, LANG("obj.7e56583099c9d50c", null))
			hidden_item.forceMove(src.loc)
	else
		// You already searched this one bruh
		if(user.ckey in searchedby)
			balloon_alert(user, LANG("obj.7dc6742f701ef0d2", null))
		// You found an item!
		else
			produce_alpha_item()
			balloon_alert(user, LANG("obj.7e56583099c9d50c", null))
			searchedby += user.ckey

/obj/structure/trash_pile/attack_hand(mob/user)
	// Human mob
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		human_user.visible_message(LANG("obj.942cd352a507bfa3", list(user, src)), span_notice(LANG("obj.afc32f9f32325a87", list(src))))
		// Do the searching
		if(do_after(user, rand(4 SECONDS, 6 SECONDS), target = src))
			if(src.loc) // Let's check if the pile still exists
				do_search(user)
	else
		return ..()

// Random lists
/obj/structure/trash_pile/proc/produce_alpha_item()
	var/lootspawn = pick_weight(GLOB.maintenance_loot)
	while(islist(lootspawn))
		lootspawn = pick_weight(lootspawn)
	var/obj/item/hidden_item = new lootspawn(get_turf(src))
	return hidden_item

/obj/structure/trash_pile/mouse_drop_receive(atom/dropping, mob/user, params)
	if(user == dropping && iscarbon(dropping))
		var/mob/living/dropped_mob = dropping
		if(dropped_mob.mobility_flags & MOBILITY_MOVE)
			dive_in_pile(user)
			return

/obj/structure/trash_pile/proc/eject_mob(mob/living/hidden_mob)
	hidden_mob.forceMove(src.loc)
	playsound(hidden_mob.loc, 'sound/machines/chime.ogg', 50, FALSE, -5)
	hidden_mob.do_alert_animation(hidden_mob)

/obj/structure/trash_pile/proc/do_dive(mob/user)
	if(contents.len)
		for(var/mob/hidden_mob in contents)
			balloon_alert(user, LANG("obj.211eaf51941f2fcd", null))
			eject_mob(hidden_mob)
			return FALSE
	return TRUE

/obj/structure/trash_pile/proc/dive_in_pile(mob/user)
	user.visible_message(span_warning(LANG("obj.625b9c5839be77b7", list(user, src))), \
								span_notice(LANG("obj.bb4c711c9389c8bd", list(src))))
	var/adjusted_dive_time = hide_person_time
	if(HAS_TRAIT(user, TRAIT_RESTRAINED)) // hiding takes twice as long when restrained.
		adjusted_dive_time *= 2

	if(do_after(user, adjusted_dive_time, user))
		if(src.loc) // Checking if structure has been destroyed
			if(do_dive(user))
				user.forceMove(src)

/obj/structure/trash_pile/proc/can_hide_item(obj/item/hidden_item)
	if(contents.len > 10)
		return FALSE
	return TRUE

/obj/structure/trash_pile/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!user.combat_mode)
		if(can_hide_item(tool))
			balloon_alert(user, LANG("obj.cece4dc64d0437c7", null))
			if(do_after(user, hide_item_time, user))
				if(src.loc)
					if(user.transferItemToLoc(tool, src))
						balloon_alert(user, LANG("obj.b32906e0164ee3fc", null))
					else
						balloon_alert(user, LANG("obj.f84f0f5d8dcd2ecb", null))
		else
			balloon_alert(user, LANG("obj.2cb7d3546d66854d", null))
		return ITEM_INTERACT_SUCCESS

	. = ..()

/obj/structure/trash_pile/Destroy()
	for(var/atom/movable/pile_contents in src)
		pile_contents.forceMove(src.loc)
	return ..()

/obj/structure/trash_pile/container_resist_act(mob/user)
	user.forceMove(src.loc)

/obj/structure/trash_pile/relaymove(mob/user)
	container_resist_act(user)
