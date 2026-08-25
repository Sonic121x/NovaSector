#define X_STAND_OPEN_STATE "open"
#define X_STAND_CLOSED_STATE "close"

/obj/structure/bed/bdsm_bed
	name = "bdsm bed"
	desc = "A latex bed with D-rings on the sides. Looks comfortable."
	icon = 'modular_nova/modules/modular_items/lewd_items/icons/obj/lewd_structures/bdsm_furniture.dmi'
	icon_state = "bdsm_bed"
	max_integrity = 50

/obj/item/bdsm_bed_kit
	name = "bdsm bed construction kit"
	icon = 'modular_nova/modules/modular_items/lewd_items/icons/obj/lewd_structures/bdsm_furniture.dmi'
	throwforce = 0
	icon_state = "bdsm_bed_kit"
	w_class = WEIGHT_CLASS_HUGE

/obj/item/bdsm_bed_kit/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/tool_blocker, TOOL_WRENCH, TOOL_ACT_SECONDARY)

/obj/item/bdsm_bed_kit/click_ctrl_shift(mob/user)
	add_fingerprint(user)
	if((item_flags & IN_INVENTORY) || (item_flags & IN_STORAGE))
		return

	to_chat(user, span_notice(LANG("obj.b6068d4a545f1cbb", null)))
	if(!do_after(user, 8 SECONDS, src))
		to_chat(user, span_warning(LANG("obj.cf42f374c8ee7ed7", list(src))))
		return

	to_chat(user, span_notice(LANG("obj.8abb2b269935cec3", list(src))))
	var/obj/structure/bed/bdsm_bed/assembled_bed = new
	assembled_bed.forceMove(loc)
	qdel(src)


/obj/item/bdsm_bed_kit/examine(mob/user)
	. = ..()
	. += span_purple(LANG("obj.aa88977b63c97be7", list(src, src)))

/obj/structure/bed/bdsm_bed/post_buckle_mob(mob/living/affected_mob)
	density = TRUE
	//Push them up from the normal lying position
	affected_mob.add_offsets(type, y_add = 6)

/obj/structure/bed/bdsm_bed/post_unbuckle_mob(mob/living/affected_mob)
	density = FALSE
	//Set them back down to the normal lying position
	affected_mob.remove_offsets(type)

/obj/structure/bed/bdsm_bed/click_ctrl_shift(mob/user)
	add_fingerprint(user)
	to_chat(user, span_notice(LANG("obj.a6fe25de55760e8a", list(src))))
	if(!do_after(user, 8 SECONDS, src))
		to_chat(user, span_warning(LANG("obj.ff0e3819c8e8ff33", list(src))))
		return

	to_chat(user, span_notice(LANG("obj.fd5c1c1d92627348", list(src))))
	var/obj/item/construction_kit/bdsm/bed/created_kit = new
	created_kit.forceMove(loc)
	qdel(src)


/obj/structure/bed/bdsm_bed/Destroy()
	unbuckle_all_mobs(TRUE)
	return ..()

/obj/structure/bed/bdsm_bed/examine(mob/user)
	. = ..()
	. += span_purple(LANG("obj.c1a93939eb9daced", list(src)))

/*
*	X-STAND
*/

/obj/structure/chair/x_stand
	name = "x stand"
	desc = "A stand for buckling people in an X shape."
	icon = 'modular_nova/modules/modular_items/lewd_items/icons/obj/lewd_structures/bdsm_furniture.dmi'
	icon_state = "xstand_open"
	base_icon_state = "xstand"
	max_buckled_mobs = 1
	max_integrity = 75
	///What state is the stand currently in? This is here for sprites.
	var/stand_state = "open"
	///What overlay is the stand using when stand_state is set to closed?
	var/static/mutable_appearance/xstand_overlay = mutable_appearance('modular_nova/modules/modular_items/lewd_items/icons/obj/lewd_structures/bdsm_furniture.dmi', "xstand_overlay", LYING_MOB_LAYER)
	///What human is currently buckled in?
	var/mob/living/carbon/human/current_mob = null
	item_chair = null

//to make it have model when we constructing the thingy
/obj/structure/chair/x_stand/Initialize(mapload)
	. = ..()
	update_icon_state()
	update_icon()

/obj/structure/chair/x_stand/Destroy()
	if(current_mob)
		if(current_mob.handcuffed)
			current_mob.handcuffed.dropped(current_mob)
		current_mob.set_handcuffed(null)
		current_mob.update_abstract_handcuffed()
	unbuckle_all_mobs(TRUE)
	return ..()

/obj/structure/chair/x_stand/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[stand_state? "open" : "close"]"

//X-Stand LBM interaction handler
/obj/structure/chair/x_stand/attack_hand(mob/living/user)
	if(has_buckled_mobs())
		var/mob/living/buckled_mob = buckled_mobs[1]
		user_unbuckle_mob(buckled_mob, user)
		return TRUE

	var/mob/living/affected_mob = locate() in loc
	if(!affected_mob)
		toggle_mode(user)
		return TRUE

	// Can a mob in a X-Stand tile be buckled?
	if(affected_mob.can_buckle_to)
		user_buckle_mob(affected_mob, user, check_loc = TRUE)
		return TRUE
	else
		return FALSE

// Another plug to disable rotation
/obj/structure/chair/x_stand/attack_tk(mob/user)
	return FALSE

// Handler for attempting to unbuckle a mob from a X-Stand
/obj/structure/chair/x_stand/user_unbuckle_mob(mob/living/buckled_mob, mob/living/user)
	// Let's make sure that the X-Stand is in the correct state
	if(stand_state == X_STAND_OPEN_STATE)
		toggle_mode(user)

	if(!buckled_mob)
		return FALSE

	if(buckled_mob != user)
		if(!do_after(user, 5 SECONDS, buckled_mob)) // Timer for unbuckling one mob with another mob
			to_chat(user, span_warning(LANG("obj.da90255e7c18f314", list(buckled_mob, src))))
			return FALSE

		buckled_mob.visible_message(span_notice(LANG("obj.c58c7a9a6886c982", list(user, buckled_mob, src))),\
			span_notice(LANG("obj.8a13b258f2a1952b", list(user, src))),\
			span_hear(LANG("obj.4ea246f9d4c98190", null)))

	else
		if(!do_after(user, 10 SECONDS, buckled_mob)) // Timer for unbuckling one mob with another mob
			to_chat(user, span_warning(LANG("obj.f7cd4294c247412a", list(src))))
			return FALSE

		user.visible_message(span_notice(LANG("obj.bd5bbd6c6da394e8", list(src))),\
			span_hear(LANG("obj.4ea246f9d4c98190", null)))

	unbuckle_mob(buckled_mob)

	add_fingerprint(user)
	if(isliving(buckled_mob.pulledby))
		var/mob/living/pulling_mob = buckled_mob.pulledby
		pulling_mob.set_pull_offsets(buckled_mob, buckled_mob.grab_state)

	toggle_mode(user)
	return buckled_mob

// Handler for attempting to buckle a mob into a X-Stand
/obj/structure/chair/x_stand/user_buckle_mob(mob/living/affected_mob, mob/user, check_loc = TRUE)
	if(stand_state == X_STAND_CLOSED_STATE)
		toggle_mode(user)
		//return  // Uncomment if it is necessary to "open" the X-Stand as a separate action before buckling

	// Is buckling even possible? Do a full suite of checks.
	if(!is_user_buckle_possible(affected_mob, user, check_loc))
		return FALSE
	add_fingerprint(user)

	if(affected_mob == user)
		if(!do_after(user, 10 SECONDS, affected_mob)) // Timer to buckle the mob itself
			to_chat(user, span_warning(LANG("obj.47a77d50f0c0d7fc", list(src))))
			return FALSE

		if(!is_user_buckle_possible(affected_mob, user, check_loc))
			to_chat(user, span_warning(LANG("obj.38c692614aa8492c", list(src))))
			return FALSE

		if(buckle_mob(affected_mob, check_loc = check_loc))
			user.visible_message(span_warning(LANG("obj.9875516508ff98ea", list(src))),\
				span_hear(LANG("obj.4ea246f9d4c98190", null)))

		toggle_mode(user)
		return TRUE

	affected_mob.visible_message(span_warning(LANG("obj.fd9e0033b392397a", list(user, affected_mob, src))),\
		span_userdanger(LANG("obj.1b8e86bdd51562de", list(user, src))),\
		span_hear(LANG("obj.4ea246f9d4c98190", null)))

	if(!do_after(user, 5 SECONDS, affected_mob)) // Timer to buckle one mob by another
		to_chat(user, span_warning(LANG("obj.17254991aa53fbb3", list(affected_mob, src))))
		return FALSE

	// Sanity check before we attempt to buckle. Is everything still in a kosher state for buckling after the 3 seconds have elapsed?
	// Covers situations where, for example, the chair was moved or there's some other issue.
	if(!is_user_buckle_possible(affected_mob, user, check_loc))
		to_chat(user, span_warning(LANG("obj.788b17318d83a1ea", list(affected_mob, src))))
		return FALSE

	// Place to insert a description of a successful attempt for a user mob
	if(!buckle_mob(affected_mob, check_loc = check_loc))
		return FALSE

	affected_mob.visible_message(span_warning(LANG("obj.399356cfe74745a5", list(user, affected_mob, src))),\
		span_userdanger(LANG("obj.6436c1250a47c6df", list(user, src))),\
		span_hear(LANG("obj.4ea246f9d4c98190", null)))

	toggle_mode(user)
	return TRUE

// X-Stand state switch processing
/obj/structure/chair/x_stand/proc/toggle_mode(mob/user)
	if(stand_state == X_STAND_CLOSED_STATE)
		stand_state = X_STAND_OPEN_STATE
		cut_overlay(xstand_overlay)
	else
		stand_state = X_STAND_CLOSED_STATE
		add_overlay(xstand_overlay)

	add_fingerprint(user)
	update_icon_state()
	update_icon()
	playsound_if_pref(loc, 'sound/items/weapons/magin.ogg', 20, TRUE)

//Place the mob in the desired position after buckling
/obj/structure/chair/x_stand/post_buckle_mob(mob/living/affected_mob)
	affected_mob.layer = BELOW_MOB_LAYER

	if(LAZYLEN(buckled_mobs))
		if(ishuman(buckled_mobs[1]))
			current_mob = buckled_mobs[1]

	if(!current_mob)
		return FALSE

	if(current_mob.handcuffed)
		current_mob.handcuffed.forceMove(loc)
		current_mob.handcuffed.dropped(current_mob)
		current_mob.set_handcuffed(null)

	var/obj/item/restraints/handcuffs/milker/cuffs = new (current_mob)
	current_mob.set_handcuffed(cuffs)
	cuffs.parent_chair = WEAKREF(src)
	current_mob.update_abstract_handcuffed()

//Restore the position of the mob after unbuckling.
/obj/structure/chair/x_stand/post_unbuckle_mob(mob/living/affected_mob)
	affected_mob.layer = initial(affected_mob.layer)

	if(!current_mob)
		return FALSE

	if(current_mob.handcuffed)
		current_mob.handcuffed.dropped(current_mob)

	current_mob.set_handcuffed(null)
	current_mob.update_abstract_handcuffed()
	current_mob = null

/*
*	X-STAND CONSTRUCTION KIT
*/

/obj/structure/chair/x_stand/click_ctrl_shift(mob/user)
	add_fingerprint(user)
	to_chat(user, span_notice(LANG("obj.54379957af76d742", list(src))))
	if(!do_after(user, 8 SECONDS, src))
		return

	to_chat(user, span_notice(LANG("obj.fd5c1c1d92627348", list(src))))
	new /obj/item/construction_kit/bdsm/x_stand(loc)
	unbuckle_all_mobs()
	qdel(src)

/obj/structure/chair/x_stand/examine(mob/user)
	. = ..()
	. += span_purple(LANG("obj.c1a93939eb9daced", list(src)))

#undef X_STAND_CLOSED_STATE
#undef X_STAND_OPEN_STATE
